#include <Keypad.h>

const byte ROWS = 4; 
const byte COLS = 3; 
int i = 0,count = 0,help=0;
bool op[2] = {};
bool A[4] = {};
bool B[4] = {};
char hexaKeys[ROWS][COLS] = {
  {'1', '2', '3'},
  {'4', '5', '6'},
  {'7', '8', '9'},
  {'*', '0', '#'}
};

byte rowPins[ROWS] = {4, 2 , 0 , 7}; 
byte colPins[COLS] = {3, 5, 6}; 

Keypad customKeypad = Keypad(makeKeymap(hexaKeys), rowPins, colPins, ROWS, COLS); 

void setup(){
  Serial.begin(9600);
  pinMode(A0, OUTPUT);
  pinMode(A1, OUTPUT);
  pinMode(A2, OUTPUT);
  pinMode(A3, OUTPUT);
  pinMode(A4, OUTPUT);
  pinMode(A5, OUTPUT);
}
  
void loop(){
  char customKey = customKeypad.getKey();
  if (customKey){
    if (count<=1) {
      i *= 10;
      i += customKey - '0';
    }
    else if (count==2) {
      for (int j=0;j<4;j++) {
        A[j] = i%2;
        i /= 2;
      }
      i = 0;
      if (customKey == '*'){
        op[0] = 0;
        op[1] = 0;
      }
      else {
        op[0] = 1;
        op[1] = 0;
      }
    }
    else if (count==3) {
      if (customKey == '*'){
        op[0] = 0;
        op[1] = 1;
      }
      else if (customKey == '#') {
        op[0] = 1;
        op[1] = 1;
      }
      else {
        i *= 10;
        i += customKey - '0';
        help++;
      }
    }
    else {
      i *= 10;
      i += customKey - '0';
      help++;
      if (help == 2) {
        for (int j=0;j<4;j++) {
          B[j] = i%2;
          i /= 2;
        }
        i = 0;
        help = 0;
        count = -1;
        digitalWrite(8,A[0]);
        Serial.print(A[0]);
        digitalWrite(9,A[1]);
        Serial.print(A[1]);
        digitalWrite(10,A[2]);
        Serial.print(A[2]);
        digitalWrite(11,A[3]);
        Serial.print(A[3]);
        analogWrite(A4,1023*op[0]);
        Serial.print(op[0]);
        analogWrite(A5,1023*op[1]);
        Serial.println(op[1]);
        analogWrite(A0,1023*B[3]);
        analogWrite(A1,1023*B[2]);
        analogWrite(A2,1023*B[1]);
        analogWrite(A3,1023*B[0]);
      }
    }
    count++;
  }
}
