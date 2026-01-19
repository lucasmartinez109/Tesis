#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>
#include <Adafruit_ADS1X15.h>
#include <math.h>

// ================= CONFIG =================

// WiFi
const char* ssid = "lucas";
const char* password = "lucas109";

// MQTT
const char* mqtt_server  = "192.168.112.242";  // IP ACTUAL de la Raspberry
const char* topic_comando = "pozos/pozo1/comandos/bomba";
const char* topic_estado  = "pozos/pozo1/actuadores/bomba";

// Telemetría (NUEVO)
const char* topic_altura_m = "pozos/pozo1/sensores/altura_m";
// const char* topic_voltaje = "pozos/pozo1/sensores/voltaje"; // (comentado) útil calibración

// GPIO
#define PIN_LED 14   // GPIO14 (D5)

// I2C (ESP8266)
#define PIN_SDA 4    // D2
#define PIN_SCL 5    // D1

// ADS1115
Adafruit_ADS1115 ads;

// ===== Calibración experimental (EN METROS) =====
// Ajustá estos 3 con tus mediciones reales:
const float V0      = 0.319;  // voltaje en aire (0 m)
const float VREF    = 0.339;  // voltaje a profundidad conocida
const float H_REF_M = 0.40;   // profundidad conocida (m)

// Periodo de envío (para probar ponelo corto, ej 2000 ms)
const unsigned long PUB_MS = 5000;

// ================= OBJETOS =================
WiFiClient espClient;
PubSubClient client(espClient);

// ================= CALLBACK MQTT =================
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
      digitalWrite(PIN_LED, HIGH);
      client.publish(topic_estado, "ON");
      Serial.println("LED ENCENDIDO");
    } else if (mensaje == "OFF") {
      digitalWrite(PIN_LED, LOW);
      client.publish(topic_estado, "OFF");
      Serial.println("LED APAGADO");
    }
  }
}

// ================= MQTT RECONNECT =================
void reconnectMQTT() {
  while (!client.connected()) {
    Serial.print("Conectando a MQTT...");
    String clientId = "ESP8266_Pozo1_" + String(ESP.getChipId());

    if (client.connect(clientId.c_str())) {
      Serial.println("OK");
      client.subscribe(topic_comando);
    } else {
      Serial.print("ERROR rc=");
      Serial.print(client.state());
      Serial.println(" reintentando...");
      delay(2000);
    }
  }
}

// ===== Utilidades (NUEVO) =====
float rawToVoltage(int16_t raw) {
  // ADS1115 con GAIN_ONE => ±4.096 V
  return (float)raw * 4.096f / 32768.0f;
}

float voltageToAlturaM(float v) {
  float denom = (VREF - V0);
  if (fabs(denom) < 1e-6) return 0.0f; // evita división por cero

  float h = (v - V0) * (H_REF_M / denom);
  if (h < 0) h = 0;
  return h;
}

// ================= SETUP =================
void setup() {
  Serial.begin(115200);
  delay(1000);

  pinMode(PIN_LED, OUTPUT);
  digitalWrite(PIN_LED, LOW);

  Serial.println("\n--- INICIO ESP8266 ---");

  // I2C + ADS1115 (NUEVO)
  Wire.begin(PIN_SDA, PIN_SCL);
  Serial.println("Inicializando ADS1115...");
  if (!ads.begin()) {
    Serial.println("ERROR: ADS1115 no detectado");
    while (1) delay(1000);
  }
  ads.setGain(GAIN_ONE);
  Serial.println("ADS1115 OK");

  // WiFi
  WiFi.begin(ssid, password);
  Serial.print("Conectando WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi conectado");
  Serial.print("IP ESP: ");
  Serial.println(WiFi.localIP());

  // MQTT
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}

// ================= LOOP =================
void loop() {
  if (!client.connected()) {
    reconnectMQTT();
  }
  client.loop();

  // Envío periódico de telemetría (NUEVO, mínimo)
  static unsigned long last_pub = 0;
  unsigned long now = millis();
  if (now - last_pub >= PUB_MS) {
    last_pub = now;

    int16_t raw = ads.readADC_SingleEnded(0);
    float voltaje = rawToVoltage(raw);
    float altura_m = voltageToAlturaM(voltaje);

    // Debug por serial (opcional pero útil)
    Serial.print("raw=");
    Serial.print(raw);
    Serial.print(" V=");
    Serial.print(voltaje, 4);
    Serial.print(" altura_m=");
    Serial.println(altura_m, 3);

    // Publicar altura (m)
    char payload_alt[16];
    dtostrf(altura_m, 7, 3, payload_alt);
    client.publish(topic_altura_m, payload_alt);

    // ---- (COMENTADO) Publicar voltaje para calibración futura ----
    /*
    char payload_v[16];
    dtostrf(voltaje, 7, 4, payload_v);
    client.publish(topic_voltaje, payload_v);
    */
  }
}
