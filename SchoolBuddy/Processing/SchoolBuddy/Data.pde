public class Data{
  
  public Data(int sensorNumber_){
    this.sensorNumber = sensorNumber_;
    
    this.table = new Table();
    this.table.addColumn("id");
    this.table.addColumn("battery");
    this.table.addColumn("weight");
    this.table.addColumn("accelerometerX");
    this.table.addColumn("accelerometerY");
    this.table.addColumn("accelerometerZ");
    this.table.addColumn("gyroscopeX");
    this.table.addColumn("gyroscopeY");
    this.table.addColumn("gyroscopeZ");
    this.table.addColumn("temperature");
    this.table.addColumn("input");
    this.table.addColumn("millis");
    
    this.personData = new Table();
    this.personData.addColumn("number");
    this.personData.addColumn("gender");
    this.personData.addColumn("weight");
    this.personData.addColumn("size");
    this.personData.addColumn("age");
    this.personData.addColumn("notes");
    this.personData.addColumn("date");
    
    this.record = false;
    this.nrOfSavedSamples = 0;
    this.time = 0;
    this.fps = 0;
    this.input = 0;
    this.rollOffset = 0;
    this.pitchOffset = 0;
    this.weightOffset = 0;
    this.calibrated = false;
  }
  
  public void addData(float battery_, int weight_, int accX_, int accY_, int accZ_, int gyrX_, int gyrY_, int gyrZ_, float temp_){
    //set attributes
    this.accX = accX_;
    this.accY = accY_;
    this.accZ = accZ_;
    this.gyrX = gyrX_;
    this.gyrY = gyrY_;
    this.gyrZ = gyrZ_;
    this.battery = battery_;
    this.weightSensor = weight_;
    this.temp = temp_;
    int id = this.table.lastRowIndex()+1;
    
    TableRow newRow = this.table.addRow();
    newRow.setInt("id", id);
    newRow.setFloat("battery", this.battery);
    newRow.setInt("weight", this.weightSensor);
    newRow.setInt("accelerometerX", this.accX);
    newRow.setInt("accelerometerY", this.accY);
    newRow.setInt("accelerometerZ", this.accZ);
    newRow.setInt("gyroscopeX", this.gyrX);
    newRow.setInt("gyroscopeY", this.gyrY);
    newRow.setInt("gyroscopeZ", this.gyrZ);
    newRow.setFloat("temperature", this.temp);
    newRow.setInt("input", this.input);
    
    //fix first time entry
    if(id == 0){
      newRow.setInt("millis", 0);
    }else{
      newRow.setInt("millis", millis()-this.starttime);
    }
    
    //reset input
    if(this.input != 0){
      this.input = 0;
    }
    
    this.nrOfSavedSamples = id+1; //starting with 0
    
    if(this.nrOfSavedSamples%(fs/5) == 0){
      this.fps = (fs/5)*1000.0/(millis()-this.time);
      this.time = millis();
    }
    
    if(this.nrOfSavedSamples%(fs*5) == 0){
      println(this.nrOfSavedSamples+" frames recorded.");
    }
  }
  
  public void addPersonData(String number_, String gender_, String weight_, String size_, String age_, String notes_){
    //set attributes
    this.number = number_;
    this.age = age_;
    this.gender = gender_;
    this.size = size_;
    this.notes = notes_;
    this.weight = weight_;
    
    TableRow newRow = this.personData.addRow();
    newRow.setString("number", this.number);
    newRow.setString("gender", this.gender);
    newRow.setString("weight", this.weight);
    newRow.setString("size", this.size);
    newRow.setString("age", this.age);
    newRow.setString("notes", this.notes);
    newRow.setString("date", this.date);
    
    println("person data saved.");
  }
  
  public void saveFile(){
    saveTable(this.table, this.filename1);
    if(this.sensorNumber == 1){
      saveTable(this.personData, this.filename2);
      println("file "+this.filename2+" saved.");
    }
    println("file "+this.filename1+" saved."); 
  }
  
  public boolean recording(){
    return this.record;
  }
  
  public void stopRecording(){
    this.record = false;
    this.fps = 0;
  }
  
  public void startRecording(){   
    this.date = day()/10+""+day()%10+"."+month()/10+""+month()%10+"."+year()+" "+hour()/10+""+hour()%10+":"+minute()/10+""+minute()%10+":"+second()/10+""+second()%10;
    this.filename1 = year()+""+month()/10+""+month()%10+""+day()/10+""+day()%10+"-"+hour()/10+""+hour()%10+""+minute()/10+""+minute()%10+""+second()/10+""+second()%10+"-"+this.sensorNumber+"-record.csv";
    this.filename2 = year()+""+month()/10+""+month()%10+""+day()/10+""+day()%10+"-"+hour()/10+""+hour()%10+""+minute()/10+""+minute()%10+""+second()/10+""+second()%10+"-data.csv";
    
    this.starttime = millis();
    this.record = true;
    println("starting data recording for sensor "+this.sensorNumber+".");
  }
  
  public float getFps(){
    return this.fps;
  }
  
  public void setInput(int in){
    this.input = in;
  }
  
  public int getStartTime(){
    return this.starttime;
  }
  
  public int getNumberOfFrames(){
    return this.nrOfSavedSamples;
  }
  
  public int getWeight(){
    return this.weightSensor;
  }
  
  public float getRoll(){
    //roll: V-H
    int var1 = accZ; //X
    int var2 = accY; //Z
    //float roll = atan2(-var1, var2)-PI/2.0-this.rollOffset;
    float roll = atan2(-var1, var2)-this.rollOffset;
    
    if(!this.record){
      return 0;
    }else if(roll >= PI/3.0 || roll <= -PI){
      return PI/3.0;
    }else if(roll <= -PI/3.0){
      return -PI/3.0;
    }else{
      return roll;
    }
  }
  
  public float getRollDegree(){
    //roll: V-H
    int var1 = accZ; //X
    int var2 = accY; //Z
    //float roll = atan2(-var1, var2)-PI/2.0-this.rollOffset;
    float roll = atan2(-var1, var2)-this.rollOffset;
    return roll*180.0/PI;
  }
  
  public float getPitch(){
    //pitch: L-R
    int var1 = accZ; //X
    int var2 = accX; //Y
    int var3 = accY; //Z
    float pitch = atan2(var2, sqrt(var1*var1+var3*var3))-this.pitchOffset;
    
    if(pitch > 40/180.0*PI){
      return 40/180.0*PI;
    }else if(pitch < -40/180.0*PI){
      return -40/180.0*PI;
    }else{
      return pitch;
    }
  }
  
  public float getPitchDegree(){
    //pitch: L-R
    int var1 = accZ; //X
    int var2 = accX; //Y
    int var3 = accY; //Z
    float pitch = atan2(var2, sqrt(var1*var1+var3*var3))-this.pitchOffset;
    return pitch*180.0/PI;
  }
  
  void calibrate(){
    this.input = 1;
    
    this.rollOffset = atan2(-accZ, accY);
    this.pitchOffset = atan2(accX, sqrt(accZ*accZ+accY*accY));
    this.weightOffset = this.weightSensor;
    
    this.calibrated = true;
  }
  
  int getWeightOffset(){
    return this.weightOffset;
  }
  
  float getWeightKG(){
    float weightKG = 0;
    int calib[] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
    
    if(this.sensorNumber == 1){
      // sensor 1, left: 5
      calib[0] = 0; // 1 kg
      calib[1] = 0; // 1.25 kg
      calib[2] = 0; // 2 kg
      calib[3] = 0; // 2.25 kg
      calib[4] = 0; // 2.5 kg
      calib[5] = 0; // 3 kg
      calib[6] = 0; // 3.25 kg
      calib[7] = 0; // 3.5 kg
      calib[8] = 0; // 3.75 kg
    }else{
      // sensor 2, right: 6
      calib[0] = 0; // 1 kg
      calib[1] = 0; // 1.25 kg
      calib[2] = 0; // 2 kg
      calib[3] = 0; // 2.25 kg
      calib[4] = 0; // 2.5 kg
      calib[5] = 0; // 3 kg
      calib[6] = 0; // 3.25 kg
      calib[7] = 0; // 3.5 kg
      calib[8] = 0; // 3.75 kg
    }
    
    double oneValue = 0;
    if(this.weightSensor > calib[8]){
      oneValue = 3.75/(float)calib[8];  
    }else if(this.weightSensor > calib[7]){
      oneValue = 3.5/(float)calib[7];  
    }else if(this.weightSensor > calib[6]){
      oneValue = 3.25/(float)calib[6];  
    }else if(this.weightSensor > calib[5]){
      oneValue = 3/(float)calib[5];  
    }else if(this.weightSensor > calib[4]){
      oneValue = 2.5/(float)calib[4];  
    }else if(this.weightSensor > calib[3]){
      oneValue = 2.25/(float)calib[3];  
    }else if(this.weightSensor > calib[2]){
      oneValue = 2/(float)calib[2];  
    }else if(this.weightSensor > calib[1]){
      oneValue = 1.25/(float)calib[1];  
    }else{
      oneValue = 1/calib[0];  
    }
    
    weightKG = (float)(this.weightSensor*oneValue);
    return weightKG;
  }
  
  boolean vibrate(){
    if(abs(this.getRollDegree()) >= 5 || abs(this.getPitchDegree()) >=5){
      return (true && this.calibrated);
    }
      return (false && this.calibrated);
  }
  
  //sensor data
  private int accX;
  private int accY;
  private int accZ;
  private int gyrX;
  private int gyrY;
  private int gyrZ;
  private float battery;
  private int weightSensor;
  private float temp;
  
  //calibration
  private float rollOffset;
  private float pitchOffset;
  private int weightOffset;
  private boolean calibrated;
  
  //person data
  private String number;
  private String gender;
  private String size;
  private String notes;
  private String weight;
  private String age;
  private String date;
  
  //filenames
  private String filename1;
  private String filename2;
  private int sensorNumber;
  
  private Table table;
  private Table personData;
  private boolean record;
  private int nrOfSavedSamples;
  private long time;
  private float fps;
  private int input;
  private int starttime;
}