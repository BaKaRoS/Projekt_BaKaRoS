#include "BLEsimple.h"
#include "AccGyro.h"

#define FS          10 //sampling rate
#define LED_R_PIN   9
#define LED_G_PIN   11
#define LED_B_PIN   10

BLEsimple *ble;
String receive_str = "";

//accelerometer
AccGyro *accgyro;
const uint8_t nrOfDataBytes = 6;
byte dataBytes[nrOfDataBytes] = {0, 0, 0, 0, 0, 0};

//time
uint32_t t = 0;
const uint16_t next = (uint16_t)(1000 / FS);

void setup() {
  Serial.begin(115200);

  //Serial.println(F("setting up module..."));
  ble = new BLEsimple("Controller2", 1000000, 4);
  //Serial.println(F("module is now set up and ready to connect."));

  //accelerometer/gyroscope
  accgyro = new AccGyro();

  pinMode(LED_R_PIN, OUTPUT);
  pinMode(LED_G_PIN, OUTPUT);
  pinMode(LED_B_PIN, OUTPUT);
  analogWrite(LED_R_PIN, 255);
  analogWrite(LED_G_PIN, 255);
  analogWrite(LED_B_PIN, 255);
}

void loop() {
  //send datas via BLE
  if(ble->isConnected() && millis() > t){
    t = millis() + next;

    //accelerometer & gyroscope
    accgyro->read();
    dataBytes[0] = (byte)(accgyro->getAccX() >> 8);    //XACC1 upper byte
    dataBytes[1] = (byte)accgyro->getAccX();           //XACC2 lower byte
    dataBytes[2] = (byte)(accgyro->getAccY() >> 8);    //YACC1 upper byte
    dataBytes[3] = (byte)accgyro->getAccY();           //YACC2 lower byte
    dataBytes[4] = (byte)(accgyro->getAccZ() >> 8);    //ZACC1 upper byte
    dataBytes[5] = (byte)accgyro->getAccZ();           //ZACC2 lower byte
    
    ble->sendDataBlock(&dataBytes[0], nrOfDataBytes);
    //Serial.print(accgyro->getAccX());
    //Serial.print(" - ");
    //Serial.print(accgyro->getAccY());
    //Serial.print(" - ");
    //Serial.print(accgyro->getAccZ());
    //Serial.print(" - ");
  }

  //receive
  if(ble->isConnected() && ble->available()){
    receive_str = ble->readString();
    if(receive_str == "r"){
      analogWrite(LED_R_PIN, 0);
      delay(1000);
      analogWrite(LED_R_PIN, 255); 
      Serial.println("r"); 
    }
    if(receive_str == "g"){
      analogWrite(LED_G_PIN, 0);
      delay(1000);
      analogWrite(LED_G_PIN, 255); 
      Serial.println("g");  
    }
    if(receive_str == "b"){
      analogWrite(LED_B_PIN, 0);
      delay(1000);
      analogWrite(LED_B_PIN, 255); 
      Serial.println("b");  
    }
  }
}
