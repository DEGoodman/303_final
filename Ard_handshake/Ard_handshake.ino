// Example 1 - Hello World - Blinking LED

const int LED = 12; // LED connected to digital pin 13
char val;
boolean ledState = LOW;

void setup() {

  pinMode(LED, OUTPUT); // sets digital pin as output
  Serial.begin(9600);
  establishContact();
}

void loop() {
  if (Serial.available() > 0) {
    val = Serial.read();

    if (val == '1') {
      ledState = !ledState;
      digitalWrite(LED, ledState);
    } 
    delay(50);
  } else {
    Serial.println("Hello World!");
    delay(50);
  }
}

void establishContact() {
  while (Serial.available () <= 0) {
    Serial.println("Marco");
    delay(500);
  }
}

