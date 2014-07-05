// creates visual design. Reads and interprets data from Arduino

import processing.serial.*;

Serial myPort;
int[] vals; //will have to parse values

void setup() {
  println(Serial.list()); // print serial ports, select the appropriate one in the line below
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.bufferUntil('\n');
  vals = new int[1];
  vals[0] = 0;
}

void draw() {
  if( myPort.available() > 0 ) {
    vals[0] = myPort.read();
  }  
  
  println(vals[0]);
}  

//void serialEvent(Serial myPort) {
//  val = myPort.readStringUntil('\n');
//  
//}  
