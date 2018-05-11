//based on the Adafruit BluefruitLE library (SPI)
//https://github.com/adafruit/Adafruit_BluefruitLE_nRF51

//Twitter: @piccips

//include header
#include "BLEsimple.h"

//declare BLEsimple pointer
BLEsimple *ble;

void setup() {
  //create Serial communication with 115200 baud
  Serial.begin(115200);

  //wait until Serial connection over USB is established
  while(!Serial){}

  //setting up the board with name "Test", maximum baud rate (1.000.000) and a maximum TX power level of 4 dBm
  Serial.println(F("setting up module..."));
  ble = new BLEsimple("Test", 1000000, 4);
  Serial.println(F("module is now set up and ready to connect."));

  //wait for BLE connection
  while(!ble->isConnected()){}
  Serial.println(F("connected."));
}

void loop() {
  //do stuff here, e.g.:
  Serial.println("signal strength: "+String(ble->getSignalStrength())+" dBm");

  //if disconnected, wait for reconnection
  if(!ble->isConnected()){
    Serial.println(F("disconnected."));
    while(!ble->isConnected()){}
    Serial.println(F("reconnected."));
  }

  
  //disconnect from Central device whenever you like
  //ble->disconnect();
}
