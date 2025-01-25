#!/bin/bash

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# setup virtual can port
sudo modprobe vcan
sudo ip link add dev vcan0 type vcan
sudo ip link set up vcan0
echo "run : 'candump vcan0' to monitor virtual CAN output"

# Run the Python program
python src/canSIM.py

# Deactivate the virtual environment
deactivate
