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
  allVals[0] = pot;
  delay(10);
  
  //photoresistor
  light = analogRead(A1);
  allVals[1] = light;
  delay(10);
  
  //Serial.print(pot);
  //Serial.println(light);
  String printer = String(allVals[0]) + "," + String(allVals[1]);
  Serial.println(printer);
  delay(100);
}
