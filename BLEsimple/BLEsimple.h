//based on the Adafruit BluefruitLE library (SPI)
//https://github.com/adafruit/Adafruit_BluefruitLE_nRF51

//Twitter: @piccips

#ifndef BLESIMPLE_H
#define BLESIMPLE_H

#include <Adafruit_BluefruitLE_SPI.h>

//constants
#define BLUEFRUIT_SPI_CS               8      //SPI chip selection pin
#define BLUEFRUIT_SPI_IRQ              7      //SPI interript pin
#define BLUEFRUIT_SPI_RST              4      //SPI reset pin
#define MINIMUM_FIRMWARE_VERSION    "0.6.6"   //BLE module required firmware version
#define MODE_LED_BEHAVIOUR          "MODE"    //BLE module LED behaviour

//class BLEsimple
class BLEsimple{
  public:
    BLEsimple(String devicename, int32_t baudrate, int8_t powerlevel);
    virtual ~BLEsimple();
    int8_t getSignalStrength();
    bool isConnected();
    bool available();
    String readString();
    void sendString(String str);
    void sendDataBlock(byte* dataset, uint8_t nrOfDataBytes);
    void sendDataBlock(char* dataset, uint8_t nrOfDataBytes);
    void disconnect();
  
  private:
    Adafruit_BluefruitLE_SPI *ble;   

   
};

  

#endif  /* BLESIMPLE_H */
