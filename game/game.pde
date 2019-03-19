import oscP5.*;

OscP5 oscP5;
float posX, posY;
int r, g, b;

void setup() {
  // start oscP5, listening for incoming messages at port 4559
  oscP5 = new OscP5(this,4559);
  // initialize r,g,b
  r = 0;
  g = 0;
  b = 0;
  // initialize canvas
  size(500, 500);  
}

// incoming osc message are forwarded to the oscEvent method. 
void oscEvent(OscMessage theOscMessage) {
  // print OSC Message
  // theOscMessage.print();
  if (theOscMessage.addrPattern().equals("/xy")) {
     posX = (float)theOscMessage.arguments()[1];
     posY = (float)theOscMessage.arguments()[0];
     println("x="+posX+" y="+posY);
  }
  if (theOscMessage.addrPattern().equals("/fader-r")) {
    r = Math.round((float)theOscMessage.arguments()[0]*255);
  }
  if (theOscMessage.addrPattern().equals("/fader-g")) {
    g = Math.round((float)theOscMessage.arguments()[0]*255);
  }
  if (theOscMessage.addrPattern().equals("/fader-b")) {
    b = Math.round((float)theOscMessage.arguments()[0]*255);    
  }
}

void draw() {
  background(r,g,b);
  fill(255,0,0);
  stroke(255,255,255);
  circle(posX*width, posY*height, 10);  
}
