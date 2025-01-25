import sys
import time
import serial
import random

# Ensure the script receives the correct TX device
if len(sys.argv) < 2:
    print("Usage: python your_python_script.py <TX_DEVICE>")
    sys.exit(1)

TX_DEVICE = sys.argv[1]  # Device to send data to

try:
    with serial.Serial(TX_DEVICE, baudrate=115200, timeout=1) as ser:
        print(f"Simulating UART transmission on {TX_DEVICE}")

        while True:
            # Generate a simulated message (3 space-separated integers)
            data = f"{random.randint(-32768, 32767)} {random.randint(-32768, 32767)} {random.randint(-32768, 32767)}\n"
            ser.write(data.encode("utf-8"))
            print(f"Sent: {data.strip()}")
            time.sleep(0.001)  # Send a message every second
except serial.SerialException as e:
    print(f"Error: {e}")
