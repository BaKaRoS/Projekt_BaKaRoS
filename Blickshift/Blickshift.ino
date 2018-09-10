//include header
#include "BLEsimple.h"
#include <Adafruit_NeoPixel.h>

//neopixel
#define PIN A0
#define NUM_LEDS 16
#define BRIGHTNESS 50
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_LEDS, PIN, NEO_GRB + NEO_KHZ800);

//timeout
#define TIMEOUT 3000
uint32_t next = 0;

//colorlist
uint32_t colorlist[NUM_LEDS] = {0};

//declare BLEsimple pointer
BLEsimple *ble;
uint8_t c = 0;
uint8_t value = 0;

void setup() {
  //create Serial communication with 115200 baud
  Serial.begin(115200);

  //set up BLE module
  ble = new BLEsimple("EyeTracking", 1000000, 4);

  //generate colors
  float r,g;
  for(uint8_t i = 0; i < NUM_LEDS; i++){
    g = cos(PI*i/(1.5*NUM_LEDS));
    if(g<0) g=0;
    r = sin(PI*i/(1.5*NUM_LEDS));
    if(r<0) r=0;
    
    colorlist[i] = strip.Color(255*r, 255*g, 0); //RGB
  }

  //set up neopixels
  strip.clear();
  strip.setBrightness(BRIGHTNESS);
  strip.begin();
  strip.show();
  
  //test LEDs
  LEDtest1();

  //clear LEDs
  strip.clear();
  strip.show();
  
  //wait until Serial connection over USB is established
  //while(!Serial){}

  //wait for BLE connection
  //while(!ble->isConnected()){}
}

void loop() {
  //timeout
  if(millis() > next){
    //clear display
    strip.clear();
    strip.show();
    next = 2*millis();
  }
  
  //read data sent via USB
  if(Serial.available()){
    next = millis()+TIMEOUT;
    c = Serial.read();
    
    //transmit data per BLE
    if(ble->isConnected()){
      ble->sendDataBlock(&c, 1);
    }

    value = map(c, 0, 100, 0, NUM_LEDS-1);
    if(value >= NUM_LEDS) value = NUM_LEDS-1;

    //update LEDs
    for(uint16_t i=0; i<strip.numPixels(); i++) {
      if(i<value){
        strip.setPixelColor(i, colorlist[i]);
      }else{
        strip.setPixelColor(i, strip.Color(0, 0, 0));
      }
    }
    strip.show();
  }
}
