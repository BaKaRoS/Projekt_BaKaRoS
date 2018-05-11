# BLEsimple
**simpleBLE** is a C++ class to make BLE communication for Adafruit Featherboard BLE (Bluefruit) microcontrollers as easy as possible. It uses the [Adafruit BluefruitLE SPI library](https://github.com/adafruit/Adafruit_BluefruitLE_nRF51) so make sure you installed it.

## Functions
### constructor and destructor
- the constructor **BLEsimple(String devicename, int32_t baudrate, int8_t powerlevel)** initializes the BLE module with a custom name, a specific baudrate, a transmission power level and makes the device connectable
- the destructor disconnects from the Central device, ends the communication with the BLE module and frees all used memory

### receiving
- **bool available()** checks if new data was received
- **String readString()** returns the received data in a String

### sending
- **void sendString(String str)** send a String of up to 20 characters
- **void sendDataBlock(byte* dataset, uint8_t nrOfDataBytes)** sends the content of a byte array of up to 20 characters
- **void sendDataBlock(char* dataset, uint8_t nrOfDataBytes)** sends the content of a char array of up to 20 characters

### Other
- **int8_t getSignalStrength()** returns the current signal strength in dBm or a very high value if disconnected
- **bool isConnected()** checks if the board is currently connected to a Central device
- **void disconnect()** disconnects from the Central device
    
## Basic usage
- Install the Adafruit BluefruitLE SPI library: click [here](https://github.com/adafruit/Adafruit_BluefruitLE_nRF51) or [here](https://learn.adafruit.com/adafruit-feather-32u4-bluefruit-le/installing-ble-library)
- copy **BLEsimple.h** and **BLEsimple.cpp** into your workspace (where your .ino file is saved)
- create a **BLEsimple** object as shown below
```
#include "BLEsimple.h"
BLEsimple *ble;

void setup() {
  ble = new BLEsimple("TestDevice", 1000000, 4); //1.000.000 baud, 4 dBm TX power
}

void loop(){
  //send and receive stuff here
}
```
Take a look at the provided examples of how to receive or send data.

### Contact
If you have issues, contact me on twitter: [Twitter](https://twitter.com/piccips)
