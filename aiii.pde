import ddf.minim.*;
import ddf.minim.analysis.*;
import peasy.*;
PeasyCam cam;

Minim       minim;
//AudioPlayer myA;
AudioInput  myA;
FFT         aFFT;

int         delFFT  = 12;
int         aM      = 10;  

float       amp     = 170.0;
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
PVector v1;
PImage img;

void setup() {
 //size(900, 760, P3D);
 fullScreen(P3D);
  background(0);
  strokeWeight(15);
  
  noCursor();
  cam = new PeasyCam(this,100);

  minim   = new Minim(this);
  // myA = minim.loadFile("acid.wav");
  // myA.loop();
  myA = minim.getLineIn(Minim.MONO);

  aFFT = new FFT(myA.bufferSize(), myA.sampleRate());
  aFFT.linAverages(delFFT);
  aFFT.window(FFT.GAUSS);

}

void draw() {
 //background(bgColor);
   fill(0,6);
   pushMatrix();
   translate(-284, 201, 7);
   noStroke();
   box(1683,1725,1543);
   popMatrix();

  aFFT.forward(myA.mix);
  //translate(width/2, height/2);
  aDelData();
  
  noStroke();
  pushMatrix();
  rotateZ(tt);
  translate(0,0,-20);
  fill(255);
  beginShape();
  
  vertex(-20 ,0, 0  );
  vertex(-5  ,0, -5  );
  vertex(0   ,0, -20);
  vertex(5   ,0, -5 );
  vertex(20  ,0, 0  );
  vertex(5   ,0, 5  );
  vertex(0   ,0, 20 );
  vertex(-5  ,0, 5  );
  vertex(-5 ,0, 5  );
  //vertex(-5   ,0, -5);
  
  endShape(CLOSE);
  popMatrix();
}

void aDelData() {
  translate(0, 0, 0);

  for (int i = 0; i < delFFT; ++i) {

    float partI = (aFFT.getAvg(i) * amp) * aIa;
    float tempIndexCon = constrain(partI, 0, aM);

    for (float t = 0; t < 9 * TWO_PI; t += PI/11) {
        
      int r = 10; 
      
      v = new PVector(r*t * cos(t+tt),r*t * sin(t+tt),r*t);
      v1 = new PVector(r*t * cos(t+tt),r*t * sin(t+tt),r*t+partI);         
      
      stroke(#f5f7f6);   
      strokeWeight(5);
      point(v.x, v.y, v.z);
        
      strokeWeight(2);
      stroke(#3ed4ff);
      point(v1.x, v1.y, v1.z);

      tt += 0.000007;
     
      aData[i] = tempIndexCon;
      aIa += aIStep;
    
      if ( tt == 128 ){
        tt = 0; 
      }
    }
    aIa = aI;
    println(tt);
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
