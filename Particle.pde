// Simple Particle System
// Daniel Shiffman <http://www.shiffman.net>

// A simple Particle class

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
  int yStop;

  
  // Another constructor (the one we are using here)
  Particle(PVector l, int xSpeedMin, int xSpeed, int tempyStop) {
    
    //println (xSpeedMin);
    // Boring example with constant acceleration
    acc = new PVector(0,.1);
    vel = new PVector(random(xSpeedMin, xSpeed),random(-1, 2));
    loc = l.get();
    r = 7;
    timer = 50.0;
    yStop = tempyStop;
  }

  void run() {
    update();
    render();
  }

  // Method to update location
  void update() {
    vel.add(acc);
    loc.add(vel);
    timer -= 1.0;
  }

  // Method to display
  void render() {
    ellipseMode(CENTER);
    stroke(255);
    fill(255, 200);
    
    ellipse(loc.x+10,loc.y,r,r);
    ellipse(loc.x,loc.y,r,r);
    ellipse(loc.x-5,loc.y-5,r,r);
     ellipse(loc.x,loc.y+15,r,r);
     ellipse(loc.x-10,loc.y+15,r,r);
  }
  
  // Is the particle still useful?
  boolean dead() {
    if ((timer <= 0.0) || (loc.y > yStop)) {
      return true;
    } else {
      return false;
    }
  }
}


