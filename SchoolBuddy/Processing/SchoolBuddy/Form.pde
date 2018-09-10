import controlP5.*;
import javax.swing.*;

public class Form{
   public Form(PApplet app, float x, float y, int lineDistance, Data data1_, Data data2_){
     this.cp5 = new ControlP5(app);
     
     this.data[0] = data1_;
     this.data[1] = data2_;
     
     this.fontColor = color(0, 0, 0); //black
     this.textfieldColor = color(230, 230, 230); //even light gray
     this.backgroundColor = color(220, 220, 220); //default background light gray
     this.activeColor = color(60, 60, 60); //dark gray
     
     //input container
     int textSize = (int)(height*0.05/3.0);
     
     PFont textfieldFont = createFont("SansSerif", textSize);
     
     //proband #
     this.cp5.addTextfield("nr")
             .setPosition(x, y)
             .setSize((int)(width*0.1), 2*textSize)
             .setFocus(true)
             .setColor(this.fontColor) //text
             .setColorBackground(this.textfieldColor) //background
             .setColorActive(fontColor) //active frame
             .setColorForeground(this.activeColor) //inactive frame
             .setAutoClear(false)
             .setFont(textfieldFont)
             .setLabel("");
             
     //weight
     this.cp5.addTextfield("weight")
             .setPosition(4*x, y)
             .setSize((int)(width*0.1), 2*textSize)
             .setFocus(false)
             .setColor(this.fontColor) //text
             .setColorBackground(this.textfieldColor) //background
             .setColorActive(fontColor) //active frame
             .setColorForeground(this.activeColor) //inactive frame
             .setAutoClear(false)
             .setFont(textfieldFont)
             .setLabel("");
             
     //gender
     this.cp5.addTextfield("gender")
             .setPosition(7*x, y)
             .setSize((int)(width*0.1), 2*textSize)
             .setFocus(false)
             .setColor(this.fontColor) //text
             .setColorBackground(this.textfieldColor) //background
             .setColorActive(fontColor) //active frame
             .setColorForeground(this.activeColor) //inactive frame
             .setAutoClear(false)
             .setFont(textfieldFont)
             .setLabel("");
     
     //age
     y += textSize*3/4.0+5*lineDistance;
     this.cp5.addTextfield("age")
             .setPosition(x, y)
             .setSize((int)(width*0.1), 2*textSize)
             .setFocus(false)
             .setColor(this.fontColor) //text
             .setColorBackground(this.textfieldColor) //background
             .setColorActive(this.fontColor) //active frame
             .setColorForeground(this.activeColor) //inactive frame
             .setAutoClear(false)
             .setFont(textfieldFont)
             .setLabel("");
             
     //size
     this.cp5.addTextfield("size")
             .setPosition(4*x, y)
             .setSize((int)(width*0.1), 2*textSize)
             .setFocus(false)
             .setColor(this.fontColor) //text
             .setColorBackground(this.textfieldColor) //background
             .setColorActive(fontColor) //active frame
             .setColorForeground(this.activeColor) //inactive frame
             .setAutoClear(false)
             .setFont(textfieldFont)
             .setLabel("");
             
     //notes
     this.cp5.addTextfield("notes")
             .setPosition(7*x, y)
             .setSize((int)(width*0.4), 2*textSize)
             .setFocus(false)
             .setColor(this.fontColor) //text
             .setColorBackground(this.textfieldColor) //background
             .setColorActive(fontColor) //active frame
             .setColorForeground(this.activeColor) //inactive frame
             .setAutoClear(false)
             .setFont(textfieldFont)
             .setLabel("");
             
     //save button
     y += textSize*3/4.0+5*lineDistance;
     this.cp5.addBang("save")
             .setPosition(x, y)
             .setSize((int)(width*0.1), 2*textSize)
             .setColorBackground(this.textfieldColor) //background
             .setColorForeground(this.fontColor) //inactive frame
             .setColorActive(this.activeColor) //active frame
             .setFont(textfieldFont)
             .setTriggerEvent(Bang.RELEASE)
             .setLabel(""); 
     this.cp5.addTextlabel("savepersondata")
             .setPosition(x+(int)(width*0.024), y+0.5*textSize*3/4.0)
             .setColor(this.textfieldColor) //text
             .setColorActive(this.fontColor) //active frame
             .setColorForeground(this.fontColor) //inactive frame
             .setFont(textfieldFont)
             .setValue("Speichern");
             
     //calibration button
     this.cp5.addBang("calibrate")
             .setPosition(width*0.7, height*0.3)
             .setSize((int)(width*0.1), 2*textSize)
             .setColorBackground(this.textfieldColor) //background
             .setColorForeground(this.fontColor) //inactive frame
             .setColorActive(this.activeColor) //active frame
             .setFont(textfieldFont)
             .setTriggerEvent(Bang.RELEASE)
             .setLabel("")
             .hide(); 
     this.cp5.addTextlabel("calib")
             .setPosition(width*0.7+(int)(width*0.019), height*0.3+0.5*textSize*3/4.0)
             .setColor(this.textfieldColor) //text
             .setColorActive(this.fontColor) //active frame
             .setColorForeground(this.fontColor) //inactive frame
             .setFont(textfieldFont)
             .setValue("Kalibrieren")
             .hide();
     
     //stop&save button
     this.cp5.addBang("stop")
             .setPosition(width*0.7, height*0.95)
             .setSize((int)(width*0.1), 2*textSize)
             .setColorBackground(this.textfieldColor) //background
             .setColorForeground(this.fontColor) //inactive frame
             .setColorActive(this.activeColor) //active frame
             .setFont(textfieldFont)
             .setTriggerEvent(Bang.RELEASE)
             .setLabel("")
             .hide(); 
     this.cp5.addTextlabel("stoprecord")
             .setPosition(width*0.7+(int)(width*0.018), height*0.95+0.5*textSize*3/4.0)
             .setColor(this.textfieldColor) //text
             .setColorActive(this.fontColor) //active frame
             .setColorForeground(this.fontColor) //inactive frame
             .setFont(textfieldFont)
             .setValue("Abspeichern")
             .hide();
             
     this.ypos = y;
   }
   
   public float getYpos(){
     return this.ypos;
   }
   
   public void save(){
     this.cp5.getController("nr").setLock(true);
     this.cp5.getController("nr").setColorBackground(backgroundColor);
     this.cp5.getController("nr").setColorForeground(backgroundColor);
     this.cp5.getController("nr").setColorActive(backgroundColor);
     this.cp5.getController("age").setLock(true);
     this.cp5.getController("age").setColorBackground(backgroundColor);
     this.cp5.getController("age").setColorForeground(backgroundColor);
     this.cp5.getController("age").setColorActive(backgroundColor);
     this.cp5.getController("gender").setLock(true);
     this.cp5.getController("gender").setColorBackground(backgroundColor);
     this.cp5.getController("gender").setColorForeground(backgroundColor);
     this.cp5.getController("gender").setColorActive(backgroundColor);
     this.cp5.getController("size").setLock(true);
     this.cp5.getController("size").setColorBackground(backgroundColor);
     this.cp5.getController("size").setColorForeground(backgroundColor);
     this.cp5.getController("size").setColorActive(backgroundColor);
     this.cp5.getController("notes").setLock(true);
     this.cp5.getController("notes").setColorBackground(backgroundColor);
     this.cp5.getController("notes").setColorForeground(backgroundColor);
     this.cp5.getController("notes").setColorActive(backgroundColor);
     this.cp5.getController("weight").setLock(true);
     this.cp5.getController("weight").setColorBackground(backgroundColor);
     this.cp5.getController("weight").setColorForeground(backgroundColor);
     this.cp5.getController("weight").setColorActive(backgroundColor);
     this.cp5.getController("save").hide();
     this.cp5.getController("savepersondata").hide();
     
     this.data[0].startRecording();
     this.data[0].addPersonData(this.cp5.get(Textfield.class, "nr").getText(), this.cp5.get(Textfield.class, "gender").getText(), this.cp5.get(Textfield.class, "weight").getText(), this.cp5.get(Textfield.class, "size").getText(), this.cp5.get(Textfield.class, "age").getText(), this.cp5.get(Textfield.class, "notes").getText());
     this.data[1].startRecording();
     this.data[1].addPersonData(this.cp5.get(Textfield.class, "nr").getText(), this.cp5.get(Textfield.class, "gender").getText(), this.cp5.get(Textfield.class, "weight").getText(), this.cp5.get(Textfield.class, "size").getText(), this.cp5.get(Textfield.class, "age").getText(), this.cp5.get(Textfield.class, "notes").getText());
     
     this.cp5.getController("stop").show();
     this.cp5.getController("stoprecord").show();
     this.cp5.getController("calibrate").show();
     this.cp5.getController("calib").show();
   } 
   
   public void stopRecording(){
     boolean isconnected = false;
     
     if(this.data[0].recording()){
       isconnected = true;
       this.data[0].saveFile();
       this.data[0].stopRecording();
     }
     
     if(this.data[1].recording()){
       isconnected = true;
       this.data[1].saveFile();
       this.data[1].stopRecording();
     }
     
     if(isconnected == true){
       JOptionPane.showMessageDialog(null, "Daten gespeichert.");
       //dh.dispose();
       exit();
     }
   }
   
   void calibrate(){
     this.data[0].calibrate();
     this.data[1].calibrate();
     
     println("calibrated");
   }
   
   private ControlP5 cp5;
   private color textfieldColor;
   private color activeColor;
   private color backgroundColor;
   private color fontColor;
   private float ypos;
   private Data data[] = {null, null};
}

public void save() {
   screen.getForm().save();
}

public void stop() {
   screen.getForm().stopRecording();
}

public void calibrate() {
   screen.getForm().calibrate();
}