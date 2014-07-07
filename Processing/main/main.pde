// creates visual design. Reads and interprets data from Arduino

import processing.serial.*;

Serial myPort;
float[] vals; //will have to parse values

int numCircles;
Round[] rounds;

void setup() {
  //Arduino comm
  //println(Serial.list()); 
  //myPort = new Serial(this, Serial.list()[1], 9600);
  //myPort.bufferUntil('\n');
  
  // array of values from arduino
  vals = new float[2];
  
  //visuals
  size(800, 600, P2D);
  colorMode(HSB, 360, 100, 100, 100 );
  //frameRate(5);
    
  println("start some circles!");  
  rounds = new Round[0];  
  setBaseCircles(); //create starter circles 
  background(255);
  noStroke();  
}

void draw() {
  // read in Serial data 
//  if( myPort.available() > 0 ) {
//    vals[0] = myPort.read(); // potentiometer
//    //vals[1] = myPort.read();
//  }  
  
 // println(vals[0]);
  fill(0, 100, 100, 1); //slightly transparent
  rect(0, 0, width, height);
  
  //draw circles
  for(int i = 0; i < numCircles; i++) {
    rounds[i].drawCircle();
  }  
} 

void setBaseCircles() { //static for now, can be adjusted later
  numCircles = 150;
  rounds = new Round[numCircles];
  println("making circles");
  for(int i = 0; i < numCircles; i++) {
    rounds[i] = new Round(random(width - 100) + 50, random(height - 100) + 50, 200.0, 179.0); // random position, standard start radius, solid color. Will change to map to sensor later
  }  
}  

class Round {
  float xPos;
  float yPos;
  float rad;
  float col;
  
  Round(float xPos, float yPos, float rad, float col) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.rad = rad;
    this.col = col + random(80) - 40;
  }

  void drawCircle() {
    fill(col, 36, 74, 5); // very transparent, makes color over time
    
    //change from random to noise
    float xDelta = random(40) - 20;
    float yDelta = random(40) - 20;
    rad = sqrt(pow(xDelta, 2) + pow(yDelta, 2))*8; // radius is distanse of position change
    ellipse(xPos + xDelta, yPos + yDelta, rad, rad);
  }

  void changeCol(int newCol){
    this.col = newCol;
  }  
}  
