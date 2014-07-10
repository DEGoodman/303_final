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
//float xincrement = 0.0007; 
//float yincrement = 0.0007;
float xincrement = 0.001; 
float yincrement = 0.001;

// sensors
int pot;
int lightRes;
int temperature;
int seed = 0;
int counter = 0;

void setup() {
  size(800, 600, P2D);
  //Arduino comm
  println(Arduino.list()); 
  arduino = new Arduino(this, Arduino.list()[2], 57600);

  numCircles = getTemp();

  //visuals
  minim = new Minim(this);
  in = minim.getLineIn();
  //in.enableMonitoring();

  colorMode(HSB, 360, 100, 100, 100 );
  //frameRate(10);

  rounds = new Round[0];  
  noStroke(); 
  smooth();
  setBaseCircles(); //create starter circles 
  
  int hue = int(map(getTemp(), 0, 100, 250, 0));
  background(hue, 40, 12);
}

void draw() {
  // read sensor data
  getArduinoData();
  float potVals = map(getPot(), 0, 1023, -1, 1);
  println("potVals: " + potVals);

  //fill(getTemp() + floor(random(10)) + 50, 85, 100, 5); //slightly transparent
  //rect(0, 0, width, height);

  //xincrement = in.mix.level()/4 + 0.0003;//; + potVals*10000;
  //yincrement = in.mix.level()/4 + 0.0003;// + potVals*10000;

  for (int i = 0; i < numCircles; i++) { 
    //draw circles
    rounds[i].updateDir();
    rounds[i].drawCircle();
    //drawlines
    counter++;
    //if (counter%2==0) {
      for (int j = 0; j < numCircles; j+=7) {
        counter++;
        //if (counter%3==0) {
          int newCol = int((rounds[i].col + rounds[j].col)/2);
          stroke(newCol, 20, 97, 2);
          line(rounds[i].xPos, rounds[i].yPos, rounds[j].xPos, rounds[j].yPos );
        //}
      }
    //}
  }

  //draw connector lines
}

void getArduinoData() {
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

int getTemp() {
  if(arduino.analogRead(2) < 500)
    temp = int(map(arduino.analogRead(2), 0, 500, 0, 100));
  else
    temp = int(map(arduino.analogRead(2), 0, 1023, 0, 100));
  return temp;

}  

void setBaseCircles() { //static for now, can be adjusted later
  //numCircles = getTemp();
  numCircles = 5;
  rounds = new Round[numCircles];
  for (int i = 0; i < numCircles; i++) {
    seed++;
    randomSeed(seed);
    //rounds[i]  = new Round(random(width - 30) + 15, random(height - 30) + 15, floor(random(3)) - 1, floor(random(3)) - 1, 200, arduino.analogRead(2), 255);  
    //rounds[i] = new Round(random(width), random(height), 5- floor(random(10)) , 5- floor(random(10)), 1, 100, 500);
    rounds[i] = new Round(random(seed, width-seed), random(seed, height-seed), 5- floor(random(10)), 5- floor(random(10)), 1, floor(random(360)), 500);
  }
} 

// save image and reset
void keyReleased() {
  if ( key == 's' || key == 'S' ) {
    //saveFrame("lines-######.png");
    seed++;
    randomSeed(seed);
    setBaseCircles();
    
    int hue = int(map(getTemp(), 0, 100, 250, 0));
    background(hue, 40, 12);
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
    noStroke();
    col += 1 - floor(random(3));
    col = (col + 360) % 360;
    fill(col, getLight()/12, (1023 - getLight())/12, 3); // very transparent, makes color over time
    //alpha(alph);


    /* I can normalize the 'gain' (here, the power) by making an array and reading in the levels, and take average.
     * can update the array (array[i] = array[i+1], array[last] = new level), then average results
     * scale accordingly to get reasonable 'power'
     */
    dia = pow((in.mix.level() + 1.01), 20);
    if (dia > 20) { //control for large values to avoid washing out entire screen
      fill(col, 40, 70, 1);
    }
    if ( dia > 200)
      dia = 200;
    ellipse(xPos, yPos, dia, dia);
  }

  void changeCol(int newCol) {
    this.col = newCol;
  }

  void setX(float x) {
    this.xPos = x;
  }  
  void setY(float y) {
    this.yPos = y;
  }  

  void updateDir() { // use perlin noise to "naturally randomize" direction
    float n = noise(dirX, dirY)*width;
    float m = noise(dirY, dirX)*height;
    dirX += xincrement;
    dirY += yincrement;

    this.xPos = n;
    this.yPos = m;
  }

  void overloadDir() { // mouseClicked override of circle direction
  }
}  

