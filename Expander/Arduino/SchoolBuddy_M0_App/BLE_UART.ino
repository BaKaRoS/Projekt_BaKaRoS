void sendViaBLE(){
  bluetooth::sendDataSet(&dataBytes[0], nrOfDataBytes);
}

void receiveViaBLE(){
  while(ble.available()){
      int c = ble.read();
  
      if(c != 0x0A && c != 0x20){
        received[receivedIndex] = (byte)c;
        receivedIndex++;

        if(receivedIndex > BLOCKSIZE){
          receivedIndex = 0;  
        }
  
        //Serial.print("received: <0x");
        if (c <= 0xF){
          Serial.print(F("0"));
        }
        Serial.print(c, HEX);

        if(receivedIndex%4 == 0){
          Serial.print(" ");  
        }
        //Serial.print(":");
        //Serial.print((char)c);
        //Serial.println(">");
        
       }
    }
    if(receivedIndex == BLOCKSIZE){
      Serial.println("");
      receivedData[0] = *(uint32_t*)&received[0];
      receivedData[1] = *(uint32_t*)&received[4];
      receivedData[2] = *(uint32_t*)&received[8];
      receivedData[3] = *(uint32_t*)&received[12];
      angle1 = ConvertB32ToFloat(receivedData[0]);
      angle2 = ConvertB32ToFloat(receivedData[1]);
      Serial.println(angle1);
      Serial.println(angle2);
      Serial.println(receivedData[3], BIN);
      Serial.println(receivedData[3], HEX);
      Serial.println(receivedData[3], DEC);
      receivedIndex = 0;  
    }
}

uint32_t ConvertFloatToB32(float f) {
  float normalized;
  int16_t shift;
  int32_t sign, exponent, significand;
 
  if (f == 0.0) 
    return 0; //handle this special case
  //check sign and begin normalization
  if (f < 0) { 
    sign = 1; 
    normalized = -f; 
  } else { 
    sign = 0; 
    normalized = f; 
  }
  //get normalized form of f and track the exponent
  shift = 0;
  while (normalized >= 2.0) { 
    normalized /= 2.0; 
    shift++; 
  }
  while (normalized < 1.0) { 
    normalized *= 2.0; 
    shift--; 
  }
  normalized = normalized - 1.0;
  //calculate binary form (non-float) of significand 
  significand = normalized*(0x800000 + 0.5f);
  //get biased exponent
  exponent = shift + 0x7f; //shift + bias
  //combine and return
  return (sign<<31) | (exponent<<23) | significand;
}
 
float ConvertB32ToFloat(uint32_t b32) {
  float result;
  int32_t shift;
  uint16_t bias;
 
  if (b32 == 0) 
    return 0.0;
  //pull significand
  result = (b32&0x7fffff); //mask significand
  result /= (0x800000);    //convert back to float
  result += 1.0f;          //add one back 
  //deal with the exponent
  bias = 0x7f;
  shift = ((b32>>23)&0xff) - bias;
  while (shift > 0) { 
    result *= 2.0; 
    shift--; 
  }
  while (shift < 0) { 
    result /= 2.0; 
    shift++; 
  }
  //sign
  result *= (b32>>31)&1 ? -1.0 : 1.0;
  return result;
}
