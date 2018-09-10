void sendViaCable(){
  //check if HW serial connection is already established
  if(Serial){
    //send via UART / HW serial / cable
    for(int i=0; i<nrOfDataBytes; i++){
      Serial.write(dataBytes[i]);
    } 
    Serial.println("");
  }
}
