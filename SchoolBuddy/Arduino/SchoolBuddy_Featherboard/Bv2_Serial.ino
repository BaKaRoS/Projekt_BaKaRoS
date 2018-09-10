void sendViaBv2(){
  //send via UART / SW serial / bluetooth v2.0 module
  for(int i=0; i<nrOfDataBytes; i++){
    bv2.write(dataBytes[i]);
  }
  bv2.println(""); 
}
