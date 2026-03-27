cat << 'EOF' > esp32_cam_firmware.ino
#include "esp_camera.h"
#include <WiFi.h>
#include "esp_http_server.h"

// AI-Thinker Pin Map
#define PWDN_GPIO_NUM     32
#define RESET_GPIO_NUM    -1
#define XCLK_GPIO_NUM      0
#define SIOD_GPIO_NUM     26
#define SIOC_GPIO_NUM     27
#define Y2_GPIO_NUM        5
// ... (Pins 5, 18, 19, 21, 36, 39, 34, 35 for Data)

const char* ssid = "YOUR_WIFI_NAME";
const char* password = "YOUR_WIFI_PASSWORD";

esp_err_t capture_handler(httpd_req_t *req) {
    camera_fb_t * fb = esp_camera_fb_get();
    if (!fb) { httpd_resp_send_500(req); return ESP_FAIL; }
    httpd_resp_set_type(req, "image/jpeg");
    esp_err_t res = httpd_resp_send(req, (const char *)fb->buf, fb->len);
    esp_camera_fb_return(fb);
    return res;
}

void setup() {
    Serial.begin(115200);
    camera_config_t config;
    config.pin_d0 = Y2_GPIO_NUM; 
    // [Internal GPIO Mapping Logic for OV2640]
    esp_camera_init(&config);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) delay(500);
    
    httpd_config_t server_config = HTTPD_DEFAULT_CONFIG();
    httpd_handle_t server = NULL;
    httpd_uri_t capture_uri = { .uri = "/capture", .method = HTTP_GET, .handler = capture_handler };
    if (httpd_start(&server, &server_config) == ESP_OK) httpd_register_uri_handler(server, &capture_uri);
}

void loop() { delay(1000); }
EOF