#include "AccGyro.h"

AccGyro::AccGyro(){
    int error;
    uint8_t c;
 
    // Initialize the 'Wire' class for the I2C-bus.
    Wire.begin();
 
    // default at power-up:
    //    Gyro at 250 degrees second
    //    Acceleration at 2g
    //    Clock source at internal 8MHz
    //    The device is in sleep mode.
 
    error = MPU6050_read (MPU6050_WHO_AM_I, &c, 1);
    //Serial.print(F("WHO_AM_I : "));
    //Serial.print(c,HEX);
    //Serial.print(F(", error = "));
    //Serial.println(error,DEC);
 
    // According to the datasheet, the 'sleep' bit
    // should read a '1'.
    // That bit has to be cleared, since the sensor
    // is in sleep mode at power-up.
    error = MPU6050_read (MPU6050_PWR_MGMT_1, &c, 1);
    //Serial.print(F("PWR_MGMT_1 : "));
    //Serial.print(c,HEX);
    //Serial.print(F(", error = "));
    //Serial.println(error,DEC);
 
    // Clear the 'sleep' bit to start the sensor.
    MPU6050_write_reg (MPU6050_PWR_MGMT_1, 0);
    
    //enable lowpass
    this->setDLPFMode(6);
    
    Serial.println(F("<Object AccGyro created.>"));
}

AccGyro::~AccGyro() {
    //Serial.println(F("<Object AccGyro destroyed.>"));
}

void AccGyro::setDLPFMode(uint8_t mode){
   //MPU6050_write_reg(MPU6050_DLPF_CFG0, 0);
   //MPU6050_write_reg(MPU6050_DLPF_CFG1, 1);
   //MPU6050_write_reg(MPU6050_DLPF_CFG2, 1);
    MPU6050_write_reg(0x6B, 0x03);
    MPU6050_write_reg(0x1A, mode);
    
}

void AccGyro::read(){
    accel_t_gyro_union accel_t_gyro;
 
    // Read the raw values.
    // Read 14 bytes at once,
    // containing acceleration, temperature and gyro.
    // With the default settings of the MPU-6050,
    // there is no filter enabled, and the values
    // are not very stable.
    this->error = MPU6050_read (MPU6050_ACCEL_XOUT_H, (uint8_t *) &accel_t_gyro, sizeof(accel_t_gyro));
 
    // Swap all high and low bytes.
    // After this, the registers values are swapped,
    // so the structure name like x_accel_l does no
    // longer contain the lower byte.
    uint8_t swap;
 
    SWAP (accel_t_gyro.reg.x_accel_h, accel_t_gyro.reg.x_accel_l, swap);
    SWAP (accel_t_gyro.reg.y_accel_h, accel_t_gyro.reg.y_accel_l, swap);
    SWAP (accel_t_gyro.reg.z_accel_h, accel_t_gyro.reg.z_accel_l, swap);
    SWAP (accel_t_gyro.reg.t_h, accel_t_gyro.reg.t_l, swap);
    SWAP (accel_t_gyro.reg.x_gyro_h, accel_t_gyro.reg.x_gyro_l, swap);
    SWAP (accel_t_gyro.reg.y_gyro_h, accel_t_gyro.reg.y_gyro_l, swap);
    SWAP (accel_t_gyro.reg.z_gyro_h, accel_t_gyro.reg.z_gyro_l, swap);
    
    // The temperature sensor is -40 to +85 degrees Celsius.
    // It is a signed integer.
    // According to the datasheet:
    //   340 per degrees Celsius, -512 at 35 degrees.
    // At 0 degrees: -512 - (340 * 35) = -12412
    
    this->accX = accel_t_gyro.value.x_accel;
    this->accY = accel_t_gyro.value.y_accel;
    this->accZ = accel_t_gyro.value.z_accel;
    this->gyrX = accel_t_gyro.value.x_gyro;
    this->gyrY = accel_t_gyro.value.y_gyro;
    this->gyrZ = accel_t_gyro.value.z_gyro;
    this->temp = (((double) accel_t_gyro.value.temperature + 12412.0) / 340.0);
    
    //if(this->error != 0){
    //    Serial.println("error");
    //}
    
}
 
int AccGyro::MPU6050_read(int start, uint8_t *buffer, int size){
    int i, n, error;
 
    Wire.beginTransmission(MPU6050_I2C_ADDRESS);
    n = Wire.write(start);
    if (n != 1)
        return (-10);
 
    n = Wire.endTransmission(false);    // hold the I2C-bus
    if (n != 0)
        return (n);
 
    // Third parameter is true: relase I2C-bus after data is read.
    Wire.requestFrom(MPU6050_I2C_ADDRESS, size, true);
    i = 0;
    while(Wire.available() && i<size)
    {
        buffer[i++]=Wire.read();
    }
    if ( i != size)
        return (-11);
 
    return (0);  // return : no error
}
 
int AccGyro::MPU6050_write(int start, const uint8_t *pData, int size){
    int n, error;
 
    Wire.beginTransmission(MPU6050_I2C_ADDRESS);
    n = Wire.write(start);        // write the start address
    if (n != 1)
        return (-20);
 
    n = Wire.write(pData, size);  // write data bytes
    if (n != size)
        return (-21);
 
    error = Wire.endTransmission(true); // release the I2C-bus
    if (error != 0)
        return (error);
 
    return (0);         // return : no error
}
 
int AccGyro::MPU6050_write_reg(int reg, uint8_t data){
    int error;
 
    error = MPU6050_write(reg, &data, 1);
 
    return (error);
}


void AccGyro::printValues(){
    // Print the raw acceleration values
    Serial.print(F("error = "));
    Serial.print(this->error,DEC); 
    
    Serial.print(F(", accX="));
    Serial.print(this->accX, DEC);
    Serial.print(F(", accY="));
    Serial.print(this->accY, DEC);
    Serial.print(F(", accZ="));
    Serial.print(this->accZ, DEC);
    
    Serial.print(F(", gyrX="));
    Serial.print(this->gyrX, DEC);
    Serial.print(F(", gyrY="));
    Serial.print(this->gyrY, DEC);
    Serial.print(F(", gyrZ="));
    Serial.print(this->gyrZ, DEC);
 
    Serial.print(F(", temp="));
    Serial.print(this->temp, 3);
    Serial.println(F(""));
    
}

uint16_t AccGyro::getAccX(){
    return this->accX+32768;
}

uint16_t AccGyro::getAccY(){
    return this->accY+32768;
}

uint16_t AccGyro::getAccZ(){
    return this->accZ+32768;
}

uint16_t AccGyro::getGyrX(){
    return this->gyrX+32768;
}

uint16_t AccGyro::getGyrY(){
    return this->gyrY+32768;
}

uint16_t AccGyro::getGyrZ(){
    return this->gyrZ+32768;
}

uint16_t AccGyro::getTemp(){
    return (uint16_t)(this->temp*100);
}

