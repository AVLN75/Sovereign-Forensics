cat << 'EOF' > mapping.py
import datetime
import requests

class GeoImage:
    def __init__(self, lat, lon, image_path):
        self.lat = lat
        self.lon = lon
        self.path = image_path
        self.time = datetime.datetime.now()

    def generate_kml(self):
        return f"""<Placemark>
            <name>Jarvis Scout {self.time}</name>
            <Point><coordinates>{self.lon},{self.lat}</coordinates></Point>
            <description><![CDATA[<img src='{self.path}' width='300' />]]></description>
        </Placemark>"""

def capture_from_virtual_iot(ip):
    # Action: Backfeed from the monitor/IoT IP
    resp = requests.get(f"http://{ip}/capture")
    filename = f"scout_{int(datetime.datetime.now().timestamp())}.jpg"
    with open(filename, 'wb') as f:
        f.write(resp.content)
    return filename

# Logic for SEC-290 Demo
if __name__ == "__main__":
    img_file = capture_from_virtual_iot("192.168.1.50")
    node = GeoImage(34.0522, -118.2437, img_file)
    print("KML Node Generated for StreetView Mapping:")
    print(node.generate_kml())
EOF