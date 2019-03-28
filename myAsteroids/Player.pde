class Player {
  PVector pos, vel, acc;
  
  int score = 0;       // score count
  int shootCount = 0;  //stops the player from shooting too quickly
  float rotation;      //the ships current rotation
  float spin;          //the amount the ship is to spin next update
  float maxSpeed = 10; //limit the players speed at 10
  boolean boosting = false;//whether the booster is on or not
  ArrayList<Bullet> bullets = new ArrayList<Bullet>(); //the bullets currently on screen
  int boostCount = 10;//makes the booster flash
  boolean canShoot = true; //whether the player can shoot or not

  int r,g,b;
  
  Player(int r, int g, int b, int startingX, float startingRotation) {
    pos = new PVector(width/2+startingX, height/2);
    vel = new PVector();
    acc = new PVector();  
    rotation = startingRotation;
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  void move() {
    rotatePlayer();
    if (boosting) {//are thrusters on
      boost();
    } else {
      boostOff();
    }

    vel.add(acc);//velocity += acceleration
    vel.limit(maxSpeed);
    vel.mult(0.99);
    pos.add(vel);//position += velocity

    for (int i = 0; i < bullets.size(); i++) {//move all the bullets
      bullets.get(i).move();
    }

    if (isOut(pos)) {//wrap the player around the gaming area
      loopy();
    }
  }  
  
  //------------------------------------------------------------------------------------------------------------------------------------------
  //wraps the player around the playing area
  void loopy() {
    if (pos.y < -50) {
      pos.y = height + 50;
    } else
      if (pos.y > height + 50) {
        pos.y = -50;
      }
    if (pos.x< -50) {
      pos.x = width +50;
    } else  if (pos.x > width + 50) {
      pos.x = -50;
    }
  }
  
  //------------------------------------------------------------------------------------------------------------------------------------------
  // PLAYER MOMVEMENT
  void boost() {
    acc = PVector.fromAngle(rotation); 
    acc.setMag(0.1);
  }  
  
  void boostOff() {
    acc.setMag(0);
  }
  
  void rotatePlayer() { //spin that player
    rotation += spin;
  }
  
  //in charge or moving 
  void update() {
    for (int i = 0; i < bullets.size(); i++) {//if any bullets expires remove it
      if (bullets.get(i).off) {
        bullets.remove(i);
        i--;
      }
    }    
    move();//move everything
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //shoot a bullet
  void shoot() {
    //if (shootCount <=0) {//if can shoot
      bullets.add(new Bullet(pos.x, pos.y, rotation, vel.mag()));//create bullet
      shootCount = 30;//reset shoot count
      canShoot = true;
    //}
  }
  
  
  //------------------------------------------------------------------------------------------------------------------------------------------
  //check if player is hit by a bullet
  void checkIfBulletHit(Player enemyPlayer) {
    for (Bullet b: this.bullets) {
      if (dist(enemyPlayer.pos.x, enemyPlayer.pos.y, b.pos.x, b.pos.y)< 20) {
        score++;
        b.eraseBullet();
      }
    }
  }
  
  //------------------------------------------------------------------------------------------------------------------------------------------
  //draw the player and, bullets 
  void show() {
    for (int i = 0; i < bullets.size(); i++) { //show bullets
      bullets.get(i).show();
    }
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    //actually draw the player
    fill(this.r, this.g, this.b);
    noStroke();
    beginShape();
    int size = 12;
    //black triangle
    vertex(-size-2, -size);
    vertex(-size-2, size);
    vertex(2* size -2, 0);
    endShape(CLOSE);
    stroke(255);
    //white out lines
    line(-size-2, -size, -size-2, size);
    line(2* size -2, 0, -22, 15);
    line(2* size -2, 0, -22, -15);
    if (boosting ) {//when boosting draw "flames" its just a little triangle
      boostCount --;
      if (floor(((float)boostCount)/3)%2 ==0) {//only show it half of the time to appear like its flashing
        line(-size-2, 6, -size-2-12, 0);
        line(-size-2, -6, -size-2-12, 0);
      }
    }
    popMatrix();
  }
  
  //------------------------------------------------------------------------------------------------------------------------------------------
  //shows the score of player
  void showScore(String location) {
    textFont(font);
    fill(this.r, this.g, this.b);
    if (location.equals("LEFT")) { 
      text("Score: " + this.score, 50, 60);
    } else if (location.equals("RIGHT")) {
      text("Score: " + this.score, width-180, 60);
    }
  }
}
