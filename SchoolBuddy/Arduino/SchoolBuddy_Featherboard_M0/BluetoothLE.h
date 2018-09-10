#ifndef BLUETOOTHLE_H
#define	BLUETOOTHLE_H

#include "Arduino.h"
#include <Adafruit_BLE.h>
#include <Adafruit_BluefruitLE_SPI.h>
#include <Adafruit_BluefruitLE_UART.h>

#define BLUEFRUIT_SPI_CS               8      //CS chip selection pin
#define BLUEFRUIT_SPI_IRQ              7      //IRQ pin
#define BLUEFRUIT_SPI_RST              4      //RST reset pin
#define MINIMUM_FIRMWARE_VERSION    "0.6.6"   //BLE module required firmware version
#define MODE_LED_BEHAVIOUR          "MODE"    //BLE module LED behaviour

Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);

//forward declaration
namespace bluetooth{
  void error(const __FlashStringHelper *err);
  void getRSSI();
}

namespace bluetooth{
  void begin(){
      //begin communicating with BLE (no verbose mode)
      if (!ble.begin(false) ){
          bluetooth::error(F(">Couldn't find Bluefruit."));
      }
      Serial.println(F(">BLE module found."));
  }
  
  void error(const __FlashStringHelper *err) {
      Serial.println(err);
      while(1);
  }
  
  void waitForConnection() {
      //Wait for connection
      Serial.println(F(">Waiting for connection..."));
      while (!ble.isConnected()) { 
          delay(500);    
      }
        
      Serial.println(F(">connected."));
      delay(100);
    
      // Change Mode LED Activity
      if(ble.isVersionAtLeast(MINIMUM_FIRMWARE_VERSION)){
          ble.sendCommandCheckOK("AT+HWModeLED=" MODE_LED_BEHAVIOUR);
      }
  
      //get RSSI
      bluetooth::getRSSI();
  }
  
  void dataMode(){
      ble.setMode(BLUEFRUIT_MODE_DATA);
      Serial.println(F(">Data mode."));
  }
  
  void commandMode(){
      ble.setMode(BLUEFRUIT_MODE_COMMAND);
      Serial.println(F(">Command mode."));
  }
  
  void factoryReset(){
      if(!ble.factoryReset()){
          bluetooth::error(F(">Couldn't factory reset."));
      }
      Serial.println(F(">Factory reset."));
  }
  
  void softwareReset(){
      ble.reset();
      Serial.println(F(">Software reset."));
  }
  
  void setName(String devicename){
      if(!ble.sendCommandCheckOK(String("AT+GAPDEVNAME=" + devicename).c_str())){
          bluetooth::error(F(">Could not set device name."));
      }
      Serial.println(String(">Set device name to '" + devicename + "'."));  
  }
  
  void printInfo(){
      Serial.println(F(">Bluefruit info:"));
      ble.info();
  }
  
  void setEcho(boolean value){
      ble.echo(value);
      if(value){
          Serial.println(F(">Echo mode on."));
      }else{
          Serial.println(F(">Echo mode off."));
      }
  }
  
  void send(uint8_t tx_byte){
      if(ble.isConnected()){
          ble.print((char)tx_byte);
      }
  }

  void sendDataSet(char* dataset, uint8_t nrOfDataBytes){
    //Serial.println("----------");
      if(ble.isConnected()){
        char data[nrOfDataBytes+2];
        for(uint8_t i=0; i<nrOfDataBytes; i++){
          data[i] = dataset[i];
        }
        data[nrOfDataBytes] = 10;
        data[nrOfDataBytes+1] = 13;
        data[nrOfDataBytes+2] = 0;
        
        ble.write(data, nrOfDataBytes+2);
        //Serial.write(data, nrOfDataBytes+2);
        //Serial.println("");
      }
  }
  
  void checkIfStillConnected(){
      if(!ble.isConnected()) {
          Serial.println(F(">disconnected."));
          bluetooth::waitForConnection();
      }
  }
  
  bool isConnected(){
      return ble.isConnected();
  }
  
  bool available(){
      return ble.available();
  }
  
  char read(){
      return ble.read();
  }
  
  void setBaudrate(int32_t baudrate){
      //1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 76800, 115200, 230400, 250000, 460800, 921600, 1000000
      int32_t reply = 0;
      ble.sendCommandCheckOK(String("AT+BAUDRATE=" + String(baudrate)).c_str());
      ble.sendCommandWithIntReply(F("AT+BAUDRATE"), &reply);
      Serial.println(">Baudrate is set to " + String(reply) + ".");  
  }
  
  float getTemperature(){
      int32_t reply = 0;
      ble.sendCommandWithIntReply(F("AT+HWGETDIETEMP"), &reply);
      Serial.println(">Temperature is " + String((float)reply) + " °C.");
      return (float)reply;
  }
  
  void setPowerLevel(int8_t dbm){
      //-40, -20, -16, -12, -8, -4, 0, 4
      int32_t reply = 0;
      ble.sendCommandCheckOK(String("AT+BLEPOWERLEVEL=" + String(dbm)).c_str());
      ble.sendCommandWithIntReply(F("AT+BLEPOWERLEVEL"), &reply);
      Serial.println(">Power level is set to " + String(reply) + " dBm.");  
  }
  
  void getRSSI(){
      int32_t reply = 0;
      ble.sendCommandWithIntReply(F("AT+BLEGETRSSI"), &reply);
      Serial.println(">RSSI is " + String(reply) + " dBm.");  
  }
  
  void enableBatteryService(){
      ble.sendCommandCheckOK(F("AT+BLEBATTEN=1"));
      Serial.println(F(">Battery service enabled."));  
  }
  
  void setBattery(int8_t percent){
    if(percent >= 0){
      Serial.println(">Set battery to " + String(percent) + "%.");
    }else{
      //no battery attached
      percent = 0;
    }
    ble.sendCommandCheckOK(String("AT+BLEBATTVAL=" + String(percent)).c_str());
         
  }
  
  void setConnectable(bool connectable){
      ble.sendCommandCheckOK(String("AT+GAPCONNECTABLE=" + String((int)connectable)).c_str());
      if(connectable){
          Serial.println(F(">Device is connectable."));
      }else{
          Serial.println(F(">Device is not connectable."));
      } 
  }
  
  void disconnect(){
      ble.sendCommandCheckOK(F("AT+GAPDISCONNECT"));
      Serial.println(F(">Disconnecting..."));
  }
  
  void startAdvertising(){
      ble.sendCommandCheckOK(F("AT+GAPSTARTADV"));
      Serial.println(F(">Starting advertising."));
  }
  
  void stopAdvertising(){
      ble.sendCommandCheckOK(F("AT+GAPSTOPADV"));
      Serial.println(F(">Stopping advertising."));
  }
}

#endif	/* BLUETOOTHLE_H */

