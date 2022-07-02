//Question 3.1.1: your code here:
int a = 5;
float b = 5.0;
/////////////////////////////////
//Question 3.1.2: your code here:
int arraySize = 8;
float[] myFloatArray = new float[arraySize];
/////////////////////////////////
//Question 3.1.3: your code here:
int lado1 = 15;
int lado2 = 20;
float posX = 150-lado1/2;
float posY = 150-lado2/2;

size(300,300);
colorMode(RGB, 1.0);
stroke(0.0);
rect(posX,posY,lado1,lado2);

/////////////////////////////////
int diametro1 = 2*10;
int diametro2 = 2*25;
float posX1 = 170;
float posY1 = 150;

  size(300,300);
  colorMode(RGB, 1.0);
  stroke(0.0);
  ellipse(posX1,posY1,diametro1,diametro2);
/////////////////////////////////

int x1 = 120;
int y1 = 170;
int x2 = 140;
int y2 = 142;
int x3 = 100;
int y3 = 142;

triangle(x1,y1,x2,y2,x3,y3);
