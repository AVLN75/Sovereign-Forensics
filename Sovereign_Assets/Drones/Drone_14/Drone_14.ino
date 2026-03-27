#include "esp_camera.h"
#include <WiFi.h>
#include <ArduinoOTA.h>
#include <HTTPClient.h>

const char* BOT_ID = "Drone_14"; 
void syncCell() {
    HTTPClient http;
    http.begin("http://192.168.1.50/cells/Drone_14/toolbox.txt");
    if (http.GET() == 200) { /* Update Logic */ }
    http.end();
}
void setup() {
    WiFi.begin("SSID", "PASS");
    ArduinoOTA.setHostname(BOT_ID);
    ArduinoOTA.setPassword("5864229114");
    ArduinoOTA.begin();
}
void loop() { ArduinoOTA.handle(); }
