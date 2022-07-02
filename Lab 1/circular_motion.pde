////////////////////////////////////////////////////////////////////////////
//State Initial Variables
//Question 3.2.1: your code here:
float BallInitTheta = radians(0.0);
float AngularVel = radians(0.0);
float CurrentTime = 0;
////////////////////////////////////////////////////////////////////////////
//Question 3.2.2: your code here:
int arraySize = 3;
float[] StateDef = new float [arraySize];
////////////////////////////////////////////////////////////////////////////
//State definition
//Window set up variables
int WindowWidthHeight = 300;
float WorldSize = 5.0;
float PixelsPerMeter = (WindowWidthHeight ) / WorldSize;
float OriginPixelsX = 0.5 * WindowWidthHeight;
float OriginPixelsY = 0.5 * WindowWidthHeight;
////////////////////////////////////////////////////////////////////////////
//Global constants
float g = 9.8;// gravity = 9.8 m/s^2

//Question 3.3
float radius = 1.5;
float deltaT = 1.0/60.0; // Frame rate of 60 fps
////////////////////////////////////////////////////////////////////////////
void setup()
{
    /////////////////////////////////////////////////////////////////////////
    //Create initial state.
    //Question 3.2.3: Your code here
    StateDef[0]=BallInitTheta;
    StateDef[1]=AngularVel;
    StateDef[2]=CurrentTime;
    /////////////////////////////////////////////////////////////////////////
    // Set up normalized colors.
    colorMode( RGB, 1.0 );
    // Set up the stroke color and width.
    stroke( 0.0 );
    // Create the window size, set up the transformation variables.
    size( 300, 300 );
    PixelsPerMeter = (( float )WindowWidthHeight ) / WorldSize;
    OriginPixelsX = 0.5 * ( float )WindowWidthHeight;
    OriginPixelsY = 0.5 * ( float )WindowWidthHeight;
    // Translate to the origin.
    translate( OriginPixelsX, OriginPixelsY );
    // Set frame rate
    frameRate( 1.0/deltaT );
}  
    
void timeStep(float delta_t)
{
    /////////////////////////////////////////////////////////////////////////
    //Question 3.2.4 Your code here:
    float acc = ((-g*cos(BallInitTheta))/(radius));
    StateDef[2] += deltaT;
    BallInitTheta = (BallInitTheta)+(delta_t)*(AngularVel);
    AngularVel = (AngularVel)+(delta_t)*(acc);
    /////////////////////////////////////////////////////////////////////////
}
// The DrawState function assumes that the coordinate space is that of the
// simulation - namely, meters, with the circle center placed at the origin.
// There is currently a bug in processing.js which requires us to do the
// pixels-per-meter scaling ourselves.
void DrawState()
{
    // Compute ball position
    //Question 3.2.5 Your code here:
    float BallX =   PixelsPerMeter * cos(BallInitTheta)*radius ; //Replace the "0" with the corresponding value
    float BallY =  -PixelsPerMeter * sin(BallInitTheta)*radius ; //Replace the "0" with the corresponding value
    /////////////////////////////////////////////////////////////////////////
                 
    // Draw ball
    float diameter = PixelsPerMeter * 0.3;
    fill( 1.0, 0.0, 0.0 );
    ellipse( BallX, BallY, diameter, diameter );

    // Draw circle
    fill( 0 , 0 );
    ellipse( 0, 0, 2 * radius * PixelsPerMeter, 2 * radius * PixelsPerMeter );
}


// The draw function creates a transformation matrix between pixel space
// and simulation space, in meters, and then calls the DrawState function.
// Unfortunately, there is currently a bug in processing.js with concatenated
// transformation matrices, so we have to do the coordinate scaling ourselves
// in the draw function.
void draw()
{
    //Time Step
    timeStep(deltaT);
  
    //Clear the display to a constant color
    background( 0.75 );

    // Translate to the origin.
    translate( OriginPixelsX, OriginPixelsY );
    
    // Draw the simulation
    DrawState();     
}   
