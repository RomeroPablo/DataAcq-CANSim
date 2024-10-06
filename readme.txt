Enable Python Virtual Environment
  $ source bin/activate

Dependencies:
  $ pip install python-can

please ensure you have the 'vcan' kernel module available on your linux system

please not if you have recently upgraded your kernel, you may be required to reboot your system or the script will fail
please ensure the existence of '/usr/lib/modules/$(uname -r)'

Create a virtual CAN interface:
  $ sudo modprobe vcan 
  $ sudo ip link add dev vcan0 type vcan
  $ sudo ip link set up vcan0

1. create vcan module
2. add network device 'vcan0' of type 'vcan'
3. enable 'vcan0'

write to vcan0 : 
  $ cansend vcan0 123#DEADBEEF

check vcan0 : 
  $ ip link show vcan0

monitor vcan0 : 
candump vcan0
