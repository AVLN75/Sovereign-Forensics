cat << 'EOF' > esp32_rtsp_camera.ino
#include "src/OV2640.h"
#include <WiFi.h>
#include "src/SimplexMotion.h"
#include "src/CRtspSession.h"
#include "src/Ov2640Streamer.h"

// --- INFRASTRUCTURE: AI-Thinker GPIO ---
#define PWDN_GPIO_NUM     32
#define RESET_GPIO_NUM    -1
#define XCLK_GPIO_NUM      0
#define SIOD_GPIO_NUM     26
#define SIOC_GPIO_NUM     27
// ... (Standard Data Pins 5, 18, 19, 21, 36, 39, 34, 35)

const char* ssid = "YOUR_WIFI_NAME";
const char* password = "YOUR_WIFI_PASSWORD";

OV2640 cam;
WiFiServer rtspServer(8554); // Standard RTSP Port
CStreamer *streamer;

void setup() {
    Serial.begin(115200);
    camera_config_t config;
    config.pin_d0 = 5; // Y2_GPIO_NUM
    // [Insert standard GPIO init here]
    
    cam.init(config);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) delay(500);

    streamer = new Ov2640Streamer(&rtspServer, cam);
    Serial.print("RTSP Stream Ready: rtsp://");
    Serial.print(WiFi.localIP());
    Serial.println(":8554/mjpeg/1");
}

void loop() {
    streamer->handleRequests(0); 
}
EOF