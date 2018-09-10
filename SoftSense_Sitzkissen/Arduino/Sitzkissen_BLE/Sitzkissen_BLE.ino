#include "BLEsimple.h"
#include "AccGyro.h"

#define FS 10 //sampling rate

BLEsimple *ble;

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
  ble = new BLEsimple("Sitzkissen_BLE2", 1000000, 4);
  //Serial.println(F("module is now set up and ready to connect."));

  //accelerometer/gyroscope
  accgyro = new AccGyro();
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
    Serial.print(accgyro->getAccX());
    Serial.print(" - ");
    Serial.print(accgyro->getAccY());
    Serial.print(" - ");
    Serial.print(accgyro->getAccZ());
    Serial.print(" - ");
    Serial.print(atan2(-accgyro->getAccZ(), accgyro->getAccY())*180.0/PI);
    Serial.print(" - ");
    Serial.println(atan2(accgyro->getAccX(), sqrt(accgyro->getAccY()*accgyro->getAccY()+accgyro->getAccZ()*accgyro->getAccZ()))*180.0/PI);

    
  }
}
