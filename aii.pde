import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
//AudioPlayer myA;
AudioInput  myA;
FFT         aFFT;

int         delFFT  = 11;
int         aM      = 20;  

float       amp     = 100.0;
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
float f   = 0.10008;  // Wave amplitude

PVector v;

void setup() {
 size(600, 760);
 //fullScreen();
  background(bgColor);
  strokeWeight(5);
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
  fill(0,15);
  rect(-10, 0, width+20, height);

  strokeWeight(2);
  
  aFFT.forward(myA.mix);
  translate(width/2, height/2);
  aDelData();
}

void aDelData() {

  for (int i = 0; i < delFFT; ++i) {
    fill(255);

    float partI = (aFFT.getAvg(i) * amp) * aIa;
    float tempIndexCon = constrain(partI, 0, aM);

    noStroke();
    // rect(20 + (i*60), height/2+400, 60, -partI);
    float w   = PI * f;
    
    noStroke();
    stroke(#FFFFFF);
    beginShape(POINTS);
    for (float theta = 0.0; theta < TWO_PI; theta += PI/6) {
      int r = 250;

      float x = (r-partI) * cos(theta+t) ;
      float y = (r-partI) * sin(theta+t) ;

      PVector v = new PVector(x,y);

      point(v.x, v.y);
      // vertex(0, v.y );

      t += 0.0001;   
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

  //println(aData, t);

  if (frameCount > 4000) {
    t = 0.18;
  }
  if (frameCount > 10000) {
    t += f;
  } 
  if(frameCount > 20000) {
    t = 0.18;
  }
  if (frameCount > 30000) {
    t += f;
  }
  if (frameCount > 40000) {
    t = 0.18;
  }

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