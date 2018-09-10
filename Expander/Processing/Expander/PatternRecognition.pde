static boolean highPressure(Data data1, Data data2, int threshold){
  if(data1.isCalibrated() && data2.isCalibrated() && data1.getWeight() > threshold && data2.getWeight() > threshold){
   return true;
  }

  return false;
}

static boolean lowPressure(Data data1, Data data2, int threshold){
  if(data1.isCalibrated() && data2.isCalibrated() && data1.getWeight()-data1.getWeightOffset() < threshold && data2.getWeight()-data2.getWeightOffset() < threshold){
   return true;
  }

  return false;
}