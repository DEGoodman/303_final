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
float xincrement = 0.03; 
float yincrement = 0.03; 

// sensors
int pot;
int lightRes;
int temperature;
boolean joystickIsOn = false;

void setup() {
  size(800, 600, P2D);
  //Arduino comm
  println(Arduino.list()); 
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  
  numCircles = getTemp();
  joystickIsOn = false;
  
  //visuals
  minim = new Minim(this);
  in = minim.getLineIn();
  
  
  colorMode(HSB, 360, 100, 100, 500 );
  frameRate(5);
    
  rounds = new Round[0];  
  setBaseCircles(); //create starter circles 
  background(255);
  noStroke();  
}

void draw() {
  // read sensor data
  getArduinoData();
  
  fill(getTemp() + floor(random(10)) + 50, 85, 100, 5); //slightly transparent
  rect(0, 0, width, height);
  
  //draw circles
  for(int i = 0; i < numCircles; i++) {
    if (!joystickIsOn)
      rounds[i].updateDir();
    else
      rounds[i].overloadDir();
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
  temp = int((1023 - arduino.analogRead(2)) / 10) + 5;
  return temp;
}  

void setBaseCircles() { //static for now, can be adjusted later
  numCircles = getTemp();
  rounds = new Round[numCircles];
  for(int i = 0; i < numCircles; i++) {
    //rounds[i] = new Round(random(width - 30) + 15, random(height - 30) + 15, 200.0, 179.0);
    rounds[i]  = new Round(random(width - 30) + 15, random(height - 30) + 15, floor(random(3)) - 1, floor(random(3)) - 1, 200, arduino.analogRead(2), 255);  
}  
}  

class Round {
  float xPos;
  float yPos;
  float dirX;
  float dirY;
  float dia;
  int col;
  int alph;
  
  Round(float xPos, float yPos, float dirX, float dirY, float dia, int col, float alph) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.dirX = dirX;
    this.dirY = dirY;
    this.dia = dia;
    this.col = col;
    this.alph = int(alph);
  }

  void drawCircle() {
    col += floor(random(80)) - 40;
    fill(col, 36, 74, 255); // very transparent, makes color over time
    //alpha(alph);
    
    //change from random to noise
   // float xDelta = random(40) - 20;
  //  float yDelta = random(40) - 20;
    //dirX = sqrt(pow(dirX, 2))*6;
    //dirY = sqrt(pow(dirY, 2))*6; // radius is distanse of position change
    
    dia = pow((in.mix.level() + 1)*2,6);
    ellipse(xPos, yPos, dia, dia);
  }

  void changeCol(int newCol){
    this.col = newCol;
  } 
 
  void updateDir() { // use perlin noise to "naturally randomize" direction
    float n = noise(dirX)*width;
    float m = noise(dirY)*height;
    dirX += xincrement;
    dirY += yincrement;

    this.xPos = n;
    this.yPos = m;
  }

  void overloadDir(){ // joystick override of circle direction
  
  }  
}  
