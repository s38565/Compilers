void setup() {
  pinMode(13, OUTPUT);
}

void loop() {
  int a = 3000;
  int b = 3000;

  b = a  + b * 3;

  digitalWrite(13, HIGH);
  delay(a);
  digitalWrite(13, LOW);
  delay(b);
}
