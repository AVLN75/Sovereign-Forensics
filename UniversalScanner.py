import serial.tools.list_ports
import subprocess
import os

def scan_all():
    print("--- [IoT SCANNER: WIRELESS | SERIAL | CANBUS] ---")
    
    # 1. Serial Port Scanner
    print("\n[SERIAL]")
    ports = list(serial.tools.list_ports.comports())
    if not ports: print("No serial ports found.")
    for p in ports: print(f"  -> {p}")

    # 2. Wireless Scanner (WiFi/BLE)
    print("\n[WIRELESS]")
    try:
        subprocess.run(["netsh", "wlan", "show", "networks"], check=True)
    except:
        print("Wireless interface not accessible.")

    # 3. CANbus Check (Virtual/Hardware)
    print("\n[CANBUS/GPIO]")
    if os.name != 'nt': # If running on the PinePhone/Linux
        os.system("ip link show can0 || echo 'No CAN hardware detected'")
    else:
        print("CANbus scanning requires SocketCAN (Linux/PinePhone side).")

if __name__ == "__main__":
    scan_all()
