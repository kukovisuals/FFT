import ddf.minim.*;
import ddf.minim.analysis.*;
import peasy.*;
PeasyCam cam;

Minim       minim;
//AudioPlayer myA;
AudioInput  myA;
FFT         aFFT;

int         delFFT  = 11;
int         aM      = 700;  

float       amp     = 40.0;
float       aI      = 0.2;
float       aIa     = aI;
float       aIStep  = 0.35;

float[]     aData   = new float[delFFT];

// ************************************************************************************

color       bgColor = #000000;

// ************************************************************************************
float a   = 200;
float tt   = 0.0;
float ph  = 0.0;
float y;
float f   = 0.10008;  // Wave amplitude

PVector v;

void setup() {
 //size(600, 760, P3D);
 fullScreen(P3D);
  background(bgColor);
  strokeWeight(5);
  cam = new PeasyCam(this,100);

  minim   = new Minim(this);
  // myA = minim.loadFile("acid.wav");
  // myA.loop();
  myA = minim.getLineIn(Minim.MONO);

  aFFT = new FFT(myA.bufferSize(), myA.sampleRate());
  aFFT.linAverages(delFFT);
  //aFFT.window(FFT.GAUSS);

}

void draw() {
 //background(bgColor);
   fill(0,4);
   pushMatrix();
   translate(29, 337, 200);
   noStroke();
   box(1400,1300,1300);
   popMatrix();

  strokeWeight(5);
  
  aFFT.forward(myA.mix);
  //translate(width/2, height/2);
  aDelData();
}

void aDelData() {
  translate(0, height/2, 0);

  for (int i = 0; i < delFFT; ++i) {

    float partI = (aFFT.getAvg(i) * amp) * aIa;
    float tempIndexCon = constrain(partI, 0, aM);

    for (float t = 0; t < 8 * TWO_PI; t += PI/60) {
        
      int r = 10; 
      PVector v = new PVector(r*t * cos(t+tt),r*t * sin(t+tt),r*t);

      PVector v1 = new PVector(r*t * cos(t+tt),r*t * sin(t+tt),r*t+partI);         
      
      stroke(#F5C906);      
      point(v.x, v.y, v.z);

      stroke(#049BC2);
      point(v1.x, v1.y, v1.z);

       tt += 0.00001;   
    //  println(v.x,v.y,v.z);
     }

    aData[i] = tempIndexCon;
    aIa += aIStep;

  }
  aIa = aI;

  //println(aData, t);
}

void stop() {
  myA.close();
  minim.stop();  
  super.stop();
}



/*
delFFT = myAudioRange , aM = audioMax , partI = audioIndexAverage
amp = myAudioAmp , aI = myAudioIndex , aIa = myAudioIndexAmp
aIStep = myAudioIndexStep , aData = myAudioData, 
aDelData = myAudioDataUpdate
*/