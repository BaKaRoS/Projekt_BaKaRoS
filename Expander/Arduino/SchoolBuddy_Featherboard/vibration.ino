void vibrate(){
  if(!vibState && tVib < millis() && bv2.available()){
    digitalWrite(VIBRATION_PIN, HIGH);
    tVib = millis()+VIBRATION_DURATION;
    vibState = true;
    while(bv2.available()){
      bv2.read();
    }
  }else if(tVib < millis()){
    digitalWrite(VIBRATION_PIN, LOW);
    tVib = millis()+VIBRATION_DURATION;
    vibState = false;  
  }
}
