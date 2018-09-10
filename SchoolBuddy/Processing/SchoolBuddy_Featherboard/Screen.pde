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
     float scalingfactor = 2.0;
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
     y2 = y2-300+offset/scalingfactor;
     
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
   
   public void drawCharts(){
     textSize(2*this.textSize);
     ypos += 15*this.lineDistance;
     text("Auswertung:", this.leftMargin, this.ypos);
     
     //pie chart LR
     float diameter = width/5.0;
     float[] center = {width/8.0, height*4/10.0};
     float lastAngle = 0;
     int[] data = {230, 10, 45}; //RYG
     color[] colors = { color(255, 0, 0),  color(255, 255, 0),  color(0, 255, 0)}; //RYB
     float sum = 0;
     for (int i = 0; i < data.length; i++) {
       sum += data[i];
     }
     
     for (int i = 0; i < data.length; i++) {
       fill(colors[i]);
       arc(center[0], center[1], diameter, diameter, lastAngle, lastAngle+radians(data[i]*360/sum));
       lastAngle += radians(data[i]*360/sum);
     }
     
     
     //pie chart VH
     center[0] = center[0]*3.5;
     lastAngle = 0;
     int[] data2 = {80, 110, 45}; //RYG
     sum = 0;
     for (int i = 0; i < data2.length; i++) {
       sum += data2[i];
     }
     
     for (int i = 0; i < data2.length; i++) {
       fill(colors[i]);
       arc(center[0], center[1], diameter, diameter, lastAngle, lastAngle+radians(data2[i]*360/sum));
       lastAngle += radians(data2[i]*360/sum);
     }
     
   }
   
   public void setWindow(int number){
     this.window = number;
   }
   
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