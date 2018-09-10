void sendViaCable(){
  //check if HW serial connection is already established
  if(Serial){
    //send via UART / HW serial / cable
    Serial.print(F(">sending data: <"));
    for(int i=0; i<nrOfDataBytes; i++){
      Serial.print((uint8_t)dataBytes[i], DEC);
      Serial.print(",");
    } 
    Serial.println(F(">."));
  }
}
