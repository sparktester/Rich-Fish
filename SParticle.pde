// Simple Particle System
// Daniel Shiffman <http://www.shiffman.net>

// A simple Particle class, renders the particle as an image

// Created 2 May 2005

class SParticle {
  PVector loc;
  PVector vel;
  PVector acc;
  float timer;
  PImage img;

  // Another constructor (the one we are using here)
  SParticle(PVector l,PImage img_) {
    acc = new PVector(0.0,0.0,0.0);
    float x = (float) generator.nextGaussian()*0.3f;
    float y = (float) generator.nextGaussian()*0.3f - 1.0f;
    vel = new PVector(x,y,0);
    loc = l.get();
    timer = 100.0;
    img = img_;
    
    hint(DISABLE_DEPTH_TEST);  //why isn't this working?
    
  }

  void run() {
    update();
    render();
  }
  

  // Method to update location
  void update() {
    vel.add(acc);
    loc.add(vel);
    timer -= 2.5;
    acc.mult(0); // clear Acceleration
  }

  // Method to display
  void render() {
    hint(DISABLE_DEPTH_TEST);  //still not working
    
    imageMode(CORNER);
    tint(255,timer);
    image(img,loc.x-135,loc.y-460);
    noTint();
  }

  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

