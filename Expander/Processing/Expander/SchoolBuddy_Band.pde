import processing.serial.*;
import javax.swing.*;

//sampling rate
static int fs = 40;

//links: COM7
//rechts: COM9

//objects
DisposeHandler dh;
Device[] device = {null, null};
Screen screen;
Data[] data = {null, null};

// serial connection
static int baudrate = 115200;

void settings(){
  //register dispose handler
  dh = new DisposeHandler(this);
  
  //creating fullscreen window
  //size(1920, 1080, P3D);
  fullScreen();
}

void setup() {
  println("starting program");

  //left sensor
  Object[] options = Serial.list();
  String chosenport[] = {"", ""};
  JOptionPane alert = new JOptionPane();
  alert.requestFocus();
  
  if(Serial.list().length > 1){
    chosenport[0] = (String)alert.showInputDialog(
                    null,
                    "Port für SchoolBuddy_L auswählen:",
                    "SchoolBuddy_L",
                    JOptionPane.PLAIN_MESSAGE,
                    null,
                    options,
                    options[0]);       
    chosenport[1] = (String)alert.showInputDialog(
                    null,
                    "Port für SchoolBuddy_R auswählen:",
                    "SchoolBuddy_R",
                    JOptionPane.PLAIN_MESSAGE,
                    null,
                    options,
                    options[1]);
 }else{
   JOptionPane alert5 = new JOptionPane();
   alert5.requestFocus();
   alert5.showMessageDialog(null, "Nicht genug Serial Ports vorhanden, Programm wird beendet.");
   exit();
 }

  boolean bothconnected = true;
  for(int i=0; i<2; i++){
    if ((chosenport[i] == null) || (chosenport[i].length() <= 0)) {
      println("no port chosen.");
      JOptionPane alert2 = new JOptionPane();
      alert2.requestFocus();
      alert2.showMessageDialog(null, "Keinen Port für Sensor "+(i+1)+" ausgewählt, Programm wird beendet.");
      exit();
    }else{
      //creating data object
      data[i] = new Data(i+1);
    
      //creating device object
      device[i] = new Device(this, chosenport[i], baudrate, data[i]);
      
      if(!device[i].isConnected()){
        println("device not connected");
        bothconnected = false;
        JOptionPane alert4 = new JOptionPane();
        alert4.requestFocus();
        alert4.showMessageDialog(null, "Kein Gerät am Port "+chosenport[i]+".");
      }
    }
  }
  
  if(bothconnected){
     //creating screen object
     screen = new Screen(this, data[0], data[1]);
  }else{
    JOptionPane alert3 = new JOptionPane();
    alert3.requestFocus();
    alert3.showMessageDialog(null, "Nicht alle Sensoren angeschlossen, Programm wird beendet.");
    println("Nicht alle Sensoren angeschlossen, Programm wird beendet.");
    exit();
  }
}

void draw() {
  screen.drawBackground();
  screen.drawHeader();
  screen.drawForm();
  if(data[0].recording() || data[1].recording()){
    switch(screen.getWindow()){
      case 0:
        //screen.drawFront(true);
        //screen.drawFront(false);
        //screen.drawSide(true);
        //screen.drawSide(false);
        screen.drawWeight(true);
        screen.drawWeight(false);
        //device[0].checkVibrate();
        //device[1].checkVibrate();
        break;
      case 1:
        screen.drawCharts();
        break;
    }
  }
  screen.drawStats();
  screen.drawPatternResult();
}

void serialEvent(Serial p){
  if(p == device[0].getSerial()){
    device[0].serialEvent();
  }else if(p == device[1].getSerial()){
    device[1].serialEvent();
  }
}