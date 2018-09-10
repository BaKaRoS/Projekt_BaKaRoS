public class Screen{
   public Screen(PApplet app_){
     this.app = app_;
     this.vector = new PVector(0,0);
     this.numberofVectors = 0;
     size = new int[6];
     calib = new int[4];
     dots = new int[100];
     for(int i = 0; i < 6; i++){
       size[i] = 20;
       calib[i%4] = 0;
     }
     
     this.arrowX = 0;
     this.arrowY = 0;
     
     this.backgroundColor = color(220, 220, 220); //light gray
     this.calibrated = false;
   }
   
   public void updateSizes(){
     int defaultsize = 20;
     int multiplier = 4;
     size[0] = defaultsize+(buffer[bufferindex-10]*255+buffer[bufferindex-9]-calib[0])*multiplier;
     size[1] = defaultsize+(buffer[bufferindex-8]*255+buffer[bufferindex-7]-calib[1])*multiplier;
     size[2] = defaultsize+(buffer[bufferindex-6]*255+buffer[bufferindex-5]-calib[2])*multiplier;
     size[3] = defaultsize+(buffer[bufferindex-4]*255+buffer[bufferindex-3]-calib[3])*multiplier;
     
     //avoid becoming to small
     for(int i = 0; i < 4; i++){
      if(size[i] < defaultsize){
        size[i] = defaultsize;
      }
     }
     
     //calibrate
     if(!this.calibrated){
        calib[0] = buffer[bufferindex-10]*255+buffer[bufferindex-9];
        calib[1] = buffer[bufferindex-8]*255+buffer[bufferindex-7];
        calib[2] = buffer[bufferindex-6]*255+buffer[bufferindex-5];
        calib[3] = buffer[bufferindex-4]*255+buffer[bufferindex-3];
        this.calibrated = true;
        updateSizes();
     }
     
     size[5] = (size[1]+size[3])/2;
     size[4] = (size[0]+size[2])/2;
     
     //force arrow
     arrowX = -size[0]-size[2]+size[1]+size[3];
     arrowY = -size[0]-size[1]+size[2]+size[3];
     
     //reset buffer index
     bufferindex = 0;
   }
   
   public void drawBackground(){
     background(this.backgroundColor);
   }
   
   public void draw(){
     fill(0, 255, 0);
     stroke(0, 0, 0);
     ellipse(width/3, height/4, size[0], size[0]); //links oben
     ellipse(2*width/3, height/4, size[1], size[1]); //rechts oben
     ellipse(width/3, 3*height/4, size[2], size[2]); //links unten
     ellipse(2*width/3, 3*height/4, size[3], size[3]); //rechts unten
     ellipse(3.5*width/10, height/2, 2*size[4]/3, 2*size[4]/3); //rechts mitte
     ellipse(6.5*width/10, height/2, 2*size[5]/3, 2*size[5]/3); //links mitte
     
     //stroke(255, 0, 0);
     //drawForceArrow(width/2, height/2, width/2+arrowX, height/2+arrowY);
     
     //stroke(0, 0, 255);
     //drawIndexArrow(width/2, height/2, (int)(width/2+vector.x/numberofVectors), (int)(height/2+vector.y/numberofVectors));
     
     if(this.numberofVectors >= 1000){
       println("length: "+vector.mag()/numberofVectors);
       println("angle: "+180*PVector.angleBetween(vector, new PVector(0, 1))/PI);
       this.vector = new PVector(0,0);
       this.numberofVectors = 0;
     }
   }
   
   private int arrowX;
   private int arrowY;
   private int[] size;
   private int[] calib;
   private boolean calibrated;
   private PApplet app;
   private color backgroundColor;
   public PVector vector;
   public long numberofVectors;
   private int[] dots;
}

void drawForceArrow(int x1, int y1, int x2, int y2){
  int len = (int)sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
  float angle = atan2((y1-y2), (x1-x2));
  pushMatrix();
  translate(x1, y1);
  rotate((angle+180-45)%360);
  line(0,0,len, 0);
  line(len, 0, len - 8, -8);
  line(len, 0, len - 8, 8);
  popMatrix();
  PVector v = PVector.fromAngle(angle);
  v.setMag(len);
  screen.vector.add(v);
  screen.numberofVectors++;
}

void drawIndexArrow(int x1, int y1, int x2, int y2){
  int len = (int)sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
  float angle = atan2((y1-y2), (x1-x2));
  pushMatrix();
  translate(x1, y1);
  rotate((angle)%360);
  line(0,0,len, 0);
  line(len, 0, len - 8, -8);
  line(len, 0, len - 8, 8);
  popMatrix();
}