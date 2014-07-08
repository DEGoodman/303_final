// gather sensor data, sends to Processing

int allVals[2];

// sensors
int pot; //0-1023
int buttonLoc = 2;
int button; // 0-1


void setup() {
  // contact port
  Serial.begin(9600);
  pinMode(buttonLoc, INPUT);
}

void loop() {
  pot = analogRead(A0);
  // map pot values to Processing values
  //pot = map(pot, 0, 1023, 0, 255);
  //allVals[0] = pot;
  
//  button = digitalRead(buttonLoc);
//  allVals[1] = button;
  // make contact
  Serial.write(pot);
  //Serial.write(allVals[1]);
  delay(100);
}  
