#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;


int sensorPin = A0;    // select the input pin for the potentiometer
int sensorValue = 0;

int maxchart = 50;
int plchart =0;

String content = "";
char character;

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  Serial.println("START_SER!");
 
  SerialBT.begin("ESP32_bt"); //Bluetooth device name

  
  delay(50);
  SerialBT.println("SET INTESTAZIONE ANALOG_DEMO"); 
  SerialBT.println("DESTROY ALL!");
  SerialBT.println("SET SCREEN PORTRAIT");
  SerialBT.println("CREATE LABEL LB1 50 50 VALORE_POT_1");  
  SerialBT.println("CREATE GAUGE GX1 50 70 200 200 YELLOW RED 10");

  SerialBT.println("CREATE CHART CH1 50 350 200 200 0 300");
  SerialBT.println("CREATE BARSERIES LCH1 CH1 RED 10");

  
}

void loop() { // run over and over
  if (SerialBT.available()) {
   
    character=SerialBT.read();
    Serial.write(character);
    if (character != 13){content.concat(character);} 
    if (character == 13)  {
       if (content == "!START") 
           {
           Serial.println(content);
           Serial.println("Reinviato Grafica!");

           SerialBT.println("SET INTESTAZIONE ANALOG_DEMO"); 
           SerialBT.println("DESTROY ALL!");
           SerialBT.println("SET SCREEN PORTRAIT");
           SerialBT.println("CREATE LABEL LB1 50 50 VALORE_POT_1");  
           SerialBT.println("CREATE GAUGE GX1 50 70 200 200 GREEN WHITE 10");
           
           SerialBT.println("CREATE CHART CH1 50 350 200 200 0 300");
           SerialBT.println("CREATE BARSERIES LCH1 CH1 RED 10");

           
           }
      content = "";     
    }
    
  }
  if (Serial.available()) {
    SerialBT.write(Serial.read());
  }

sensorValue = analogRead(sensorPin);  
SerialBT.print("SET GX1 VALUE ");
int y = map(sensorValue, 1, 1024, 1, 290);
SerialBT.println(y);

delay(20);

SerialBT.print("SET LCH1 ADD ");
SerialBT.println(y);


delay(50);
  
}
