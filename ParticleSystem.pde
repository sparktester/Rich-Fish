
class ParticleSystem {

  ArrayList particles;    // An arraylist for all the particles
  //PVector origin;        // An origin point for where particles are birthed
  int xMin, yMin, xMax, yMax, xSpeedMin, xSpeed, yStop;
  

  ParticleSystem(int tempxMin, int tempyMin, int tempxMax, int tempyMax,int tempxSpeedMin, int tempxSpeed, int tempyStop) {  //xMin, yMin, xMax, yMax, xSpeed
    
    xMin = tempxMin;
    yMin = tempyMin;
    xMax = tempxMax;
    yMax = tempyMax;
    xSpeedMin = tempxSpeedMin;
    xSpeed = tempxSpeed;
    yStop = tempyStop;
    
    //println(xSpeedMin);
    
    particles = new ArrayList();              // Initialize the arraylist
    particles.add(new Particle(new PVector(random(xMin, xMax), random(yMin, yMax)), xSpeedMin, xSpeed, yStop));    // Add "num" amount of particles to the arraylist
    
  }

  void run() {  
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run();
      if (p.dead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle() {
    
    for (int i = 0; i < 2; i++) {
      particles.add(new Particle(new PVector(random(xMin, xMax), random(yMin, yMax)), xSpeedMin, xSpeed, yStop));    // Add "num" amount of particles to the arraylist
        
    }
  }

  //void addParticle(Particle p) {
    //particles.add(p);
  //}

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

}



