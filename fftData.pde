import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
//AudioPlayer myAudio;
AudioInput  myAudio;
FFT         aFFT;

// Variables for FFT 
int         delFFT 	= 11;
int         aM      = 70;  
float       amp     = 30.0;
float       aI     	= 0.2;
float       aIa  		= aI;
float       aIStep 	= 0.35;
float[]     aData   = new float[delFFT];

PFont mono;

void setup() {
  size(500, 500);
  //fullScreen();
  background(0);
  mono = loadFont("Helvetica-48.vlw");
  textFont(mono, 14);
  smooth();
  minim   = new Minim(this);
  // myAudio = minim.loadFile("music.mp3"); // must be in data folder
  // myAudio.loop();
  myAudio = minim.getLineIn(Minim.MONO);
  aFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
  aFFT.linAverages(delFFT);
  aFFT.window(FFT.GAUSS);
}

void draw() {
  noStroke();
  fill(0, 7);
  rect(-10, -10, width+10, height+10);
  aFFT.forward(myAudio.mix);
  aDelData();
 //println(aData);
}

void aDelData() {
  String b = "[ ";
  String d = "] ";

  for (int i = 0; i < delFFT; ++i) {
    stroke(255,50);
    fill(#0353F4,30);
    float partI = (aFFT.getAvg(i) * amp) * aIa;
    float tempIndexCon = constrain(partI, 0, aM);
    rect(60 + (i*35), height - 80, 39, -partI);

    fill(255);
    text(b, 40 , height - 30);
    text(d, width - 50, height - 30);
    text( i, 60 + (i*35), height - 30);
    aData[i] = tempIndexCon;
    aIa += aIStep;
  }
  aIa = aI;
}

void stop() {
  myAudio.close();
  minim.stop();  
  super.stop();
}
