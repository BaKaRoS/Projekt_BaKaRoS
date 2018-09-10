#include <CapacitiveSensor.h>

#define FS 10 //sampling rate
#define NUMBEROFSENSORS 4
#define SENSOR_SAMPLES 10
#define BAUDRATE 115200
PROGMEM const byte pin_in[NUMBEROFSENSORS] = {A0, A2, A3, A5};
PROGMEM const byte pin_out[NUMBEROFSENSORS] = {11, 10, 9, 5};
uint16_t data[NUMBEROFSENSORS] = {0};

CapacitiveSensor *sensor1;
CapacitiveSensor *sensor2;
CapacitiveSensor *sensor3;
CapacitiveSensor *sensor4;

uint32_t t = 0;
const uint32_t next = (uint32_t)(1000 / FS);

void setup() {
  sensor1 = new CapacitiveSensor(pin_out[0], pin_in[0]);
  sensor2 = new CapacitiveSensor(pin_out[1], pin_in[1]);
  sensor3 = new CapacitiveSensor(pin_out[2], pin_in[2]);
  sensor4 = new CapacitiveSensor(pin_out[3], pin_in[3]);
  
  for(byte i = 0; i < NUMBEROFSENSORS; i++){
    pinMode(pin_in[i], INPUT);
    pinMode(pin_out[i], OUTPUT);
  }

  Serial.begin(BAUDRATE);
}

void loop() {
  if (millis() > t) {
  t = millis() + next;
  
  data[0] = sensor1->capacitiveSensor(SENSOR_SAMPLES);
  data[1] = sensor2->capacitiveSensor(SENSOR_SAMPLES);
  data[2] = sensor3->capacitiveSensor(SENSOR_SAMPLES);
  data[3] = sensor4->capacitiveSensor(SENSOR_SAMPLES);
  
    for(byte i = 0; i < NUMBEROFSENSORS; i++){
      Serial.write(highByte(data[i]));
      Serial.write(lowByte(data[i]));
    }
    Serial.println("");
  }
}
