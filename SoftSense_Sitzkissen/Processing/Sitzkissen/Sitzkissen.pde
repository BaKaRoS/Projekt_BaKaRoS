import processing.serial.*;
import javax.swing.*;

//objects
DisposeHandler dh;
Screen screen = null;

// serial connection
String baudrate = "";
String port = "";
Serial serial = null;
int[] buffer =  new int[100];
byte bufferindex = 0;

void settings(){
  //register dispose handler
  dh = new DisposeHandler(this);
  
  //creating fullscreen window
  //size(800, 600, P3D);
  fullScreen();
}

void setup() {
  println("starting program");

  //left sensor
  Object[] options = Serial.list();
  
  JOptionPane alert = new JOptionPane();
  alert.requestFocus();
  
  //choose port
  if(Serial.list().length > 0){
    port = (String)alert.showInputDialog(
                    null,
                    "choose serial port",
                    "Port",
                    JOptionPane.PLAIN_MESSAGE,
                    null,
                    options,
                    options[0]); 
 }else{
   //no serial ports
   JOptionPane alert2 = new JOptionPane();
   alert2.requestFocus();
   alert2.showMessageDialog(null, "no serial ports available.");
   exit();
 }

  if(port == null) {
    //nothing selected
    println("no port chosen.");
    JOptionPane alert3 = new JOptionPane();
    alert3.requestFocus();
    alert3.showMessageDialog(null, "no port chosen.");
    exit();
  }else{
    JOptionPane alert4 = new JOptionPane();
    alert4.requestFocus();
    
    Object[] options2 = {"9600", "19200", "38400", "57600", "74880", "115200", "230400", "250000"};
    
    //choose baudrate
    baudrate = (String)alert4.showInputDialog(
                     null,
                     "choose baudrate",
                     "baudrate",
                     JOptionPane.PLAIN_MESSAGE,
                     null,
                     options2,
                     options2[5]); 
                     
   if(baudrate == null){
     //nothing selected
     println("no baudrate chosen.");
     JOptionPane alert5 = new JOptionPane();
     alert5.requestFocus();
     alert5.showMessageDialog(null, "no baudrate chosen.");
     exit();
   }else{
     //port and baudrate chosen
     println("establishing serial connection with "+port+" ("+baudrate+" baud).");
     
     try {
        serial = new Serial(this, port, int(baudrate));
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
   }
  }
  
  //creating screen object
  screen = new Screen(this);
}

void draw() {
  if(screen != null){
    screen.drawBackground();
    screen.draw();
  }
}

void serialEvent(Serial p){
  if(serial != null && serial.available() > 0){
    buffer[bufferindex] = p.read();
    bufferindex++;
    
    //check if full packet was received
    if(bufferindex > 9 && buffer[bufferindex-1] == 10 && buffer[bufferindex-2] == 13){
      screen.updateSizes();
    }
    
    
    
    //avoid buffer segmentation fault
    if(bufferindex >= 100){
      bufferindex = 0;
    }
  }
}