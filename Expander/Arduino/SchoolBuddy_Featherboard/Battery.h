#ifndef BATTERY_H
#define BATTERY_H

#include "Arduino.h"

#define VBAT_PIN                    A9 //battery voltage pin

namespace battery{
  float getVoltage(){
    return analogRead(VBAT_PIN)*2*3.3/1024.0;
  }
  
  int8_t getPercent(){
    //read value
    int value = analogRead(VBAT_PIN);

    //no battery attached
    if(value > 655){
      return -1;
    }

    //battery attached
    int percent = map(value, 600, 645, 0, 100); //linear mapping, 495 = 3,2V

    if(percent > 100){
      return 100;
    }
    if(percent < 0){
      return 0;  
    }
    return percent;
  }
}

#endif  /* BATTERY_H */

