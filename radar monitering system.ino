#include <ESP32Servo.h>

#define TRIG_PIN 32
#define ECHO_PIN 33
#define SERVO_PIN 14

Servo myServo;  

void setup() {
  Serial.begin(115200);
  myServo.attach(SERVO_PIN);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
}

void loop() {
  for (int angle = 0; angle <= 180; angle += 2) {  
    myServo.write(angle);
    delay(50);  
    int distance = getDistance();
    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.println(".");
  }

  for (int angle = 180; angle >= 0; angle -= 2) {  
    myServo.write(angle);
    delay(50);
    int distance = getDistance();
    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.println(".");
  }
}

int getDistance() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  long duration = pulseIn(ECHO_PIN, HIGH);
  int distance = duration * 0.034 / 2;
  
  return (distance > 100) ? 100 : distance;
}