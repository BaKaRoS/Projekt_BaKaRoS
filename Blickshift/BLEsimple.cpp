//based on the Adafruit BluefruitLE library (SPI)
//https://github.com/adafruit/Adafruit_BluefruitLE_nRF51

//Twitter: @piccips

#include "BLEsimple.h"

//constructor
BLEsimple::BLEsimple(String devicename, int32_t baudrate, int8_t powerlevel){
  this->ble = new Adafruit_BluefruitLE_SPI(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST); //create object
  this->ble->begin(); //SPI communication
  this->ble->factoryReset(); //factory reset
  this->ble->echo(false); //disable echo mode
  this->ble->sendCommandCheckOK(String("AT+GAPDEVNAME=" + devicename).c_str()); //set device name
  this->ble->sendCommandCheckOK(String("AT+BAUDRATE=" + String(baudrate)).c_str()); //set baudrate: 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 76800, 115200, 230400, 250000, 460800, 921600, 1000000
  this->ble->sendCommandCheckOK(String("AT+BLEPOWERLEVEL=" + String(powerlevel)).c_str()); //set power level: -40, -20, -16, -12, -8, -4, 0, 4
  this->ble->reset(); //software reset to apply changes
  this->ble->setMode(BLUEFRUIT_MODE_DATA); //change to data mode
}

//destructor
BLEsimple::~BLEsimple(){
  //disconnect
  this->disconnect();
  
  //end communication
  this->ble->end();

  //delete object
  delete this->ble;
}

//connected to a device?
bool BLEsimple::isConnected(){
  return this->ble->isConnected();
}

//data available?
bool BLEsimple::available(){
  if(!this->ble->isConnected()){
    return false;
  }
  
  return this->ble->available();
}

//read UART into a String
String BLEsimple::readString(){
  uint8_t index = 0;
  String str = "";
  while(this->ble->available() && index < 20){
    str += (char)this->ble->read();
    index++;
  }
  str += '\0';
  return str;
}

//get RSSI (signal strength in dBm)
int8_t BLEsimple::getSignalStrength(){
  if(!this->ble->isConnected()){
    //return maximum value, such a signal strength is not physically possible
    return INT8_MAX;
  }
  
  int32_t reply = 0;
  this->ble->sendCommandWithIntReply(F("AT+BLEGETRSSI"), &reply);
  return (int8_t)reply;
}

//disconnect from Central device
void BLEsimple::disconnect(){
  if(!this->ble->isConnected()){
    return;
  }
  
  this->ble->sendCommandCheckOK(F("AT+GAPDISCONNECT"));
}

//send data of up to 20 bytes (byte array)
void BLEsimple::sendDataBlock(byte* dataset, uint8_t nrOfDataBytes){
  if(!this->ble->isConnected()){
    return;
  }

  if(nrOfDataBytes > 20){
    nrOfDataBytes = 20;
  }
  
  this->ble->write(dataset, nrOfDataBytes);
}

//send data of up to 20 bytes (char array)
void BLEsimple::sendDataBlock(char* dataset, uint8_t nrOfDataBytes){
  if(!this->ble->isConnected()){
    return;
  }

  if(nrOfDataBytes > 20){
    nrOfDataBytes = 20;
  }
  
  this->ble->write(dataset, nrOfDataBytes);
}

//send a String of up to 20 characters
void BLEsimple::sendString(String str){
  if(!this->ble->isConnected()){
    return;
  }
  
  char send_buffer[20];
  str.toCharArray(&send_buffer[0], str.length()+1);
  this->sendDataBlock(&send_buffer[0], str.length()+1);
}

