#include <CapacitiveSensor.h>
#include "AccGyro.h"
#include "BluetoothLE.h"
#include "Battery.h"

//samplingrate
#define FS 40 //data sampling rate
#define FS_BAT  0.33 //battery sampling rate

// USB serial
#define SERIAL_BAUDRATE_USB         250000

//pressure sensor
#define PRESSURESENSOR_SEND_PIN     5  //sensor send pin (PWM)
#define PRESSURESENSOR_RECEIVE_PIN  10 //sensor receive pin (AIN)
#define PRESSURESENSOR_SAMPLES      10 //average over X samples
//BLE
#define BLE_NAME                    "SchoolBuddy_App" //advertising device name
#define BLE_BAUDRATE                1000000        //baudrate for BLE connection
#define BLE_POWERLEVEL              4              //BLE module power level in dBm
#define BLOCKSIZE                   16

//objects
CapacitiveSensor *pressuresensor;
AccGyro *accgyro;

//data
const uint8_t nrOfDataBytes = 14;
char dataBytes[nrOfDataBytes] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
// [ WEIGHT1, WEIGHT2, XACC1, XACC2, YACC1, YACC2, ZACC1, ZACC2, XGYR1, XYR2, YGYR1, YGYR2, ZGYR1, ZGYR2 ]

float angle1 = 0;
float angle2 = 0;
uint16_t zoom = 0;

char received[BLOCKSIZE] = {0};
uint32_t receivedData[BLOCKSIZE/4] = {0};
byte receivedIndex = 0;

//time
uint32_t t_fs = 0;
uint32_t t_battery = 0;
const uint16_t next_fs = (uint16_t)(1000 / FS);
const uint16_t next_battery = (uint16_t)(1000 / FS_BAT);

void setup() {
  //create HW serial connection
  Serial.begin(SERIAL_BAUDRATE_USB);
  delay(2000);

  //set up BLE module
  bluetooth::begin();                             //start BLE module initialization
  bluetooth::factoryReset();                      //reset BLE module on startup
  bluetooth::setEcho(false);                      //disable command echo from BLE module
  bluetooth::setName(BLE_NAME);                   //changing the device name
  bluetooth::setBaudrate(BLE_BAUDRATE);           //set baudrate
  bluetooth::setPowerLevel(BLE_POWERLEVEL);       //set power level
  bluetooth::enableBatteryService();              //enable battery service
  //bluetooth::printInfo();                         //print BLE module info
  bluetooth::softwareReset();                     //reset to apply changes
  bluetooth::setBattery(battery::getPercent(), battery::getVoltage());   //set initial battery value
  bluetooth::dataMode();                          //enter data/UART mode

  //create sensor object
  pressuresensor = new CapacitiveSensor(PRESSURESENSOR_SEND_PIN, PRESSURESENSOR_RECEIVE_PIN);

  //accelerometer/gyroscope
  accgyro = new AccGyro();

  bluetooth::waitForConnection();                 //wait for connection

  //smiley
  pinMode(12, OUTPUT);
  digitalWrite(12, LOW);
}

boolean state = true; 
int threshold[2] = {350, 150};
uint16_t pressure = 0;
int counter = 0;

void loop() {
  //every 1000/FS milliseconds
  if (millis() > t_fs) {
    t_fs = millis() + next_fs;

    //pressure sensor
    pressure = getSensorValue(pressuresensor);

    //accelerometer & gyroscope
    accgyro->read();

    //sending data
    setData(pressure, accgyro->getAccX(), accgyro->getAccY(), accgyro->getAccZ(), accgyro->getGyrX(), accgyro->getGyrY(), accgyro->getGyrZ());
    //sendViaCable();
    //sendViaBLE();

    //check for disconnect
    bluetooth::checkIfStillConnected();
  }

  //every 1000/FS_BAT milliseconds
  if (millis() > t_battery) {
    t_battery = millis() + next_battery;

    //update battery percentage
    //bluetooth::setBattery(battery::getPercent(), battery::getVoltage());
  }

  receiveViaBLE();

  //counter
  if(pressure > threshold[0] && state){
    state = false;
  }else if(pressure < threshold[1] && !state){
    state = true;
    counter++;
    if(counter%12 == 0){
      digitalWrite(12, HIGH);
      //delay(5);
      digitalWrite(12, LOW);
    }
  }
}
