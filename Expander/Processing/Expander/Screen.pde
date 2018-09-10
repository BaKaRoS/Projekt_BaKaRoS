public class Screen{
   public Screen(PApplet app_, Data data1_, Data data2_){
     this.backgroundColor = color(220, 220, 220); //light gray
     this.fontColor = color(0, 0, 0); //black
     this.redColor = color(255, 0, 0); //red
     this.greenColor = color(0, 255, 0); //green
     this.leftMargin = width*0.02;
     this.topMargin = this.leftMargin;
     this.lineDistance = 5;
     this.ypos = 0;
     this.window = 0;
     
     this.drawBackground();
     this.drawHeader();
     this.data[0] = data1_;
     this.data[1] = data2_;
     
     this.trainingCounter = 0;
     this.schmittTriggerState = true;
     this.hand = true;
     
     this.form = new Form(app_, this.leftMargin*4.1, this.ypos, this.lineDistance, data1_, data2_);
   }
   
   public void drawFront(boolean left){
     //center point
     float centerX;
     float anglechange;
     float pitchDegree;
     if(left){
       centerX = (width-2*this.leftMargin)/6.0;
       anglechange = 30*this.data[0].getPitch();
       pitchDegree = this.data[0].getPitchDegree();
     }else{
       centerX = (width-2*this.leftMargin)/2.0;
       anglechange = 30*this.data[1].getPitch();
       pitchDegree = this.data[1].getPitchDegree();
     }
     float centerY = (height-2*this.leftMargin)/2.3;
     
     //axe coordinates
     float x = centerX-width*0.1;
     float x2 = centerX+width*0.1;
     float y = centerY-width*0.1;
     float y2 = centerY+width*0.1;
     
     //axe colors
     stroke(0, 0, 0);
     
     //body
     float bodywidth = 0.06;
     strokeWeight(2);
     fill(65,105,225); //shirt
     //quad(x+width*bodywidth, y+width*bodywidth/1.2-anglechange,
     //     x2-width*bodywidth, y+width*bodywidth/1.2+anglechange,
     //     x2-width*bodywidth, y2-width*bodywidth/1.2,
     //     x+width*bodywidth, y2-width*bodywidth/1.2
     //     );
      
      quad(x+width*bodywidth, y+width*bodywidth/1.2-anglechange,
          x2-width*bodywidth, y+width*bodywidth/1.2+anglechange,
          x2-width*bodywidth*1.33, y2-width*bodywidth/1.2,
          x+width*bodywidth*1.33, y2-width*bodywidth/1.2
          );
     
     //head
     fill(238,197,145); //skin color
     ellipse(0.5*(x+x2), centerY-0.4*(x2-x)+width*0.01, width/25.0, width/25.0);
     
     //horizontal axe (graph 1)
     line(x, centerY, x2, centerY);
     fill(this.fontColor);
     text("L", x+2*this.leftMargin, centerY-this.textSize*3/4.0);
     text("R", x2-2.3*this.leftMargin, centerY-this.textSize*3/4.0);
     
     //vertical axe (graph 1)
     line(0.5*(x+x2), centerY+0.5*(x2-x), x+(x2-x)/2.0, centerY-0.5*(x2-x));
     fill(this.fontColor);
     text(round(pitchDegree*10)/10.0+"º", centerX+this.leftMargin/2.0, y2);
     
   }
   
   public void drawSide(boolean left){
     //center point
     float centerX;
     float anglechange;
     float rollDegree;
     if(left){
       centerX = (width-2*this.leftMargin)/6.0;
       anglechange = 60*this.data[0].getRoll();
       rollDegree = this.data[0].getRollDegree();
     }else{
       centerX = (width-2*this.leftMargin)/2.0;
       anglechange = 60*this.data[1].getRoll();
       rollDegree = this.data[1].getRollDegree();
     }
     float centerY = (height-2*this.leftMargin)/1.2;
     
     //axe coordinates
     float x = centerX-width*0.1;
     float x2 = centerX+width*0.1;
     float y = centerY-width*0.1;
     float y2 = centerY+width*0.1;
     
     //axe colors
     stroke(0, 0, 0);
     
     //body
     float bodywidth = 0.075;
     strokeWeight(2);
     fill(65,105,225); //shirt
     //quad(x+width*bodywidth-anglechange, y+width*bodywidth/1.68,
     //     x2-width*bodywidth-anglechange, y+width*bodywidth/1.68,
     //     x2-width*bodywidth, y2-width*bodywidth/1.68,
     //     x+width*bodywidth, y2-width*bodywidth/1.68
     //     );
     quad(x+width*bodywidth-anglechange, y+width*bodywidth/1.5,
          x2-width*bodywidth-anglechange, y+width*bodywidth/1.5,
          (x2+x)/2.0, y2-width*bodywidth/1.68,
          (x2+x)/2.0, y2-width*bodywidth/1.68
          );
     
     //head
     fill(238,197,145); //skin color
     ellipse(0.5*(x+x2)-anglechange, centerY-0.4*(x2-x)+width*0.01, width/25.0, width/25.0);
     
     //horizontal axe (graph 2)
     line(x, centerY, x2, centerY);
     fill(this.fontColor);
     text("V", x+2*this.leftMargin, centerY-this.textSize*3/4.0);
     text("H", x2-2.3*this.leftMargin, centerY-this.textSize*3/4.0);
     
     //vertical axe (graph 2)
     line(0.5*(x+x2), centerY+0.5*(x2-x), x+(x2-x)/2.0, centerY-0.5*(x2-x));
     fill(this.fontColor);
     text(round(rollDegree*10)/10.0+"º", centerX+this.leftMargin/2.0, y2);
   }
   
   public void drawWeight(boolean left){  
     int factor;
     float scalingfactor = 1.0;
     float y = height-2*this.leftMargin;
     float y2;
     float weight;
     int offset;
     if(left){
       factor = 1;
       y2 = y-this.data[0].getWeight()/scalingfactor;
       weight = this.data[0].getWeight();
       offset = this.data[0].getWeightOffset();
     }else{
       factor = -1;
       y2 = y-this.data[1].getWeight()/scalingfactor;
       weight = this.data[1].getWeight();
       offset = this.data[1].getWeightOffset();
     }
     
     //bargraph coordinates
     float barwidth = width*0.05;
     float x = (width-2*this.leftMargin)/3.0;
     float x2 = x-factor*barwidth;
     
     //consider calibration
     y2 = y2+offset/scalingfactor;
     
     if(y2 > y){
       y2 = y;
     }else if(y2 < 10*this.leftMargin){
       y2 = 10*this.leftMargin;
     }
     
     //body
     stroke(0, 0, 0);
     strokeWeight(2);
     fill(0,153,0); //bargraph
     quad(x, y,
          x2, y,
          x2, y2,
          x, y2
          );
     
     fill(this.fontColor);
     text(""+weight, x2+factor*3*this.leftMargin/4.0, height-this.leftMargin);
   }
   
   public void drawBackground(){
     background(this.backgroundColor);
   }
   
   public void drawHeader(){
      //headline
     this.textSize = (int)(height*0.05);
     this.ypos = this.topMargin+this.textSize*3/4.0;
     fill(this.fontColor);
     textSize(this.textSize);
     text("SchoolBuddy", this.leftMargin, this.ypos);
     this.textSize /= 3.0;
     this.ypos += textSize*3/4.0+this.lineDistance;
     textSize(this.textSize);
     text("Fraunhofer IAO", this.leftMargin, this.ypos);
     
     //lines
     //line(this.leftMargin, ypos, width-this.leftMargin, this.ypos); //lower header margin
     this.ypos += 3*this.lineDistance;
     //line(this.leftMargin, ypos, width-this.leftMargin, this.ypos); //content header margin 
   }
   
   public void drawForm(){
     textSize(this.textSize);
     ypos += 4*this.lineDistance;
     text("Proband #:", this.leftMargin, this.ypos);
     text("Gewicht:", 13*this.leftMargin, this.ypos);
     text("Geschlecht:", 25*this.leftMargin, this.ypos);
     ypos += this.textSize*3/4.0+5*this.lineDistance;
     text("Alter:", this.leftMargin, this.ypos);
     text("Größe:", 13*this.leftMargin, this.ypos);
     text("Notizen:", 25*this.leftMargin, this.ypos);
     
     //lines
     //line(this.leftMargin, form.getYpos(), width-this.leftMargin, form.getYpos()); //lower header margin
   }
   
   public Form getForm(){
     return this.form;
   }
   
   public void drawStats(){
     float fps[] = {0.0, 0.0};
     fps[0] = this.data[0].getFps();
     fps[1] = this.data[1].getFps();
     
     if(fps[0] > 0){
       fill(this.fontColor);
       textSize(this.textSize);
       text("recording:", width*0.83, height*0.935);
       
       //time
       text("time:", width*0.85, height*0.955);
       text(round((millis()-this.data[0].getStartTime())/1000.0)+"s,", width*0.9, height*0.955);
       text(round((millis()-this.data[1].getStartTime())/1000.0)+"s,", width*0.95, height*0.955);
       
       //frames
       text("frames: ", width*0.85, height*0.975);
       text(this.data[0].getNumberOfFrames(), width*0.9, height*0.975);
       text(this.data[1].getNumberOfFrames(), width*0.95, height*0.975);
       
       //fps
       text("FPS: ", width*0.85, height*0.995);
       text(nf(fps[0], 2, 1), width*0.9, height*0.995);
       text(nf(fps[1], 2, 1), width*0.95, height*0.995);
     }
   }
   
   public int getWindow(){
     return this.window;
   }
   
   public void setWindow(int number){
     this.window = number;
   }
   
   public void drawCharts(){
     textSize(this.textSize);
     text("Auswertung", this.leftMargin, 0);
   }
   
   public void drawPatternResult(){
     
     fill(255, 0, 0);
     textSize(20);
     float textposition[]  = {200, 200};
     
     if(this.schmittTriggerState && highPressure(data[0], data[1], 100)){
       this.trainingCounter++;
       this.schmittTriggerState = false;
       
       if(this.trainingCounter%12 == 0){
         this.hand = !this.hand;
       }
     }else if(!this.schmittTriggerState && lowPressure(data[0], data[1], 70)){
       this.schmittTriggerState = true;
     }
     
     if(data[0].isCalibrated() && data[1].isCalibrated()){
       if(this.hand){
         //linke hand
         text("Linke Hand!", textposition[0], textposition[1]);
       }else{
         //rechte hand
         text("Rechte Hand!", textposition[0], textposition[1]);
       }
       textposition[1] += 30;
       text("Wiederholungen: "+ this.trainingCounter, textposition[0], textposition[1]);
     }else{
       text("Bitte kalibrieren.", textposition[0], textposition[1]);
     }
       textposition[1] += 30;
   }
   
   //movement counter
   private int trainingCounter;
   private boolean schmittTriggerState;
   private boolean hand;
   
   private color backgroundColor;
   private color redColor;
   private color greenColor;
   private color fontColor;
   private float topMargin;
   private float leftMargin;
   private int lineDistance;
   private Form form;
   private float ypos;
   private int textSize;
   private Data data[] = {null, null};
   private int window;
}