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
float xincrement = 0.0007; 
float yincrement = 0.0007;


// sensors
int pot;
int lightRes;
int temperature;
int seed = 0;
int counter = 0;
int hue;

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
  
  hue = int(map(getTemp(), 0, 100, 350, 10));
  hue += (1 - floor(random(3)))*120;
  hue = (hue + 360) % 360;
  background(hue, 40, 12);
}

void draw() {
  // read sensor data
  getArduinoData();
  int gain = getGainLevel();
  println("gain: " + gain);
  float potVals = map(getPot(), 0, 1023, -1, 1);
  println("potVals: " + potVals);
 
  xincrement = in.mix.level()/10 - 0.0004 + potVals/120;
  yincrement = in.mix.level()/10 - 0.0004 + potVals/120;

  for (int i = 0; i < numCircles; i++) { 
    //draw circles
    rounds[i].updateDir();
    rounds[i].drawCircle(gain); // use getGainValue info here
    //drawlines
    //counter++;
    //if (counter%5==0) {
      for (int j = 0; j < numCircles; j+=7) {
        counter++;
        if (counter%2==0) {
          int newCol = int((rounds[i].col + rounds[j].col)/2);
          stroke(newCol, 14, 99, 5);
          line(rounds[i].xPos, rounds[i].yPos, rounds[j].xPos, rounds[j].yPos );
        }
      }
    //}
  }

  //draw connector lines
}

void getArduinoData() {
  pot = getPot();
  lightRes = getLight();
  temperature = getTemp();

  println("pot: " + pot + ", " + "lightRes: " + lightRes + ", " + "temperature: "  + temperature);
} 

int getGainLevel() {
  /* I can normalize the 'gain' (here, the power) by making an array and reading in the levels, and take average.
     * can update the array (array[i] = array[i+1], array[last] = new level), then average results
     * scale accordingly to get reasonable 'power'
     */


 float maxVolume = in.mix.level();
    
  // scale maxVolume for MAX GAINZ!!!!  0.02-0.14
  if (maxVolume <= 0.02)
    return 65;
  else if (maxVolume <= 0.05)
    return 50;
  else if (maxVolume <= 0.10)
    return 35;  
  else if (maxVolume <= 0.20)
    return 25;
  else
    return 18;
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
  numCircles = 6;
  rounds = new Round[numCircles];
  for (int i = 0; i < numCircles; i++) {
    seed++;
    randomSeed(seed);
    //rounds[i]  = new Round(random(width - 30) + 15, random(height - 30) + 15, floor(random(3)) - 1, floor(random(3)) - 1, 200, arduino.analogRead(2), 255);  
    rounds[i] = new Round(random(seed, width-seed), random(seed, height-seed), 5- floor(random(10)), 5- floor(random(10)), 1, hue, 500);
  }
} 

// save image and reset
void keyReleased() {
  if ( key == 's' || key == 'S' ) {
    saveFrame("lines-######.png");
    seed++;
    randomSeed(seed);
    setBaseCircles();
    
    hue = int(map(getTemp(), 0, 100, 350, 10));
    hue += (1 - floor(random(3)))*60;
    hue = (hue + 360) % 360;
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

  void drawCircle(int gain) {
    int bright = int(getLight()/10);
    //int sat = int(map(in.mix.level(), 0, 0.15, 0, 100));
    noStroke();
    if (counter%1333 == 0) {
      col += (1 - floor(random(3)))*120;
      col = (col + 360) % 360;
    }
    fill(col, 100 - bright, 130 - bright, 3);
    
    dia = pow((in.mix.level() + 1.012), gain);
    if (dia > 20) { //control for large values to avoid washing out entire screen
      fill(col, 100 - bright, 120 - bright, 2);
    }
    if ( dia > 200) {
      dia = 200;
      fill(col, 40, 70, 1);
    }
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

