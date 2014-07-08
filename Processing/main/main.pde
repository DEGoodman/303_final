// creates visual design. Reads and interprets data from Arduino
import org.firmata.*;
import cc.arduino.*;
import processing.serial.*;
import ddf.minim.*;

Arduino arduino;
Minim minim;
AudioInput in;
int vals; //will have to parse values

int numCircles;
Round[] rounds;

// sensors
int pot;
int lightRes;

void setup() {
  size(800, 600, P2D);
  
  minim = new Minim(this);
  in = minim.getLineIn();
  
  //Arduino comm
  println(Arduino.list()); 
  arduino = new Arduino(this, Arduino.list()[1], 57600);
 // myPort.bufferUntil('\n');
  
  // array of values from arduino
  //vals;
  
  //visuals
  
  colorMode(HSB, 360, 100, 100, 500 );
  //frameRate(5);
    
  rounds = new Round[0];  
  setBaseCircles(); //create starter circles 
  background(255);
  noStroke();  
}

void draw() {
  // read sensor data
  pot = arduino.analogRead(0);
  
  lightRes = arduino.analogRead(1);
  
  println(pot + "," + lightRes);
  println(in.mix.level()*100); // prints 
//  // read in Serial data 
//  if( myPort.available() > 0 ) {
//    vals = myPort.read(); // potentiometer
//    //vals[1] = myPort.read();
//    println(vals);
//  }  
  
 // println(vals[0]);
  fill(0, 85, 100, 5); //slightly transparent
  rect(0, 0, width, height);
  
  //draw circles
  for(int i = 0; i < numCircles; i++) {
    rounds[i].drawCircle();
  }  
} 

void setBaseCircles() { //static for now, can be adjusted later
  numCircles = 150;
  rounds = new Round[numCircles];
  for(int i = 0; i < numCircles; i++) {
    rounds[i] = new Round(random(width - 30) + 15, random(height - 30) + 15, 200.0, 179.0); // random position, standard start radius, solid color. Will change to map to sensor later
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
    fill(col, 36, 74, 11); // very transparent, makes color over time
    
    //change from random to noise
    float xDelta = random(40) - 20;
    float yDelta = random(40) - 20;
    rad = sqrt(pow(xDelta, 2) + pow(yDelta, 2))*6; // radius is distanse of position change
    ellipse(xPos + xDelta, yPos + yDelta, rad, rad);
  }

  void changeCol(int newCol){
    this.col = newCol;
  }  
}  
