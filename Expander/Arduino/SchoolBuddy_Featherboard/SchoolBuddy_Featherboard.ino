#include <SoftwareSerial.h>
#include <CapacitiveSensor.h>
#include "AccGyro.h"
#include "BluetoothLE.h"
#include "Battery.h"

//samplingrate
#define FS 40 //sampling rate

//serial
#define BV2_SERIAL_RX_PIN A4
#define BV2_SERIAL_TX_PIN A5
#define SERIAL_BAUDRATE_USB 115200
#define SERIAL_BAUDRATE_BV2 115200
#define BV2_ENABLE_PIN    12
#define BV2_STATE_PIN     11

//pressure sensor
#define PRESSURESENSOR_SEND_PIN     5  //sensor send pin (PWM)
#define PRESSURESENSOR_RECEIVE_PIN  10 //sensor receive pin (AIN)
#define PRESSURESENSOR_SAMPLES      10 //average over 10 samples

//vibration
#define VIBRATION_PIN               4 //vibration motor pin, digital
#define VIBRATION_DURATION          200 //vibration duraction

//BLE
#define BLE_NAME                    "SchoolBuddySL_BLE" //advertising device name
#define BLE_BAUDRATE                1000000        //baudrate for BLE connection
#define BLE_POWERLEVEL              0              //BLE module power level in dBm

//objects
CapacitiveSensor *pressuresensor;
AccGyro *accgyro;
SoftwareSerial bv2(BV2_SERIAL_RX_PIN, BV2_SERIAL_TX_PIN); //RX, TX

//data
const uint8_t nrOfDataBytes = 16;
char dataBytes[nrOfDataBytes] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
// [ WEIGHT1, WEIGHT2, XACC1, XACC2, YACC1, YACC2, ZACC1, ZACC2, XGYR1, XYR2, YGYR1, YGYR2, ZGYR1, ZGYR2, TEMP1, TEMP2 ]

//time
uint32_t t = 0;
uint32_t tVib = 0;
const uint16_t next = (uint16_t)(500 / FS);

//vibration
bool vibState = false;

void setup() {
  //pinmodes
  pinMode(VIBRATION_PIN, OUTPUT);
  pinMode(BV2_STATE_PIN, INPUT);
  pinMode(BV2_ENABLE_PIN, OUTPUT);
  digitalWrite(BV2_ENABLE_PIN, HIGH); //set low to disable module
  
  //create HW serial connection
  Serial.begin(SERIAL_BAUDRATE_USB);

  //create SW serial connection
  bv2.begin(SERIAL_BAUDRATE_BV2);

  //set up BLE module
  //bluetooth::begin();                             //start BLE module initialization
  //bluetooth::factoryReset();                      //reset BLE module on startup
  //bluetooth::setEcho(false);                      //disable command echo from BLE module
  //bluetooth::setName(BLE_NAME);                   //changing the device name
  //bluetooth::setBaudrate(BLE_BAUDRATE);           //set baudrate
  //bluetooth::setPowerLevel(BLE_POWERLEVEL);       //set power level
  //bluetooth::getTemperature();                    //get temperature
  //bluetooth::enableBatteryService();              //enable battery service
  ////bluetooth::printInfo();                         //print BLE module info
  //bluetooth::softwareReset();                     //reset to apply changes
  //bluetooth::setBattery(battery::getPercent());   //set initial battery value
  ////bluetooth::stopAdvertising();                   //stop advertising
  //bluetooth::dataMode();                          //enter data/UART mode
  //bluetooth::waitForConnection();                 //wait for connection

  //create sensor object
  pressuresensor = new CapacitiveSensor(PRESSURESENSOR_SEND_PIN, PRESSURESENSOR_RECEIVE_PIN);

  //accelerometer/gyroscope
  accgyro = new AccGyro();

}

void loop() {
  //every 500/FS milliseconds
  if (millis() > t) {
    t = millis() + next;

    //pressure sensor
    uint16_t pressure = getSensorValue(pressuresensor);

    //accelerometer & gyroscope
    accgyro->read();

    //sending data
    setData(pressure, accgyro->getAccX(), accgyro->getAccY(), accgyro->getAccZ(), accgyro->getGyrX(), accgyro->getGyrY(), accgyro->getGyrZ(), accgyro->getTemp());

    //sendViaCable();
    sendViaBv2();
    //sendViaBLE();
  }


  //vibration
  //vibrate();
}
