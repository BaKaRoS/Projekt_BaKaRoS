public class DisposeHandler {
  DisposeHandler(PApplet pa){
    pa.registerMethod("dispose", this);
  }
   
  public void dispose(){      
    println("window disposed");
    if(device[0] != null && device[1] != null){
      device[0].disconnect();
      device[1].disconnect();
    }
    println("exiting program");
    exit();
  } 
}