void LEDtest1(){
  while(!Serial){
    for(uint8_t i = 0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, colorlist[i]);
      strip.show();
      delay(30);
    }
  
    for(uint8_t i = 0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, strip.Color(0, 0, 0));
        strip.show();
        delay(30);
    }
  }
}

void LEDtest2(){
  uint8_t position = 0;
  while(!Serial){
      strip.setPixelColor(position, colorlist[position]);

      strip.setPixelColor((position+NUM_LEDS-5)%NUM_LEDS, strip.Color(0, 0, 0));
      strip.show();
      delay(30);
      position++;
      if(position >= NUM_LEDS) position = 0;
  }  
  
  
}
