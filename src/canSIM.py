import can
import time

can_bus = can.interface.Bus(interface='socketcan', channel='vcan0', bitrate=500000)
hex = 0x00


def send_can_message():
    global hex

    packet = [hex + 0, hex + 1, hex + 2, hex + 3]
    hex = hex + 1
    hex = hex % 252
    msg = can.Message(arbitration_id=0x123, data=packet, is_extended_id=False)

    try:
        can_bus.send(msg)
        print(f"Message sent on {can_bus.channel_info}")
    except can.CanError:
        print("Message could not be sent")

try:

    while True:
        send_can_message()
        time.sleep(1)
except KeyboardInterrupt:
    print("Shutting down ...")

finally:
    can_bus.shutdown()
