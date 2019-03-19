/* ASTEROIDS MULTIPLAYER GAME 
 * forked from CodeBullet
 * refactored by dcts
 */

import oscP5.*;

OscP5 oscP5;
int fRate = 100; // frame rate
PFont font;      // display font
Player player1;
Player player2;


void setup() { //on startup
  size(1200, 675);
  player1 = new Player(86, 130, 3, -400, (float)Math.random()*4);
  player2 = new Player(179, 30, 0, 400, (float)Math.random()*4);
  frameRate(fRate);  
  font = loadFont("AgencyFB-Reg-48.vlw");
  // start oscP5, listening for incoming messages at port 4559
  oscP5 = new OscP5(this,4559);
}

void draw() {
  //println(player1.rotation);
  background(0); //deep space background
  player1.update();
  player1.show();
  player1.showScore("LEFT");//display the score
  player2.update();
  player2.show();
  player2.showScore("RIGHT");//display the score
}

//function which returns whether a vector is out of the play area
boolean isOut(PVector pos) {
  if (pos.x < -50 || pos.y < -50 || pos.x > width+ 50 || pos.y > 50+height) {
    return true;
  }
  return false;
}


void keyPressed() {
  switch(key) {
  case ' ':
    player1.shoot();
    break;
  case '+'://speed up frame rate
    fRate += 10;
    frameRate(fRate);
    println(fRate);
    break;
  case '-'://slow down frame rate
    if (fRate > 10) {
      fRate -= 10;
      frameRate(fRate);
      println(fRate);
    }
    break;
  }
  //player controls
  if (key == CODED) {
    if (keyCode == UP) {
      player1.boosting = true;
    }
    if (keyCode == LEFT) {
      println("LEFT clicked");
      player1.spin = -0.08;
    } else if (keyCode == RIGHT) {
      player1.spin = 0.08;
      println("RIGHT clicked");
      println(" spin: " + player1.spin + " rotation: " + player1.rotation);
    }
  }
}

void keyReleased() {
  //once key released
  if (key == CODED) {
    if (keyCode == UP) {//stop boosting
      player1.boosting = false;
    }
    if (keyCode == LEFT) {// stop turning
      player1.spin = 0;
    } else if (keyCode == RIGHT) {
      player1.spin = 0;
    }
  }
}


// incoming osc message are forwarded to the oscEvent method. 
void oscEvent(OscMessage theOscMessage) {
  // print OSC Message
  // theOscMessage.print();
  // PLAYER1
  if (theOscMessage.addrPattern().equals("/1/xy")) {
     float x = (float)theOscMessage.arguments()[1];
     if (x<=0.35) {
       player1.spin = -0.08;
     } 
     if (x>=0.65) {
       player1.spin = 0.08;
     }
     if (x>0.35 && x<0.65) {
       player1.spin = 0;
     }
  }
  if (theOscMessage.addrPattern().equals("/1/fire")) {
    player1.shoot();
  }
  if (theOscMessage.addrPattern().equals("/1/move")) {
    float x = (float)theOscMessage.arguments()[0];
    if (x>0.2) {
      player1.boosting = true;
    } else {
      player1.boosting = false;
    }
  }
  // PLAYER 2
  if (theOscMessage.addrPattern().equals("/2/xy")) {
   float x = (float)theOscMessage.arguments()[1];
   if (x<=0.35) {
     player2.spin = -0.08;
   } 
   if (x>=0.65) {
     player2.spin = 0.08;
   }
   if (x>0.35 && x<0.65) {
     player2.spin = 0;
   }
  }
  if (theOscMessage.addrPattern().equals("/2/fire")) {
    player2.shoot();
  }
  if (theOscMessage.addrPattern().equals("/2/move")) {
    float x = (float)theOscMessage.arguments()[0];
  if (x>0.2) {
    player2.boosting = true;
  } else {
    player2.boosting = false;
  }
  }
}
