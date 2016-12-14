import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
//AudioPlayer myAudio;
AudioInput  myAudio;
FFT         aFFT;

int         delFFT 	= 12;
int         aM      = 50;  

float       amp     = 40.0;
float       aI     	= 0.2;
float       aIa  		= aI;
float       aIStep 	= 0.35;

float[]     aData   = new float[delFFT];

// ************************************************************************************

color       bgColor = #000000;

// ************************************************************************************

void setup() {
	size(800, 760);
	background(bgColor);

	minim   = new Minim(this);
	// myAudio = minim.loadFile("HECQ_With_Angels_Trifonic_Remix.wav");
	// myAudio.loop();
	myAudio = minim.getLineIn(Minim.MONO);

	aFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
	aFFT.linAverages(delFFT);
	aFFT.window(FFT.GAUSS);
}

void draw() {
	//background(bgColor);
	fill(0,5);
	rect(-10, 0, width+20, height);
	
	aFFT.forward(myAudio.mix);
	aDelData();
}

void aDelData() {

	for (int i = 0; i < delFFT; ++i) {
		stroke(0);fill(#0353F4);
		
		float partI = (aFFT.getAvg(i) * amp) * aIa;
		float tempIndexCon = constrain(partI, 0, aM);

		rect(20 + (i*60), height/2+360, 60, -partI);
		aData[i] = tempIndexCon;
		aIa += aIStep;
	}
	aIa = aI;

	println(aData);
}

void stop() {
	myAudio.close();
	minim.stop();  
	super.stop();
}



/*
delFFT = myAudioRange , aM = audioMax , partI = audioIndexAverage
amp = myAudioAmp , aI = myAudioIndex , aIa = myAudioIndexAmp
aIStep = myAudioIndexStep , aData = myAudioData, 
aDelData = myAudioDataUpdate
*/


