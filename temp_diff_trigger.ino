int tempSensor_R  = A4;
int tempSensor_L  = A5;
int windowControl = 13;
int fanControl    = 12;
int tempValue_R   = 0;
int tempValue_L   = 0;
float tempC_R     = 0.0;
float tempC_L     = 0.0;
float tempDiff    = 0.0;
float tempDelta   = 0.2;
float tempTrigger = 23.0;
float refVoltage  = 3.3;   // 3.3 voltage circuits for more accuracy
float conversion  = ((refVoltage * 1000.0) / 1024.0) / 100.0;

void setup() {
  // declare the ledPin as an OUTPUT:
  pinMode(windowConrol, OUTPUT); 
  pinMode(fanConrol, OUTPUT); 
  Serial.begin(9600);
}

void loop() {
  // read the value from the sensor:
  tempValue_R  = analogRead(tempSensor_R);  
  tempValue_L  = analogRead(tempSensor_L);  

  // LM35 equiation 10 mV = 1 C
  tempC_R = tempValue_R * conversion;
  tempC_L = tempValue_L * conversion;
  tempDiff  = abs(tempC_R - tempC_L )
  
  Serial.print("temp sensor R: ");  
  Serial.print(tempValue_R);  
  Serial.print(" & ");  
  Serial.print(tempC_R);  
  Serial.println(" C");
  Serial.print("temp sensor L: ");  
  Serial.print(tempValue_L); 
  Serial.print(" & ");  
  Serial.print(tempC_L);   
  Serial.println(" C");
  Serial.print("Temp Difference: ");
  Serial.println(tempDiff);
  Serial.println("");

  // control the window (lower the temperature if too hot by opening the window)
  if (tempC_R > tempTrigger) or (tempC_L > tempTrigger)) {
    digitalWrite(windowControl, HIGH)
    Serial.print("WINDOW OPENED - temp is TOO hot")
  } else {
    digitalWrite(windowControl, LOW)
    Serial.print("WINDOW CLOSED - temp is not too hot")
  }

  // turn on fan trigger (if difference too high)
  if (tempdiff > tempDelta) {
    digitalWrite(fanControl, HIGH);  // turn on if value is too high
    Serial.println("FAN ON - equalizing temperature");
  } else {
    digitalWrite(fanControl, LOW);   // tiurn off when value is ok
    Serial.println("FAN OFF - temps are similar enough");
 }
  
  Serial.println("==========================");

  delay(1000);     // read sensors every second (1000 miliseconds)
}
