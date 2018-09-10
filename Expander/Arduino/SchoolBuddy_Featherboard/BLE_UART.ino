void sendViaBLE(){
  //for(int i = 0; i<nrOfDataBytes; i++){
  //    bluetooth::send(dataBytes[i]);
  //}
  //bluetooth::send(13);
  //bluetooth::send(10);
  bluetooth::sendDataSet(&dataBytes[0], nrOfDataBytes);
  bluetooth::setBattery(battery::getPercent());
}
