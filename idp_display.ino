#include <LiquidCrystal.h>

LiquidCrystal lcd(7, 6, 5, 4, 3, 2);
int answer = 0;
bool temp = 0,clk = 0,sign = 0; 

void setup(){
  Serial.begin(9600);
  lcd.begin(16,2);
  pinMode(8,INPUT);
  pinMode(9,INPUT);
  pinMode(10,INPUT);
  pinMode(11,INPUT);
  pinMode(12,INPUT);
  pinMode(13,INPUT);
  pinMode(0,INPUT);
  pinMode(A0,INPUT);
  pinMode(A2,INPUT);
  pinMode(A1,OUTPUT);
}
  
void loop(){
    clk = not clk;
    analogWrite(A1,1023*clk);
    answer = digitalRead(0);
    temp = 0;
    if (analogRead(A0) > 500)
      temp = 1;
    int j = 2;
    for (int i=8;i<=13;i++) {
      answer += j*digitalRead(i);
      Serial.print(digitalRead(i));
      j *= 2;
    }
    if (analogRead(A2)>500)
      sign = 1;
    else
      sign = 0;
    answer += j*temp;
    lcd.clear();
    lcd.setCursor(0,0);
    if (sign==1 and answer==0)
      lcd.print("Error!");
    else {
      if (sign==1)
        lcd.print("-");
      lcd.print(answer);
    }
    delay(500);
}
