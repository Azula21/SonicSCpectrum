import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 1024;
float[] spectrum = new float[bands];

int xspacing = 25;   // How far apart should each horizontal location be spaced
int yspacing = 20;
int loop = 0;
int w;              // Width of entire wave

float theta = 0.0;  // Start angle at 0
float amplitude;  // Height of wave
float period = 500.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave

void setup() {
  size(1024, 1024);
  background(0);
   
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[bands];
  
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  //amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
  //amp.input(in);
}      

void draw() { 
  background(0);
  fft.analyze(spectrum);
  //if(frameCount/60 == 0){
  //  period = volume * 100;    
  //}
  calcWave();
  renderWave();
  
  //for (int r=0; r < 512; r++){
  //  for(int u=0; u < 512; u = u +xspacing){
  //  ellipse(u, r*yspacing, 12, 12); 
  //  }
  //}
}

void calcWave() 
{
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < bands; i++) 
  {
    amplitude = 75 + spectrum[i]*75*100;
    yvalues[i] = sin(x)*amplitude;
    x+=dx;
    if (amplitude < 75)
    {
      yvalues[i] = sin(x)*150;
    }
  }
}

void renderWave() 
{
  noStroke();
  // A simple way to draw the wave with an ellipse at each location
  for (int j = 0; j+1 < yvalues.length; j++) 
  {
    if(loop < 1000) 
    {
      if(yvalues[j] < 0 && abs(yvalues[j]) > 50)
      {
        fill(abs(yvalues[j])*2,j*xspacing/4,0);
        if(abs(yvalues[j]) > 75)
        {
          stroke(abs(yvalues[j])*2,j*xspacing/4,0);
          line(j*xspacing, height/2+yvalues[j], j*xspacing, 0);
        }
      }
      else if(abs(yvalues[j]) <= 50)
      {
        fill(0,random(abs(yvalues[j])+70, 150),j*xspacing/10);
        if(j*xspacing % 9 ==0)
        {
          stroke(0,random(abs(yvalues[j])+70, 150),j*xspacing/10);
          line(j*xspacing, height/2+yvalues[j], j*xspacing, 0);
        }
        else if(j*xspacing % 8 == 0)
        {
          stroke(0,random(abs(yvalues[j])+70, 150),j*xspacing/10);
          line(j*xspacing, height/2+yvalues[j], j*xspacing, height);
        }
      }
      if(yvalues[j] > 0 && yvalues[j] > 50)
      {
        fill(j*xspacing/5,0, yvalues[j]);
        if(yvalues[j] > 75)
        {
          stroke(j*xspacing/5,0, yvalues[j]);
          line(j*xspacing, height/2+yvalues[j], j*xspacing, height);
        }
        
      }
      ellipse(j*xspacing, height/2+yvalues[j], 16, 16);
    }
     else if (loop > 1000 && loop < 2000)
     {
       if(yvalues[j] < 0 && abs(yvalues[j]) > 50)
      {
        fill((j+1)*xspacing / 2, (width - j) * xspacing /4, abs(yvalues[j]) * 1.5);
        
        if(abs(yvalues[j]) > 75)
        {
          stroke((j+1)*xspacing / 2, (width - j) * xspacing /4, abs(yvalues[j]) * 1.5);
          line(j*xspacing, height/2+yvalues[j], j*xspacing, height);
        }
      }
      if(abs(yvalues[j]) < 50)
      {
        fill(width - (j*xspacing) /6,random(abs(yvalues[j])+70, 255),j*xspacing/15);
        if(j*xspacing % 9 ==0)
        {
          stroke(width - (j*xspacing) /6,random(abs(yvalues[j])+70, 255),j*xspacing/15);
          line(j*xspacing, height/2+yvalues[j], j*xspacing, 0);
        }
        if(j*xspacing % 8 == 0)
        {
          stroke(width - (j*xspacing) /6,random(abs(yvalues[j])+70, 255),j*xspacing/15);
          line(j*xspacing, height/2+yvalues[j], j*xspacing, height);
        }
      }
      else if(yvalues[j] > 0 && yvalues[j] > 50)
      {
        fill(abs(yvalues[j])*1.5,j*xspacing/2,random(100,200));
        if(yvalues[j] > 75)
        {
          stroke(abs(yvalues[j])*1.5,j*xspacing/2,random(100,200));
          line(j*xspacing, height/2+yvalues[j], j*xspacing, 0);
        }
       ellipse(j*xspacing, height/2+yvalues[j], 16, 16);
      }
    //line(j*xspacing, height/2+yvalues[j], (j+1)*xspacing, height/2+yvalues[j+1]);
    //line(j, yvalues[j], 0,0);    
    ellipse(j*xspacing, height/2+yvalues[j], 16, 16);
     }
     
     if(loop > 2000)
     {
       loop = 0;
     }
     
    }
  loop++;
}