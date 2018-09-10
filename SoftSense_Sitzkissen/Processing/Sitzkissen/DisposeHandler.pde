public class DisposeHandler {
  DisposeHandler(PApplet pa){
    pa.registerMethod("dispose", this);
  }
   
  public void dispose(){      
    println("window disposed");
    if(serial != null){
      println("closing serial connection.");
      serial.stop();
    }
    println("exiting program");
    exit();
  } 
}