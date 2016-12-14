import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
//AudioPlayer myA;
AudioInput  myA;
FFT         aFFT;

int         delFFT  = 11;
int         aM      = 20;  

float       amp     = 40.0;
float       aI      = 0.2;
float       aIa     = aI;
float       aIStep  = 0.35;

float[]     aData   = new float[delFFT];

// ************************************************************************************

color       bgColor = #000000;

// ************************************************************************************
float a   = 200;
float t   = 0.0;
float ph  = 0.0;
float y;

PVector v;

void setup() {
  size(1300, 760);
  background(bgColor);

  minim   = new Minim(this);
  // myA = minim.loadFile("HECQ_With_Angels_Trifonic_Remix.wav");
  // myA.loop();
  myA = minim.getLineIn(Minim.MONO);

  aFFT = new FFT(myA.bufferSize(), myA.sampleRate());
  aFFT.linAverages(delFFT);
  aFFT.window(FFT.GAUSS);

}

void draw() {
  //background(bgColor);
  fill(0,15);
  rect(-10, 0, width+20, height);

  strokeWeight(1.5);
  
  aFFT.forward(myA.mix);
  translate(0, -200);
  aDelData();
}

void aDelData() {

  for (int i = 0; i < delFFT; ++i) {
    fill(#0353F4);

    float partI = (aFFT.getAvg(i) * amp) * aIa;
    float tempIndexCon = constrain(partI, 0, aM);

     noStroke();
   //  rect(20 + (i*60), height/2+400, 60, -partI);
    
     float f   = 0.18;
     float w   = PI * f;

    stroke(#0580F3);
    beginShape(POINTS);
     for (int x = 0; x < width; x+=5) {
       y =height/2 +  a-(partI) * sin(w*t + ph);

       v = new PVector(x, y);
       
       vertex(v.x, v.y );
       t += f;   
       //println(t);
     }
     endShape();

     pushMatrix();
     noStroke();
  //   rect(20 + (i*60), 0, 60, partI);
     popMatrix();
    aData[i] = tempIndexCon;
    aIa += aIStep;

  }
  aIa = aI;

  println(aData);
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


