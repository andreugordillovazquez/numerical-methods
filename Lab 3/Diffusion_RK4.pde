//////////////////////////////////////////////////////
//// Question PW6
float InitialPouring      = 1;
float ConstantAlpha       = 0.25;
float WorldSize           = 10.0;
float DT                  = 1.0/24.0;
float CurrentTime = 0;
//
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
//// Question PW1
//
int ArraySize = 64; //Declarem la longitud de l'array
int StateSize = 1; //Declarem la longitud de l'state
int StateCon = 0; //Declarem la variable StateCon
float DX = WorldSize / ArraySize; // Substitute the 0 with the size of the array
float [][] State = new float[StateSize][ArraySize]; //Creem l'array matricial de 1x64
//
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
// Visualization Parameters
// Amount of pixels per cell on the X axis 
int PixelsPerCell       = 6;

// Dimensions of the visualization window 
int WindowWidth;
int WindowHeight;
//
//////////////////////////////////////////////////////

void FillArray( int o_a, float i_val )
{
    for ( int i = 0; i < ArraySize; ++i ) // PW2: SUBSTITUTE "i < 0" with "i < size of the array" 
    {
        State[o_a][i] = i_val;
    }
}

void SetInitialState()
{
    //////////////////////////////////////////////////////
    //// Question PW2
    //
    FillArray(StateCon, 0.0); //Omplim el vector amb 0 a totes les seves posicions
    //
    //////////////////////////////////////////////////////
}

void EnforceBoundaryConditions()
{
    //////////////////////////////////////////////////////
    //// Question PW3
    //
    // Pouring liquid for 30 seconds
    if (CurrentTime < 30){
      State[StateCon][ArraySize/2]=1;
    }
    // Neumann boundary conditions
    State[StateCon][0] = State[StateCon][1];
    State[StateCon][ArraySize-1] = State[StateCon][ArraySize-2]; //Apliquem les condicions de contorn de Neumann
    //
    //////////////////////////////////////////////////////
}


void setup()
{
    SetInitialState();
    EnforceBoundaryConditions();

    size( 384, 120 );
    
    WindowWidth = 384;
    WindowHeight = 120;

    colorMode( RGB, 1.0 );
    noStroke();
    textSize( 24 );
}


void TimeStep( float i_dt )
{
    //////////////////////////////////////////////////
    //// Question PW4
    //
    // Update every state
    float [] f1 = new float [ArraySize]; //Declarem un nou array per a F1
    float [] f2 = new float [ArraySize]; //Declarem un nou array per a F2
    float [] f3 = new float [ArraySize]; //Declarem un nou array per a F3
    float [] f4 = new float [ArraySize]; //Declarem un nou array per a F4
    float uj1, uj2, uj3; //uj1 = F2 j, uj2 = F2 j+1, uj3 = F2 j-1
    float uj4, uj5, uj6; //uj1 = F3 j, uj2 = F3 j+1, uj3 = F3 j-1
    float uj7, uj8, uj9; //uj1 = F4 j, uj2 = F4 j+1, uj3 = F4 j-1
    
    for ( int i = 1; i < (ArraySize-1); i++ ){ //for que calcula el valor de f1 a cada posició
      f1[i] = (ConstantAlpha)*((State[StateCon][i+1]-2*State[StateCon][i]+State[StateCon][i-1]))/sq(DX);
    }
    for ( int i = 1; i < (ArraySize-1); i++ ){ //for que calcula el valor de f2 a cada posició
      uj1 = State[StateCon][i] + DT*f1[i];  //j
      uj2 = State[StateCon][i+1] + DT*f1[i+1]; //j+1
      uj3 = State[StateCon][i-1] + DT*f1[i-1]; //j-1
      f2[i] = (ConstantAlpha)*(uj2-2*uj1+uj3)/sq(DX);
    }
    for ( int i = 1; i < (ArraySize-1); i++ ){ //for que calcula el valor de f3 a cada posició
      uj4 = State[StateCon][i] + DT*f2[i]; //j
      uj5 = State[StateCon][i+1] + DT*f2[i+1]; //j+1
      uj6 = State[StateCon][i-1] + DT*f2[i-1]; //j-1
      f3[i] = (ConstantAlpha)*(uj5-2*uj4+uj6)/sq(DX);
    }
    for ( int i = 1; i < (ArraySize-1); i++ ){ //for que calcula el valor de f4 a cada posició
      uj7 = State[StateCon][i] + DT*f3[i]; //j
      uj8 = State[StateCon][i+1] + DT*f3[i+1]; //j+1
      uj9 = State[StateCon][i-1] + DT*f3[i-1]; //j-1
      f4[i] = (ConstantAlpha)*(uj8-2*uj7+uj9)/sq(DX);
    }
    for ( int i = 1; i < (ArraySize-1); i++ ){ //for per computar RK4
      State[StateCon][i] = State[StateCon][i] + (DT/6*(f1[i]+2*f2[i]+2*f3[i]+f4[i]));
    }
    // Apply boundary conditions
    EnforceBoundaryConditions();
    // Update simulation time.
    CurrentTime += i_dt; //Actualitzem CurrentTime
    //
    //////////////////////////////////////////////////
}


void DrawState()
{
    float PixelsY      = ( float )PixelsPerCell / (10*DX);
    float OffsetX      = 0.9 * ( float )WindowWidth;
    float OffsetBarY   = 0.54 * ( float )WindowHeight;
    float TextBoxSize  = 40;
  

    // Plot each element of the AFOREMENTIONED STATE
    for ( int i = 0; i < ArraySize; ++i ) // PW5: SUBSTITUTE "i < 0" with "i < size of the array"
    {
        float PixelsX  = ( float )( i * (PixelsPerCell-1) );
        
        //////////////////////////////////////////////////
        //// PW5
        //
        float SimY     = State[StateCon][i]; // Substitute 0 with the name of the index
        //
        //////////////////////////////////////////////////

        // Print the temperature propagation in the bar
        fill( SimY/(InitialPouring), 0.0, (InitialPouring-SimY)/(InitialPouring) );
        rect( OffsetX - PixelsX , OffsetBarY - PixelsY, PixelsPerCell-1, 4*PixelsPerCell );
    }

    // Protect the figure's name
    fill(1.0,1.0,1.0);
    rect(0.0,0.0,WindowWidth-1,TextBoxSize);
}


void draw()
{
    background( 0.9 );

    TimeStep( DT );

    DrawState();

    // Label.
    fill( 0.0 );
    text( "Liquid diffusion", WindowWidth/4, 30 );
}
