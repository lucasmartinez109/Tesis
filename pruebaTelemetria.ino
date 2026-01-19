#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>
#include <Adafruit_ADS1X15.h>

// ================= CONFIGURACIÓN =================

// WiFi
const char* ssid = "lucas";
const char* password = "lucas109";

// MQTT
const char* mqtt_server = "192.168.112.242";
const char* topic_nivel   = "pozos/pozo1/sensores/nivel";
const char* topic_comando = "pozos/pozo1/comandos/bomba";

// GPIOs reales
#define PIN_SDA   4    // GPIO4 (D2)
#define PIN_SCL   5    // GPIO5 (D1)
#define PIN_BOMBA 14   // GPIO14 (D5)

// ADS1115
Adafruit_ADS1115 ads;

WiFiClient espClient;
PubSubClient client(espClient);

// ===== Callback MQTT =====
void callback(char* topic, byte* payload, unsigned int length) {
  String mensaje = "";

  for (unsigned int i = 0; i < length; i++) {
    mensaje += (char)payload[i];
  }

  Serial.print("MQTT recibido [");
  Serial.print(topic);
  Serial.print("]: ");
  Serial.println(mensaje);

  if (String(topic) == topic_comando) {
    if (mensaje == "ON") {
      digitalWrite(PIN_BOMBA, HIGH);
    } else if (mensaje == "OFF") {
      digitalWrite(PIN_BOMBA, LOW);
    }
  }
}

// ===== Reconexión MQTT =====
void reconnectMQTT() {
  while (!client.connected()) {
    Serial.print("Conectando a MQTT...");
    if (client.connect("ESP8266_Pozo1")) {
      Serial.println("OK");
      client.subscribe(topic_comando);
    } else {
      Serial.println("ERROR, reintentando...");
      delay(2000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println("\n--- INICIO ESP8266 ---");

  pinMode(PIN_BOMBA, OUTPUT);
  digitalWrite(PIN_BOMBA, LOW);

  Wire.begin(PIN_SDA, PIN_SCL);

  Serial.println("Inicializando ADS1115...");
  if (!ads.begin()) {
    Serial.println("ERROR: ADS1115 no detectado");
    while (1);
  }
  Serial.println("ADS1115 OK");
  ads.setGain(GAIN_ONE);

  Serial.print("Conectando WiFi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi conectado");
  Serial.print("IP ESP: ");
  Serial.println(WiFi.localIP());

  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnectMQTT();
  }
  client.loop();

  int16_t raw = ads.readADC_SingleEnded(0);
  float voltaje = raw * 4.096 / 32767.0;
  float nivel = voltaje * 1.25;

  Serial.print("RAW: ");
  Serial.print(raw);
  Serial.print(" | V: ");
  Serial.print(voltaje, 3);
  Serial.print(" | Nivel: ");
  Serial.println(nivel, 2);

  char payload[16];
  dtostrf(nivel, 5, 2, payload);
  client.publish(topic_nivel, payload);

  delay(2000);
}
