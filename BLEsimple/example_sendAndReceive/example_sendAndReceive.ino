//based on the Adafruit BluefruitLE library (SPI)
//https://github.com/adafruit/Adafruit_BluefruitLE_nRF51

//include header
#include "BLEsimple.h"

//declare BLEsimple pointer
BLEsimple *ble;

//LED pin
#define LED_PIN   13 //on board LED is connected to pin 13

void setup() {
  //define LED pin as output
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);
  
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
  //read data sent via BLE
  if(ble->available()){
    //print received data
    String received = ble->readString();
    Serial.println("received: "+received);

    //reply with the same message
    ble->sendString(received);

    //print the signal strength in dBm
    Serial.println("signal strength: "+String(ble->getSignalStrength())+" dBm");

    //toggle LED if "on" or "off" were received
    if(received == "on"){
      digitalWrite(LED_PIN, HIGH);
    }else if(received == String("off")){
      digitalWrite(LED_PIN, LOW);
    }

    //if disconnected, wait for reconnection
    if(!ble->isConnected()){
      Serial.println(F("disconnected."));
      while(!ble->isConnected()){}
      Serial.println(F("reconnected."));
    }

    //disconnect from Central device whenever you like
    //ble->disconnect();
  }
}
