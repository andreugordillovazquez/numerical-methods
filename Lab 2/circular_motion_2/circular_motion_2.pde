////////////////////////////////////////////////////////////////////////////
//State Initial Variables
//Question 2.1.1: your code here:
float BallInitTheta = radians(0.0); //Inicialitzem l'angle
float BallInitVel = radians(0.0); //Inicialitzem la velocitat angular
////////////////////////////////////////////////////////////////////////////
//Question 2.1.2: your code here:
float CurrentTime = 0.0; //Inicialitzem el temps actual
// EC
int StateECSize = 3; //Declarem la mida de l'array StateEC
float[] StateEC = new float[StateECSize]; //Creem l'array amb la mida declarada
// RK2
int StateRK2Size = 3; //Declarem la mida de l'array StateRK2
float[] StateRK2 = new float[StateRK2Size]; //Creem l'array amb la mida declarada
// RK4
int StateRK4Size = 3; //Declarem la mida de l'array StateRK4
float[] StateRK4 = new float[StateRK4Size]; //Creem l'array amb la mida declarada
////////////////////////////////////////////////////////////////////////////
//Window set up variables
int WindowWidthHeight = 300;
float WorldSize = 5.0;
float PixelsPerMeter = (WindowWidthHeight ) / WorldSize;
float OriginPixelsX = 0.5 * WindowWidthHeight;
float OriginPixelsY = 0.5 * WindowWidthHeight;
////////////////////////////////////////////////////////////////////////////
//Global constants
float g = 9.8;// gravity = 9.8 m/s^2
float radius = 1.5;
float deltaT = 1.0/60.0; // Frame rate of 60 fps
///////////////////////////////////////////////////////////////////////////
void setup()
{
    /////////////////////////////////////////////////////////////////////////
    //Create initial state.
    //Question 2.1.3: Your code here
    // EC
    StateEC[0]=BallInitTheta; //Col·loquem l'angle inicial en primera posició de l'array
    StateEC[1]=BallInitVel; //Col·loquem la velocitat angular inicial en segona posició de l'array
    StateEC[2]=CurrentTime; //Col·loquem el temps en tercera posició de l'array
    // RK2
    StateRK2[0]=BallInitTheta; //Col·loquem l'angle inicial en primera posició de l'array
    StateRK2[1]=BallInitVel; //Col·loquem la velocitat angular inicial en segona posició de l'array
    StateRK2[2]=CurrentTime; //Col·loquem el temps en tercera posició de l'array
    // RK4
    StateRK4[0]=BallInitTheta; //Col·loquem l'angle inicial en primera posició de l'array
    StateRK4[1]=BallInitVel; //Col·loquem la velocitat angular inicial en segona posició de l'array
    StateRK4[2]=CurrentTime; //Col·loquem el temps en tercera posició de l'array
    /////////////////////////////////////////////////////////////////////////
   
    // Set up normalized colors.
    colorMode( RGB, 1.0 );
    
    // Set up the stroke color and width.
    stroke( 0.0 );
    
    // Create the window size, set up the transformation variables.
    size( 300, 700 );
    PixelsPerMeter = (( float )WindowWidthHeight ) / WorldSize;
    OriginPixelsX = 0.5 * ( float )WindowWidthHeight;
    OriginPixelsY = 0.5 * ( float )WindowWidthHeight;

    // Translate to the origin.
    translate( OriginPixelsX, OriginPixelsY );
    
    // Set frame rate
    frameRate( 1.0/deltaT );

}  
    
void timeStepEC( float delta_t )
{
    /////////////////////////////////////////////////////////////////////////
    //EULER-CROMER METHOD. Question 2.1.4
    float A = (-g/radius)*cos(StateEC[0]); //Calculem l'acceleració
    
    StateEC[1]+=delta_t*A;  //Calculem W actual
    StateEC[0]+=delta_t*StateEC[1]; //Calculem l'angle
    StateEC[2]+=delta_t; //Computem el temps actual
    /////////////////////////////////////////////////////////////////////////
}

void timeStepRK2( float delta_t )
{
  /////////////////////////////////////////////////////////////////////////
  // RK2 METHOD. Question 2.1.4 
  //Trobem F(1,x), F(1,v), F(2,x) i F(2,v)
  float F1_x=StateRK2[1];
  float x_k1=StateRK2[0]+(delta_t*F1_x);
  float F1_v=-(g/radius)*cos(StateRK2[0]);
  float F2_v=-(g/radius)*cos(x_k1);
  float v_k1=StateRK2[1] + (delta_t*F1_v);
  
  //Un cop obtinguts els valors anteiors, calculem x(k+1) i v(k+1)
  StateRK2[0]+=(delta_t/2.0)*(F1_x+v_k1); //Calculem l'angle
  StateRK2[1]+=(delta_t/2.0)*(F1_v+F2_v);  //Calculem W actual
  StateRK2[2]+=delta_t; //Computem el temps actual
  /////////////////////////////////////////////////////////////////////////
}

void timeStepRK4( float delta_t )
{
  /////////////////////////////////////////////////////////////////////////
  // RK4 METHOD. Question 2.1.4  
  //Calculem cada una de les funcions per després substituir a la fórmula de Runge-Kutta 4
  // F1,x i F1,v
  float f1_x = StateRK4[1]; 
  float f1_v = (-g*cos(StateRK4[0]))/(radius);
  //F2,x i F2,v
  float f2_x = StateRK4[1] + ((delta_t / 2.0)*(f1_v));
  float f2_v = -g*cos(StateRK4[0]+(delta_t / 2.0)*(f1_x))/(radius);
  //F3,x i F3,v
  float f3_x = StateRK4[1] + ((delta_t / 2.0)*(f2_v));
  float f3_v = -g*cos(StateRK4[0]+(delta_t / 2.0)*(f2_x))/(radius);
  //F4,x i F4,v
  float f4_x = StateRK4[1] + (delta_t*(f3_v));
  float f4_v = -g*cos(StateRK4[0]+delta_t*(f3_x))/(radius);
  
  //Un cop obtinguts els valors anteiors, calculem x(k+1) i v(k+1)
  StateRK4[0] = StateRK4[0] + (delta_t/6)*((f1_x) + (2*f2_x) + (2*f3_x) + (f4_x)); //Calculem l'angle
  StateRK4[1] = StateRK4[1] + (delta_t/6)*(f1_v + 2*f2_v + 2*f3_v + f4_v);  //Calculem W actual
  StateRK4[2] = StateRK4[2] + delta_t;  //Computem el temps actual
  /////////////////////////////////////////////////////////////////////////
}

// The DrawState function assumes that the coordinate space is that of the
// simulation - namely, meters, with the circle center placed at the origin.
// There is currently a bug in processing.js which requires us to do the
// pixels-per-meter scaling ourselves.
void DrawState()
{
    // Compute ball position
    /////////////////////////////////////////////////////////////////////////
    //Question 2.1.5 Your code here:
    // Euler-Cromer
    float BallX_EC =  PixelsPerMeter * cos( StateEC[0] ) * radius; //Canviem el 0 per StateEC[0] per actualitzar l'angle
    float BallY_EC =  -PixelsPerMeter * sin( StateEC[0] ) * radius; //Canviem el 0 per StateEC[0] per actualitzar l'angle
    // RK2
    float BallX_RK2 =  PixelsPerMeter * cos( StateRK2[0] ) * radius; //Canviem el 0 per StateEC[0] per actualitzar l'angle
    float BallY_RK2 =  -PixelsPerMeter * sin( StateRK2[0] ) * radius; //Canviem el 0 per StateEC[0] per actualitzar l'angle
    // RK4
    float BallX_RK4 =  PixelsPerMeter * cos( StateRK4[0] ) * radius; //Canviem el 0 per StateEC[0] per actualitzar l'angle
    float BallY_RK4 =  -PixelsPerMeter * sin( StateRK4[0] ) * radius; //Canviem el 0 per StateEC[0] per actualitzar l'angle
    
    /////////////////////////////////////////////////////////////////////////
           
    // Draw ball, circles and text
    float ballDiameter = PixelsPerMeter * 0.3;
    // Draw ball EC
    translate( OriginPixelsX, OriginPixelsY );
    fill( 1.0, 0.0, 0.0 ); // Red
    ellipse( BallX_EC, BallY_EC, ballDiameter, ballDiameter );
    // Draw circle
    fill( 0 , 0 );
    ellipse( 0, 0, 2 * radius * PixelsPerMeter, 2 * radius * PixelsPerMeter );
    textSize( 18 );
    fill(0);
    text( "Euler-Cromer", -56, 5 );
    
    // Draw ball RK2 
    translate( 0, 210 );
    fill( 0.0, 1.0, 0.0 ); // Green
    ellipse( BallX_RK2, BallY_RK2, ballDiameter, ballDiameter );
    // Draw circle
    fill( 0 , 0 );
    ellipse( 0, 0, 2 * radius * PixelsPerMeter, 2 * radius * PixelsPerMeter );
    fill(0);
    text( "RK-2", -20, 5 );

    // Draw ball RK4
    translate( 0, 210 );
    fill( 0.0, 0.0, 1.0 ); // Blue
    ellipse( BallX_RK4, BallY_RK4, ballDiameter, ballDiameter );
    // Draw circle
    fill( 0 , 0 );
    ellipse( 0, 0, 2 * radius * PixelsPerMeter, 2 * radius * PixelsPerMeter );
    fill(0);
    text( "RK-4", -20, 5 );
}


// The draw function creates a transformation matrix between pixel space
// and simulation space, in meters, and then calls the DrawState function.
// Unfortunately, there is currently a bug in processing.js with concatenated
// transformation matrices, so we have to do the coordinate scaling ourselves
// in the draw function.
void draw()
{
    //Time Step
    timeStepEC(deltaT);
    timeStepRK2(deltaT);
    timeStepRK4(deltaT);

    //Clear the display to a constant color
    background( 0.75 );
    
    // Draw the simulation
    DrawState();     
}   
