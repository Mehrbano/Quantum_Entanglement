//***Main Sketch***///
//fullScreen Displayfor full screen sketch>present

import processing.opengl.*;
import java.util.Iterator;

//*** GLOBAL OBJECTS ***//
//MAIN CONFIGURATION all data stored
MainCofig gConfig;
//KINECT 
Kinecter gKinecter;
//converting kinect data to flow field
OpticalFlow gFlowfield;
//PARTICLE MANAGER render flow field
PartiManager gPartiManager;

//RAW DEPTH kinect
int[] gRawDepth;
//ADJUST DEPTH AND THRESHOLD by updateKinectDepth()
  int[] gNormalizedDepth;
//DEPTH IMAGE THRESHOLD by updateKinectDepth()
PImage gDepthImg;

//Timer
float lasttimecheck;
float timeinterval;

//RUNNING CONFIGURATION
void start() {
  gConfig = new MainCofig();
}

//INITIALIZE
void setup() {
  size (displayWidth, displayHeight, OPENGL);
  background(55, 100, 150);
  lasttimecheck = millis();
  timeinterval = 5000; //5 sec?
  // set up noise seed
  noiseSeed(gConfig.setupNoiseSeed);
  frameRate(gConfig.setupFPS);
  // helper class for kinect
  gKinecter = new Kinecter(this);
  //used in kinect and opticalflow classes
  gNormalizedDepth = new int[gKinectWidth*gKinectHeight];
  gDepthImg = new PImage(gKinectWidth, gKinectHeight);
  // Create the particle manager.
  gPartiManager = new PartiManager(gConfig);
  // Create the flowfield
  gFlowfield = new OpticalFlow(gConfig, gPartiManager);
  // Tell the particleManager about the flowfield
  gPartiManager.flowfield = gFlowfield;
}

// DRAW LOOP
void draw() {
  pushStyle();
  pushMatrix();
  if (gConfig.showFade) blendScreen(gConfig.fadeColor, gConfig.fadeAlpha);
  // updates the kinect gRawDepth, gNormalizedDepth & gDepthImg variables
  gKinecter.updateKinectDepth();
  // update opticFlow vectors from gKinecter depth image draws `showFlowLines` if true
  gFlowfield.update();
  //FLOWFIELD AND PARTICLE MANAGER
  if (gConfig.showParticles) gPartiManager.updateWithRender();
  popStyle();
  popMatrix();
}
//CREATE AMBIENCE OF THE PROGRAM 
void blendScreen (color bgColor, int opacity) 
{
  if (millis() < lasttimecheck + timeinterval)
  {
  pushStyle(); 
  blendMode(gConfig.blendMode); 
  noStroke();
  fill(10,29,30);//, opacity);
  rect(0, 0, width, height); 
  blendMode(BLEND);
  popStyle();  
  }
  else if (millis() < lasttimecheck + timeinterval*10)
  {
  pushStyle();
  //blendMode(gConfig.blendMode);
  fill(20,29,30, opacity);
  rect(0, 0, width, height);
  blendMode(ADD);
  popStyle();  
  }
  else if (millis() < lasttimecheck + timeinterval*20)
  {
  pushStyle();
  blendMode(gConfig.blendMode); 
  fill(#0A306F);//, opacity);
  //rect(0, 0, width, height);
  blendMode(BLEND); 
  popStyle();  
  }
}

