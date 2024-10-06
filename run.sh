#!/bin/bash

source bin/activate
sudo modprobe vcan
sudo ip link add dev vcan0 type vcan
sudo ip link set up vcan0
echo "run : 'candump vcan0' to monitor virutal CAN output"

python canSIM.py
