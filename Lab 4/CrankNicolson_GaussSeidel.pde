//////////////////////////////////////////////////////
float ConstantC         = 0.25;
float MaxHeight           = 100; 
//////////////////////////////////////////////////////

float WorldSize         = 10.0;
int ArraySize           = 64;
float DX                = WorldSize / ArraySize;

//////////////////////////////////////////////////////
//// Question 2.1
//Define de State as a two dimension matrix of 3 by ArraySize
int StateSize = 3;
float [][] State = new float[StateSize][ArraySize];
int m = 1;//Index for current state (m), next state (m+1), and previous state (m-1)
// End Question 2.1
//////////////////////////////////////////////////////

float StateCurrentTime  = 0.0;

//Visualization - Amount of pixels per cell on the X axis 
int PixelsPerCell       = 6;

//Visualization - Dimensions of the visualization window 
int WindowWidth         = PixelsPerCell * ArraySize;
int WindowHeight        = WindowWidth/2;

//Get input
boolean InputActive = false;
int InputIndex = 0;
float InputTemp = 0;
//////////////////////////////////////////////////////
void CopyArray( float[] arr_src, float[] arr_dst )
{
    for ( int i = 0; i < ArraySize; ++i )
    {
        arr_dst[i] = arr_src[i];
    }
}

void FillArray( int o_a, float i_val )
{
    for ( int i = 0; i < ArraySize; ++i )
    {
        State[o_a][i] = i_val;
    }
}

//////////////////////////////////////////////////////
//
void EnforceBoundaryConditions(  )
{
    //////////////////////////////////////////////////  
    //// Question 2.2
    // Neumann boundary Conditions at both ends for the actual state (m)
    State[m][0] = State[m][1];
    State[m][ArraySize-1] = State[m][ArraySize-2];
    // End Question 2.2
    //////////////////////////////////////////////////    
       
    
    if ( StateCurrentTime==0 )//perturbation at time zero
    {
        State[m][ArraySize/2] = MaxHeight/2;
    }
}
//

//////////////////////////////////////////////////////
//// Question 2.3
//
void SetInitialState()
{
    //Initialize current state (m)
    FillArray(m,MaxHeight);
    //Initialize previous state (m-1)
    FillArray(m-1,MaxHeight);
    //apply boundary conditions
    EnforceBoundaryConditions(  );
    StateCurrentTime = 0.0;//Set current time to zero
}
// End Question 2.3
//////////////////////////////////////////////////////

void setup()
{
    SetInitialState();

    size( 384 , 230 );
    
    WindowWidth = 384;
    WindowHeight = 230; 

    colorMode( RGB, 1.0 );
    strokeWeight( 0.5 );
    textSize( 24 );
  
}


//////////////////////////////////////////////////////
void TimeStep( float i_dt )
{
    //Set maximum iterations and tolerance threshold for Jacobi
    int maxIt               = 20; // For Question 2.4
    //float tolerance         = ; // Uncomment and complete for Question 2.5
 
    //////////////////////////////////////////////////
    //// Question 2.4
    
    //Initialize data structures for the matrix operation A*x=b
      //Create vector b of size ArraySize
      float [] b = new float[ArraySize];
      //Create a matrix x of 2 by ArraySize, to store current and next iterations
      int n = 0;//Index for current iteration (n) and next iteration (n+1)
      int x_size = 2;
      float [][] x = new float[x_size][ArraySize];
    //Set initial solution x^n with the current state values (use CopyArray function)
    CopyArray(State[m], x[n]);
    
    // Iterative Solver implementation:
    for ( int iter = 0; iter < maxIt; ++iter )
    {
      //Initialize mu, aii (diagonal) and aij (values next to diagonals)
      float mu = sq(ConstantC)*(sq(i_dt)/(2*sq(DX)));
      float aii = 1+2*mu;
      float aij = -mu;
      //Update the boundaries for x[n+1]
      x[n+1][0] = State[m][0];
      x[n+1][ArraySize-1] = State[m][ArraySize-1];
      //Iterative loop: apply jacobi formula to calculate each cell of next x (exclude the boundaries!!!)
      for ( int i = 1; i < ArraySize-1; ++i )
      {
          //Calculate each cell vector b (for each method this will be different!!!)
          b[i] = mu*State[m][i+1] + 2*(1-mu)*State[m][i]+mu*State[m][i-1]-State[m-1][i];
          //Implement jacobi/Gauss-seidel forumla
          x[n+1][i] = (b[i] - (aij*x[n+1][i-1]+aij*x[n][i+1]))/aii;
      }
      
      //////////////////////////////////////////////////
      //// Question 2.5
      
      //Calculate the error

      //If the error is less than the tolerance, then break the loop
      //if ( error <= tolerance )// (Uncomment for Q 2.5)
      {
        print("Iterations = " , iter+1,  "\n");
        //break;// (Uncomment for Q 2.5)
      }
      // End Question 2.5
      //////////////////////////////////////////////////
      
      //Update x^n with the obtained x^n+1
      CopyArray(x[n+1], x[n]);
    }
    //Update the next state m+1 with the obtained solution (i.e. last x^n+1)
    //Use the CopyArray function
    CopyArray(x[n+1], State[m+1]);
    //Update the previous state m-1 with the actual state m
    //Use the copy ArrayFunction
    CopyArray(State[m], State[m-1]);
    //Update actual state m with the state obtained for m+1
    //Use the copy ArrayFunction
    CopyArray(State[m+1], State[m]);
    // End Question 2.4
    //////////////////////////////////////////////////
    

    
    // Enforc BC
    EnforceBoundaryConditions(  );
    
    // Update current time.
    StateCurrentTime += i_dt;
    

}


void DrawState()
{
      
    float OffsetX           = WindowWidth * 0.08;
    float OffsetY_bar       = WindowHeight * 0.8 ;
    float OffsetY_profile   = WindowHeight * 0.75 ;
    float OffsetX_meas      = WindowWidth * 0.05;
    float MeasSpacing  = sqrt(MaxHeight);
    float MeasWidth    = 4;
    float TextBoxSize  = 45;
  
    //// Measurement lines. One line = InitialTempºC
    for ( int i = 0; i < 11; i++ )
    {
        line( OffsetX_meas, OffsetY_profile - i*MeasSpacing , OffsetX_meas + MeasWidth, OffsetY_profile - i*MeasSpacing);
    }

    // Plot each element of the array
    for ( int i = 0; i < ArraySize; ++i )
    {
        float PixelsX  = ( float )( i * (PixelsPerCell-1) + OffsetX);
        float SimY     = State[m][i];
        
        // Print the temperature propagation in the bar
        fill( SimY/(0.75*MaxHeight), 0.0, (MaxHeight-SimY)/(0.75*MaxHeight) );
        rect( PixelsX , OffsetY_bar , PixelsPerCell-1, 4*PixelsPerCell );
        
        // Plot the temperature profile
        fill( 1.0, 0.0, 0.0 );
        rect( PixelsX , OffsetY_profile , PixelsPerCell-3, -SimY );

    }

    // Protect the figure's name
    fill(1.0,1.0,1.0);
    rect(0.0,0.0,WindowWidth-1,TextBoxSize);
    // Title
    fill( 0.0 );
    textSize(15);
    text( "Wave Equation - Implicit Methods", 70, 30 );
}

void draw()
{
    background(0.9);

    TimeStep(1.0/24);

    DrawState();
        
}
