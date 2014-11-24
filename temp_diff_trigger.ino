int lightSense_R = A0;    // select the input pin for the potentiometer
int lightSense_L = A1;
int tempSense_R  = A4;
int tempSense_L  = A5;
int lampTrigger  = 13;      // select the pin for the LED
int fanTrigger   = 12;
int lightVal_R   = 0;   // variable to store the value coming from the sensor
int lightVal_L   = 0;
int tempVal_R    = 0;
int tempVal_L    = 0;
int lightdiff    = 0;
int tempdiff     = 0;
int tempDelta    = 3;
int lightDelta   = 75;
float refVoltage = 3.3;   // 3.3 voltage circuits for more accuracy
float conversion = ((refVoltage * 1000.0) / 1024.0) / 100.0;
float tempC_R    = 0.0;
float tempC_L    = 0.0;


void setup() {
  // declare the ledPin as an OUTPUT:
  pinMode(lampTrigger, OUTPUT);  
  pinMode(fanTrigger, OUTPUT); 
  Serial.begin(9600);
}

void loop() {
  // read the value from the sensor:
  lightVal_R = analogRead(lightSense_R);  
  lightVal_L = analogRead(lightSense_L);  
  tempVal_R  = analogRead(tempSense_R);  
  tempVal_L  = analogRead(tempSense_L);  
    
  lightdiff = abs(lightVal_R - lightVal_L);
  tempdiff  = abs(tempVal_R  - tempVal_L );

  Serial.println("SENSOR READINGS");

  // print sensor value to screen
  Serial.print("light sensor 0: ");  
  Serial.println(lightVal_R);  
  Serial.print("light sensor 1: ");  
  Serial.println(lightVal_L); 
  Serial.print("Light Difference: ");
  Serial.println(lightdiff);
  Serial.println("");
  
  // temp calc for a LM36 -- I am using an LM35 - for F
  // percent of reference volage - normalized by the range
  // 10 mv per degree with a 1/2 volt offset
  // calculation for LM36 -- we are using the LM35 (fix calc)
  //tempC_R = ( (tempVal_R * refVoltage)/1024.0 - 0.5 ) * 100.0;
  //tempC_L = ( (tempVal_L * refVoltage)/1024.0 - 0.5 ) * 100.0;
  // LM35 equiation 10 mV = 1 C
  tempC_R = tempVal_R * conversion;
  tempC_L = tempVal_L * conversion;
  
  Serial.print("temp sensor 0: ");  
  Serial.print(tempVal_R);  
  Serial.print(" & ");  
  Serial.print(tempC_R);  
  Serial.println(" C");
  Serial.print("temp sensor 1: ");  
  Serial.print(tempVal_L); 
  Serial.print(" & ");  
  Serial.print(tempC_L);   
  Serial.println(" C");
  Serial.print("Temp Difference: ");
  Serial.println(tempdiff);
  Serial.println("");

  // turn on lapm trigger (if difference too high)
  if (lightdiff > lightDelta) {
    digitalWrite(lampTrigger, HIGH);  // turn on if value is too high
    Serial.println("LAMP ON");
  } else {
    digitalWrite(lampTrigger, LOW);   // tiurn off when value is ok
    Serial.println("LAMP OFF");
  }

  // turn on fan trigger (if difference too high)
  if (tempdiff > tempDelta) {
    digitalWrite(fanTrigger, HIGH);  // turn on if value is too high
    Serial.println("FAN ON");
  } else {
    digitalWrite(fanTrigger, LOW);   // tiurn off when value is ok
    Serial.println("FAN OFF");
 }
  
  Serial.println("");
  Serial.println("==========================");
  Serial.println("");
  

  delay(1000);     // read sensors every 300 miliseconds             
}
