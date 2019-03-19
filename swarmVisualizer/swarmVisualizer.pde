/* ATTRACTOR 0
 * written in P5js by Masaki Yamabe, refactored to processing by dcts
 * original sourcecode: https://www.openprocessing.org/sketch/394718
*/

import oscP5.*;

/* global variables */
int num = 1000;
float[] vx = new float[num];
float[] vy = new float[num];
float[] x  = new float[num];
float[] y  = new float[num];
float[] ax = new float[num];
float[] ay = new float[num];
// swarm parameters
float radius = 6;
float magnetism;
float gensoku;
// player position
float posX = 0.5;  // between 0 and 1
float posY = 0.5;  // between 0 and 1
// OSC listener
OscP5 oscP5;

void setup() {
  //size(800, 800);
  fullScreen();
  noStroke(); 
  fill(0);
  background(0);
  
  // start oscP5, listening for incoming messages at port 4559
  oscP5 = new OscP5(this,4559);

  init();
}

// incoming osc message are forwarded to the oscEvent method. 
void oscEvent(OscMessage oscMsg) {
  // print OSC Message
  oscMsg.print();
  if (oscMsg.addrPattern().equals("/xy")) { // controls player position
     posX = (float)oscMsg.arguments()[1];
     posY = (float)oscMsg.arguments()[0];
     println("x="+posX+" y="+posY);
  }
  if (oscMsg.addrPattern().equals("/fader-r")) { // controlls radius
     float oscIn = (float)oscMsg.arguments()[0]; // oscIn is in range [0,1]
     radius = oscIn * 10;
     println(radius);
  }  
  if (oscMsg.addrPattern().equals("/fader-g")) { // controlls gensoku
     float oscIn = (float)oscMsg.arguments()[0]; // oscIn is in range [0,1]
     gensoku = oscIn * 1;
     println(gensoku);
  }  
  if (oscMsg.addrPattern().equals("/fader-b")) { // controlls magnetism
     float oscIn = (float)oscMsg.arguments()[0]; // oscIn is in range [0,1]
     magnetism = (oscIn * 55) + 5;
     println(magnetism);
  }  
  if (oscMsg.addrPattern().equals("/fire")) { // controlls fire -> RESTART SCETCH
     init();
  } 
  if (oscMsg.addrPattern().equals("/fire2")) { // controlls fire2 -> change draw style 
    blendMode(ADD);
  }
  
}

void draw() {
  // background
  fill(0,0,0);
  rect(0,0,width,height);
  // player
  drawPlayer();
  // particles 
  drawParticles();
}

void drawPlayer() {
  fill(255,255,255);
  ellipse(posX*width,posY*height,radius+10,radius+10);
}

void drawParticles() {
  // for all particles 
  for(int i=0; i<num; i++){
    // computate new positions
    float distance = dist(posX*width, posY*height, x[i], y[i]);
    if(distance > 3){ 
      ax[i] = magnetism * (posX*width - x[i]) / (distance * distance); 
      ay[i] = magnetism * (posY*height - y[i]) / (distance * distance);
    }
    vx[i] += ax[i]; 
    vy[i] += ay[i]; 
    
    vx[i] = vx[i]*gensoku;
    vy[i] = vy[i]*gensoku;
    
    x[i] += vx[i];
    y[i] += vy[i];
    
    // draw particles
    float sokudo = dist(0,0,vx[i],vy[i]);
    float r = map(sokudo, 0, 5, 0, 255);
    float g = map(sokudo, 0, 5, 64, 255);
    float b = map(sokudo, 0, 5, 128, 255);
    fill(r, g, b);
    ellipse(x[i],y[i],radius,radius);
  }
}

void init () {
  magnetism = 40.0;
  gensoku   = 0.95;

  noStroke(); 
  fill(0);
  background(0);
  //blendMode(ADD);  
  // initialize particles
  for(int i =0; i< num; i++){
    x[i] = random(width);
    y[i] = random(height);
    vx[i] = 0;
    vy[i] = 0;
    ax[i] = 0;
    ay[i] = 0;
  }
}
