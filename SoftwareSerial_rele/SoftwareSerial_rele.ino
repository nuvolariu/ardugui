/*
  Software serial multple serial test
 */

//#include <SoftwareSerial.h>
-#include <AltSoftSerial.h>

String content = "";
char character;

int RL1=3;
int RL2=4;
int RL3=5;
int RL4=6;

int st1=HIGH;
int st2=HIGH;
int st3=HIGH;
int st4=HIGH;

//SoftwareSerial mySerial(10,11); // RX, TX
AltSoftSerial mySerial; //8 9 
void setup() {

  pinMode(RL1, OUTPUT);
  pinMode(RL2, OUTPUT);
  pinMode(RL3, OUTPUT);
  pinMode(RL4, OUTPUT);
  digitalWrite(RL1, st1);
  digitalWrite(RL2, st2);
  digitalWrite(RL3, st3);
  digitalWrite(RL4, st4);
  
  
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  Serial.println("START_SER!");
  
  mySerial.begin(9600);
  delay(50);
  mySerial.println("SET INTESTAZIONE DIGITAL_DEMO"); 
  mySerial.println("DESTROY ALL!");
  mySerial.println("SET SCREEN LANDSCAPE");
  
  mySerial.println("CREATE BUTTON BT1 50 150 RELE1");
  mySerial.println("CREATE BUTTON BT2 150 150 RELE2");
  mySerial.println("CREATE BUTTON BT3 250 150 RELE3");
  mySerial.println("CREATE BUTTON BT4 350 150 RELE4");

  mySerial.println("CREATE LED LD1 50 50 50 50 YELLOW BROWN");
  mySerial.println("CREATE LED LD2 150 50 50 50 YELLOW BROWN");
  mySerial.println("CREATE LED LD3 250 50 50 50 YELLOW BROWN");
  mySerial.println("CREATE LED LD4 350 50 50 50 YELLOW BROWN");
    

}



void loop() { // run over and over
  
  digitalWrite(RL1, st1);
  digitalWrite(RL2, st2);
  digitalWrite(RL3, st3);
  digitalWrite(RL4, st4);
  
  if (mySerial.available()) {
    character=mySerial.read();
    Serial.write(character);
    if (character != 13){content.concat(character);} 
    if (character == 13)  {
       Serial.println(" LF Detected");
       if (content == "!START") 
           {        
           mySerial.println("SET INTESTAZIONE DIGITAL_DEMO"); 
           mySerial.println("DESTROY ALL!");
           mySerial.println("SET SCREEN LANDSCAPE");
  
           mySerial.println("CREATE LED LD1 50 50 50 50 YELLOW BROWN");  
           mySerial.println("CREATE LED LD2 150 50 50 50 YELLOW BROWN");
           mySerial.println("CREATE LED LD3 250 50 50 50 YELLOW BROWN");
           mySerial.println("CREATE LED LD4 350 50 50 50 YELLOW BROWN");
  
           mySerial.println("CREATE BUTTON BT1 50 150 RELE1");
           mySerial.println("CREATE BUTTON BT2 150 150 RELE2");
           mySerial.println("CREATE BUTTON BT3 250 150 RELE3");
           mySerial.println("CREATE BUTTON BT4 350 150 RELE4");
           
           }
       if (content == "BT1") 
           {        
           Serial.println("!BT1"); 
           if (st1 == LOW) {st1 = HIGH; }
                else {st1 = LOW;} 
           }
       if (content == "BT2") 
           {        
           Serial.println("!BT2"); 
           if (st2 == LOW) {st2 = HIGH;}
                else {st2 = LOW;} 
           }
       if (content == "BT3") 
           {        
           Serial.println("!BT3");
           if (st3 == LOW) {st3 = HIGH;}
                else {st3 = LOW;}  
           }
       if (content == "BT4") 
           {        
           Serial.println("!BT4");
           if (st4 == LOW) {st4 = HIGH;}
                else {st4 = LOW;}  
           }    
     
      content = "";      }        
           
          
    }

delay(10);
mySerial.print("SET LD1 CHECKED ");mySerial.println(st1);
delay(10);
mySerial.print("SET LD2 CHECKED ");mySerial.println(st2);
delay(10);
mySerial.print("SET LD3 CHECKED ");mySerial.println(st3);
delay(10);
mySerial.print("SET LD4 CHECKED ");mySerial.println(st4);
delay(10);

  
}
