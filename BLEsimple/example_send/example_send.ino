//based on the Adafruit BluefruitLE library (SPI)
//https://github.com/adafruit/Adafruit_BluefruitLE_nRF51

//include header
#include "BLEsimple.h"

//declare BLEsimple pointer
BLEsimple *ble;

//buffers
char buffer_char[20] = {'h', 'e', 'l', 'l', 'o', ' ', 'm', 'y', ' ', 'f', 'r', 'i', 'e', 'n', 'd', '!', '!', ' ', ':', ')'}; //20 bytes maximum
byte buffer_byte[2] = {0, 0}; //20 bytes maximum

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
  //read data sent via BLE
  if(ble->isConnected()){
    //send a custom String
    ble->sendString("test12345678");

    delay(1000);

    //send an byte array of bytes just 2 bytes
    buffer_byte[0]++; //count up
    buffer_byte[1]--; //count down
    ble->sendDataBlock(&buffer_byte[0], 2);

    delay(1000);

    //send an char array of 20 characters
    ble->sendDataBlock(&buffer_char[0], 20);

    delay(1000);


  }
    //disconnect from Central device whenever you like
    //ble->disconnect();
}
