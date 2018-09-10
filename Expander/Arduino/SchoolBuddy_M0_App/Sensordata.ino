void setData(uint16_t weight, uint16_t accX, uint16_t accY, uint16_t accZ, uint16_t gyrX, uint16_t gyrY, uint16_t gyrZ){
  dataBytes[0] = (char)(weight >> 8);  //WEIGHT upper byte
  dataBytes[1] = (char)weight;         //WEIGHT lower byte
  dataBytes[2] = (char)(accX >> 8);    //XACC1 upper byte
  dataBytes[3] = (char)accX;           //XACC2 lower byte
  dataBytes[4] = (char)(accY >> 8);    //YACC1 upper byte
  dataBytes[5] = (char)accY;           //YACC2 lower byte
  dataBytes[6] = (char)(accZ >> 8);    //ZACC1 upper byte
  dataBytes[7] = (char)accZ;           //ZACC2 lower byte
  dataBytes[8] = (char)(gyrX >> 8);   //XGYR1 upper byte
  dataBytes[9] = (char)gyrX;          //XGYR2 lower byte
  dataBytes[10] = (char)(gyrY >> 8);   //YGYR1 upper byte
  dataBytes[11] = (char)gyrY;          //YGYR2 lower byte
  dataBytes[12] = (char)(gyrZ >> 8);   //ZGYR1 upper byte
  dataBytes[13] = (char)gyrZ;          //ZGYR2 lower byte
}
