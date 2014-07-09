// creates visual design. Reads and interprets data from Arduino
import org.firmata.*;
import cc.arduino.*;
import processing.serial.*;
import ddf.minim.*;

Arduino arduino;
int vals; // will have to parse values
int temp; // temporary value location, to save memory
Minim minim;
AudioInput in;

int numCircles;
Round[] rounds;

// sensors
int pot;
int lightRes;
int temperature;

void setup() {
  size(800, 600, P2D);
  //Arduino comm
  println(Arduino.list()); 
  arduino = new Arduino(this, Arduino.list()[1], 57600);
 // myPort.bufferUntil('\n');
  
  // array of values from arduino
  //vals;
  
  
  //visuals
  minim = new Minim(this);
  in = minim.getLineIn();
  
  
  colorMode(HSB, 360, 100, 100, 500 );
  //frameRate(5);
    
  rounds = new Round[0];  
  setBaseCircles(); //create starter circles 
  background(255);
  noStroke();  
}

void draw() {
  // read sensor data
  getArduinoData();
  
 
  
  fill(0, 85, 100, 5); //slightly transparent
  rect(0, 0, width, height);
  
  //draw circles
  for(int i = 0; i < numCircles; i++) {
    rounds[i].drawCircle();
  }  
}

void getArduinoData(){
  pot = getPot();
  lightRes = getLight();
  temperature = getTemp();
  
  println(pot + ", " + lightRes + ", " + temperature);
} 

int getPot() {
  temp = arduino.analogRead(0);
  // calculations
  return temp;
}  

int getLight() {
  temp = arduino.analogRead(1);
  return temp;
}  

int getTemp(){
  temp = arduino.analogRead(2);
  return temp;
}  

void setBaseCircles() { //static for now, can be adjusted later
  numCircles = 150;
  rounds = new Round[numCircles];
  for(int i = 0; i < numCircles; i++) {
    //rounds[i] = new Round(random(width - 30) + 15, random(height - 30) + 15, 200.0, 179.0); // random position, standard start radius, solid color. Will change to map to sensor later
    rounds[i]  = new Round(random(width - 30) + 15, random(height - 30) + 15, random(width - 60) + 30, random(height - 60) + 30, in.mix.level()*100, getTemp(), getPot());  
}  
}  

class Round {
  float xPos;
  float yPos;
  float dirX;
  float dirY;
  float dia;
  float col;
  float alph;
  
  Round(float xPos, float yPos, float dirX, float dirY, float dia, float col, float alph) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.dirX = dirX;
    this.dirY = dirY;
    this.dia = dia;
    this.col = col;
    this.alph = alph;
  }

  void drawCircle() {
    fill(col, 36, 74, 11); // very transparent, makes color over time
    alpha(alph);
    
    //change from random to noise
   // float xDelta = random(40) - 20;
  //  float yDelta = random(40) - 20;
    dirX = sqrt(pow(dirX, 2))*6;
    dirY = sqrt(pow(dirY, 2))*6; // radius is distanse of position change
    ellipse(xPos + dirX, yPos + dirY, dia, dia);
  }

  void changeCol(int newCol){
    this.col = newCol;
  }  
}  
