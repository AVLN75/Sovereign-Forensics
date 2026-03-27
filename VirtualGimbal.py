import time
import math

class VirtualLaserGimbal:
    def __init__(self):
        self.pan = 0.0
        self.tilt = 0.0
        self.laser_on = False
        self.target_x = 0.0
        self.target_y = 0.0
        
    def update(self, dt):
        # Simulate motor lag/inertia (Basic P-Control)
        speed = 5.0 
        self.pan += (self.target_x - self.pan) * speed * dt
        self.tilt += (self.target_y - self.tilt) * speed * dt
        
    def fire_laser(self, state):
        self.laser_on = state
        status = "HOT" if state else "SAFE"
        print(f"Laser Status: {status} | Beam at: ({self.pan:.2f}, {self.tilt:.2f})")

# Initialize Virtual Space
gimbal = VirtualLaserGimbal()
last_time = time.time()

print("Virtual 1W Laser Environment Active. Press Ctrl+C to stop.")
try:
    while True:
        now = time.time()
        dt = now - last_time
        last_time = now
        
        # Simulate a moving "Virtual Object" (a circle)
        gimbal.target_x = 45 * math.sin(now)
        gimbal.target_y = 20 * math.cos(now)
        
        gimbal.update(dt)
        gimbal.fire_laser(True if abs(gimbal.pan) < 10 else False)
        time.sleep(0.1)
except KeyboardInterrupt:
    print("\nVirtual Environment Shutdown.")
