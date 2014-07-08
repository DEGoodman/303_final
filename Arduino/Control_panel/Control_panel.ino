// gather sensor data, sends to Processing

int allVals[2];

// sensors
int pot; //0-1023
int light;


void setup() {
  // contact port
  Serial.begin(9600);
  //pinMode(buttonLoc, INPUT);
}

void loop() {
  //potentiometer
  pot = analogRead(A0);
  //allVals[0] = pot;

  //photoresistor
  light = analogRead(A1);
  // make contact
  //Serial.println(pot);
  delay(10);
  Serial.println(light);
  delay(100);
}  
