#!/bin/bash

# Function to clean up on exit
cleanup() {
    echo "Cleaning up..."
    pkill -P $$  # Kill child processes (socat, Python)
    rm -f /dev/ttyUSB0  # Remove symlink
    echo "Cleanup complete. Exiting."
    exit 0
}

# Trap CTRL+C (SIGINT) to trigger cleanup
trap cleanup SIGINT

# Exit if not as root
if [ $(id -u) -ne 0 ]
    then echo "WARNING: MUST RUN WITH ELEVATED PERMISSIONS"
    exit
fi

# Kill any existing socat processes to avoid conflicts
pkill socat 2>/dev/null

echo "Starting socat to create a virtual UART pair..."
# Start socat and capture its output
SOCAT_LOG=$(mktemp)
socat -d -d pty,raw,echo=0 pty,raw,echo=0 > "$SOCAT_LOG" 2>&1 &
SOCAT_PID=$!

# Wait for socat to initialize
sleep 1

# Extract the two dynamically created pseudo-terminals
PTS_DEVICES=($(grep -o "/dev/pts/[0-9]*" "$SOCAT_LOG" | tail -n 2))

# Ensure both ends of the virtual UART exist
if [[ ${#PTS_DEVICES[@]} -ne 2 ]]; then
    echo "Error: Could not create virtual serial ports."
    cleanup
fi

# Assign the correct ends
TX_DEVICE=${PTS_DEVICES[0]}  # Python writes to this
RX_DEVICE=${PTS_DEVICES[1]}  # This is symlinked as /dev/ttyUSB0

# Create the symlink for /dev/ttyUSB0
chmod +777 "$RX_DEVICE"
ln -sf "$RX_DEVICE" /dev/ttyUSB0
echo "Linked $RX_DEVICE -> /dev/ttyUSB0"

# Show the assigned virtual serial ports
echo "Virtual Serial Port Pair:"
echo "  TX (Python writes here): $TX_DEVICE"
echo "  RX (Linked to /dev/ttyUSB0): $RX_DEVICE"

# Run the Python script with the correct TX device
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

python src/uartSIM.py "$TX_DEVICE" &
PYTHON_PID=$!

# Wait for the Python script to finish or for CTRL+C
wait $PYTHON_PID

# Cleanup when the script exits
cleanup
