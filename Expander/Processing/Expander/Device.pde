import processing.serial.*;
//class to handle a device

public class Device{
   public Device(PApplet app, String port_, int baudrate_, Data data_){
     //set attributes
     this.data = data_;
     this.buffer = new int[100];
     this.bufferIndex = 0;
     this.port = port_;
     this.baudrate = baudrate_;
     
     //create serial connection
     try {
        serial = new Serial(app, this.port, this.baudrate);
     }
      catch(Exception e){
        String error = e.getMessage();
        if (error.contains("Port not found")){
          print("port ");
          print(port);
          println(" not found");
        }else if(error.contains("Port busy")){
          print("port ");
          print(port);
          println(" is busy");
        }else{
          println(e.getMessage());
        }
      }
      
      //if object creation was successfull
     if(this.serial != null){
       //wait for connection to be established
       while(!this.serial.active()){}
       println("connection established");
     }else{
       println("serial object for port " + port + " could not be created");
     }
      
}
   
   public boolean isConnected(){
     return this.serial != null;
   }
   
   public void disconnect(){
     //close serial connection
     if(isConnected()){
       this.serial.stop();
       println("connection closed");
     }
   }
   
   public void addToBuffer(int data){
     this.buffer[this.bufferIndex] = data;
   }
   
   public void checkforLineEnd(){   
      if(this.bufferIndex >= 19 && this.buffer[this.bufferIndex-1] == 13 && this.buffer[this.bufferIndex] == 10){  
        //temperature
        this.temp = (double)(this.buffer[this.bufferIndex-2]+256*this.buffer[this.bufferIndex-3])/100.0;
        
        //gyroscope
        this.gyrData[2] = this.buffer[this.bufferIndex-4]+256*this.buffer[this.bufferIndex-5];
        this.gyrData[1] = this.buffer[this.bufferIndex-6]+256*this.buffer[this.bufferIndex-7];
        this.gyrData[0] = this.buffer[this.bufferIndex-8]+256*this.buffer[this.bufferIndex-9];
        
        //accelerometer
        this.accData[2] = this.buffer[this.bufferIndex-10]+256*this.buffer[this.bufferIndex-11];
        this.accData[1] = this.buffer[this.bufferIndex-12]+256*this.buffer[this.bufferIndex-13];
        this.accData[0] = this.buffer[this.bufferIndex-14]+256*this.buffer[this.bufferIndex-15];
        
        //unsigned --> signed
        for(int i=0; i<3; i++){
            this.accData[i] = (int)(this.accData[i]-32768);
            this.gyrData[i] = (int)(this.gyrData[i]-32768);
        }
        
        //weight
        this.weight = this.buffer[this.bufferIndex-16]+256*this.buffer[this.bufferIndex-17];
        
        //battery
        this.bat = this.buffer[this.bufferIndex-18]+256*this.buffer[this.bufferIndex-19];
        
        //recording
        this.data.addData(this.bat, this.weight, this.accData[0], this.accData[1], this.accData[2], this.gyrData[0], this.gyrData[1], this.gyrData[2], (float)this.temp);
        
        this.bufferIndex = 0;
      }else if(this.bufferIndex < 99){
         this.bufferIndex++;
      }else{
        this.bufferIndex = 0;
      }
   }
   
   public Serial getSerial(){
     return this.serial;
   }
   
   public void serialEvent(){
     this.addToBuffer(this.serial.read());
     if(this.data.recording()){
       this.checkforLineEnd();
     }
   }
   
   public void checkVibrate(){
     //if(this.data.vibrate()){
       //this.serial.write(118); //v
       //println("vibrate");
     //}
   }
   
   private Serial serial;
   private String port;
   private int baudrate;
   private int buffer[];
   private int bufferIndex;
   private int accData[] = {0, 0, 0};
   private int gyrData[] = {0, 0, 0};
   private double temp = 0;
   private float bat = 0;
   private int weight = 0;
   private Data data;
}