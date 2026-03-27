cat << 'EOF' > wrap_engine.py
import cv2
import numpy as np

def apply_3d_wrap(frame, strength=0.5, zoom=1.0):
    """Action: Apply the 3D Perspective Wrap (Mapping Math)"""
    width, height = frame.shape[1], frame.shape[0]
    
    # 1. Initialize the Transformation Matrix (The 'Object' state)
    dist_coeff = np.zeros((4, 1))
    # Adjust K to change the 'FOV' or Wrap intensity
    k = np.array([[width * zoom, 0, width / 2],
                  [0, height * zoom, height / 2],
                  [0, 0, 1]])
                  
    # 2. Map the 2D image to a 3D Sphere (The 'Skia' Logic)
    new_camera_matrix, _ = cv2.getOptimalNewCameraMatrix(k, dist_coeff, (width, height), 1, (width, height))
    map_x, map_y = cv2.initUndistortRectifyMap(k, dist_coeff, None, new_camera_matrix, (width, height), cv2.CV_32FC1)
    
    # 3. Final Render: The 'Backfeed' to the Monitor
    wrapped_frame = cv2.remap(frame, map_x, map_y, cv2.INTER_LINEAR)
    return wrapped_frame

def stream_to_vlc(ip_address):
    url = f"rtsp://{ip_address}:8554/mjpeg/1"
    cap = cv2.VideoCapture(url)
    
    while True:
        ret, frame = cap.read()
        if not ret: break
        
        # Apply the 3D Stencil/Wrap
        view = apply_3d_wrap(frame)
        
        cv2.imshow("Jarvis: StreetView Live Feed", view)
        if cv2.waitKey(1) & 0xFF == ord('q'): break
    cap.release()
EOF