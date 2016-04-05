/*
//original flockingvariables (pre-set)
float swt = 0.001;     //separation
float awt = 1.0;      //Alignment
float cwt = .05;      //Cohesian
float maxspeed = .3;  //max speed
float maxforce = 0.001;   //max force
*/

class Boid {
  
  //////////////////////////
  //FLOCKING VARIABLES//
  ////////////////////////
  float swt = 0.03;     //separation
  float awt = 1.0;      //Alignment
  float cwt = .05;      //Cohesian
  float r;
  float neighbordist = 400.0f;

  //////////////////////////////
  //PATH-Specific VARIABLES//
  /////////////////////////////////

  boolean onTheMove;  //has this fish broken away from the flock?
  int getGoing; //a frame on which he should set out
  int fishTimer;
  float swimStrength;

  ////////////////////
  //general items
  //////////////////////
  PVector loc;
  PVector vel;
  PVector acc;
  color c;
  float maxspeed;  //max speed  these will get changed back and forth depending on if it's on the move
  float maxforce;   //max force
  String fishName;
  //boolean showvalues;

  
  ///////////////////////
  //fish rendering items
  ////////////////////////
  float recentx, recenty, currentx, currenty, start;
  float [] xTop, yTop, xBottom, yBottom; 
  PImage bill;
  color fishColor;
  int arrayCounter;
  int fishSize = 66;  //this must be divisible by 6
  
  int arrayPosition;  //what order it was called in
  int yText;  //what is the y position of the item on the list 
  PFont ArialSmall;
  //end fish items
  
  //Items to move to Currencies
  boolean isSelected;
  String fishCode;

  //constructor
Boid(int tempArrayPosition, String tempFishCode, String tempName, int whenToStart, float tempSwimStrength) {
    acc = new PVector(0,0);
    vel = new PVector(random(-1,1),random(-1,1));  
    loc = new PVector(xPond,yPond);
    r = 90;
    c = color(255,255,255,100); 
    onTheMove = false;  //each fish starts out as part of the flock
    getGoing = whenToStart;
    swimStrength = tempSwimStrength; //This will be moved for when fish is On The Move
    fishName = tempName;
    //showvalues = false;
    fishCode = tempFishCode;
    
    fishTimer = 0;
    
    maxspeed = .3;  //these will get changed back and forth depending on if it's on the move
    maxforce = 0.001;   //

     //RENDERING items
     start = random(0,5);
     bill = loadImage(fishName + ".jpg");
     fishColor = bill.get(50, 25);
     fill(fishColor);
     //stroke (0);
     xTop = new float[7]; 
     yTop = new float[7]; 
     xBottom = new float[6]; 
     yBottom = new float[6];
     
     ArialSmall = loadFont("ArialMT-10.vlw");
     arrayPosition = tempArrayPosition;  //now we know what order it should appear at right.
     yText = (arrayPosition*15)+70;  //the name appears on the right side 50n pixels down in the order it was created
     //end rendering items
     
     //Items to move to Currencies
      isSelected = false;
     

  }//end constructor
  
///////////////////////////////////////////////////////
//PATH METHODS//
////////////////////////////////////////////////////////
  
public void runPath() {
    updatePath();
    //borders();
    render();
  }

void follow(Path p) {

    // Predict location 25 (arbitrary choice) frames ahead
    PVector predict = vel.get();
    predict.normalize();
    predict.mult(25);
    PVector predictLoc = PVector.add(loc, predict);

    // Draw the predicted location
    if (debug) {
      fill(0);
      stroke(0);
      line(loc.x,loc.y,predictLoc.x, predictLoc.y);
      ellipse(predictLoc.x, predictLoc.y,4,4);
    }

    // Now we must find the normal to the path from the predicted location
    // We look at the normal for each line segment and pick out the closest one
    PVector target = null;
    PVector dir = null;
    float record = 1000000;  // Start with a very high record distance that can easily be beaten

    // Loop through all points of the path
    for (int i = 0; i < p.points.size()-1; i++) {

      // Look at a line segment
      PVector a = (PVector) p.points.get(i);
      PVector b = (PVector) p.points.get(i+1);

      // Get the normal point to that line
      PVector normal = getNormalPoint(predictLoc,a,b);

      // Check if normal is on line segment
      float da = PVector.dist(normal,a);
      float db = PVector.dist(normal,b);
      PVector line = PVector.sub(b,a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      if (da + db > line.mag()+1) {
        normal = b.get();
      }

      // How far away are we from the path?
      float d = PVector.dist(predictLoc,normal);
      // Did we beat the record and find the closest line segment?
      if (d < record) {
        record = d;
        // If so the target we want to steer towards is the normal
        target = normal;

        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir = line;
        dir.normalize();
        // This is an oversimplification
        // Should be based on distance to path & velocity
        dir.mult(10);
      }
    }
    // Draw the debugging stuff
    if (debug) {
      // Draw normal location
      fill(0);
      noStroke();
      line(predictLoc.x,predictLoc.y,target.x,target.y);
      ellipse(target.x,target.y,4,4);
      stroke(0);
      // Draw actual target (red if steering towards it)
      line(predictLoc.x,predictLoc.y,target.x,target.y);
      if (record > p.radius) fill(255,0,0);
      noStroke();
      ellipse(target.x+dir.x, target.y+dir.y, 8, 8);
    }

    // Only if the distance is greater than the path's radius do we bother to steer
    if (record > p.radius) {
      target.add(dir);
      seek(target);			
    }//end if
  }//end follow
  
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p,a);
    // Vector from a to b
    PVector ab = PVector.sub(b,a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a,ab);
    return normalPoint;
  }//end getnormalPoint
  
  // Method to update location
  void updatePath() {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    
    //now limit the minimum speed to stop guys from getting stuck.
     if (vel.mag() <= .02)  {
       println(arrayPosition + " is too slow!");
       vel.mult(1.05);  //give it a boost!
     }
   
    
    loc.add(vel);
    // Reset accelertion to 0 each cycle
    acc.mult(0);
  }//end updatePath

////////////////////////////////////////////////////////////////
//FLOCKING METHODS//
///////////////////////////////////////////////////////////////

  void runFlock(ArrayList boids) {
    flock(boids);  //calculate forces on the flock as a whole
    update();  //apply forces on each indivisual fish
    //borders();
    render();
    
    fishTimer++; //this whole time, we've been counting down to the next time he gets to play
  }//end runFlock

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion

    // Arbitrarily weight these forces
    sep.mult(swt);
    ali.mult(awt);
    coh.mult(cwt);

    // Add the force vectors to acceleration
    acc.add(sep);
    acc.add(ali);
    acc.add(coh);
  }

  // Method to update location
  void update() {
    
    //check borders only if we aren't already recovering from out of bounds
    //if (xIsOut == false)  {xBorders();}
    //if (yIsOut == false)  {yBorders();}
    
    borders();  //if we've hit a border, set the item to steer towards the center
    
    vel.add(acc);
    // Update velocity
    // Limit speed
    vel.limit(maxspeed);
    loc.add(vel);
    
    // Reset accelertion to 0 each cycle
    acc.mult(0);
    
  }//end update

 
  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList boids) {
    float desiredseparation = 25.0f;
    PVector sum = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = PVector.dist(loc,other.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(loc,other.loc);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }//end if
    }//end for
    // Average -- divide by how many
    if (count > 0) {
      sum.div((float)count);
    }
    return sum;
  }//end separate



  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList boids) {
    PVector sum = new PVector(0,0,0);
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbordist) && (other.onTheMove == false)) {
        sum.add(other.vel);
        count++;
      }//end if
    }//end for
    if (count > 0) {
      sum.div((float)count);
      sum.limit(maxforce);
    }//end if
    return sum;
  }//end align



  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList boids) {
    PVector sum = new PVector(0,0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (int i = 0 ; i < boids.size(); i++) {
      Boid other = (Boid) boids.get(i);
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbordist) && (other.onTheMove == false)) {
        sum.add(other.loc); // Add location
        count++;
      }//end if
    }//end for
    if (count > 0) {
      sum.div((float)count);
      return steer(sum,false);  // Steer towards the location
    }//end if
    return sum;
  }//end cohesian

  
  /*
  void borders() {
    PVector target = new PVector(width/2, height/2);
    PVector temp = steer(target,false);
    
    if (loc.x < r) acc.x = temp.x; //ri is an arbitrary number to let the fish look like they're swimming off screen
    if (loc.y < r) acc.y = temp.y;
    if (loc.x > width-r) acc.x = temp.x;
    if (loc.y > height-r) acc.y =  temp.y;
  }
 
  
    void borders() {
    PVector target = new PVector(xPond, yPond);
    PVector temp = steer(target,false);
    
    if (loc.x < xPond-pondWidth/2 + r) acc.x = temp.x; //if x is less than the edge of the pond, plus the buffer
    if (loc.y < yPond - pondHeight/2 + r) acc.y = temp.y;
    if (loc.x > xPond + pondWidth/2 - r) acc.x = temp.x;
    if (loc.y > yPond + pondHeight/2 - r) acc.y =  temp.y;
  }
   */
 void borders() {
      
      r = 90;
          
      PVector target = new PVector(xPond, yPond);
      PVector temp = steer(target,false);
      
      //fill(150);
      //quad();
      
    
  if (loc.x < xPond-pondWidth/2 + r+25) {
      acc.x = temp.x;
      //println ("Left pond border");
    }
  
    if (loc.y < yPond - pondHeight/2 + r-10) {
      acc.y = temp.y;
       //println ("Top pond border");
    }
    if (loc.x > xPond + pondWidth/2 - r-25) {
      acc.x = temp.x;
       //println ("Right pond border");
    }
    if (loc.y > yPond + pondHeight/2 - r+10) {
      acc.y =  temp.y;
       //println ("Bottom pond border");  
    }
    if (loc.y < yPond - pondHeight/2 + r-175) {  //if they're coming back from the top
      acc.y = temp.y;
      acc.x = temp.x;
       //println ("Out of bounds pond border"); 
    }
    

}//end borders

 
 ///////////////////////////////////////////////////////////////////////////////
 //SHARED METHODS//
 /////////////////////////////////////////////////////////////////////////////
 
  
void render() {
   
    float theta = vel.heading2D() + radians(180);
    
    fill(fishColor);
    
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(theta);
    
    //start fish
    
    
    float wiggle = start;
 
    arrayCounter = 0; // This keeps track of what point we're at as we add info to the top and bottom arrays

    recentx = 0; //set everything to 0 each time through.  This is where 
    recenty = 0;
     currentx = 0;
     currenty = 0;

  //Lets get the x and y coordinates for our fish
   for (int x = 0; x < fishSize; x+= fishSize/6) {  //this would be 150 for a big one or anything divisable by 6), and 25
     
     currentx = x;
     currenty = sin(wiggle)*5;  //the *# controls how much of a wiggle occurs
   
     float xpoint = currentx-recentx;
     float ypoint = currenty-recenty;
   
   //find the points for the top of the fish shape
   
   if (x == 0)  {   //the nose should not move around
       
       //vertex (currentx,currenty);
       
       xTop[arrayCounter] = currentx;  //store the info in the array
       yTop[arrayCounter] = currenty;
       
       xBottom[arrayCounter] = currentx;  
       yBottom[arrayCounter] = currenty;  
       

   }//end if
    
   else{
       
       xTop[arrayCounter] = currentx+ypoint;  //store the info in the array
       yTop[arrayCounter] = currenty-xpoint;
       
       xBottom[arrayCounter] = currentx-ypoint;  //store the info in the array
       yBottom[arrayCounter] = currenty+xpoint;
       
       if (arrayCounter==4){  //a special situatio for the pinch of the tail
         
         xTop[arrayCounter] = currentx+ypoint/4;  //store the info in the array
         yTop[arrayCounter] = currenty-xpoint/4;
       
         xBottom[arrayCounter] = currentx-ypoint/4;  //store the info in the array
         yBottom[arrayCounter] = currenty+xpoint/4;
         
       }//end if
       
       if (arrayCounter ==1) {
           noStroke();
          ellipseMode(CENTER);
          ellipse(currentx, currenty, 22, 22);   
       }//end second if
   }//end else
   
   if (x == (fishSize-(fishSize/6)))  {   //an extra, unmoving point for the end of the tail
       
       xTop[arrayCounter+1] = currentx-3;
       yTop[arrayCounter+1] = currenty;
       
       //ellipse(currentx,currenty, 2, 2);    
   }//end if tail point
   
   recentx = currentx;  //cleanup for the next time
   recenty = currenty;
   
   wiggle += 0.8;  //controlls how fast the wiggle occurs
   arrayCounter++;
   
 }//end for loop to load data
 
   //now draw the fish, background first!

   //stroke (0);
   noStroke();
   beginShape();
 
  //first draw the top half 
   for (int i = 0; i < xTop.length; i++) {  vertex(xTop[i],yTop[i]); }//end for
 
   //now draw the bottom half
   for (int i = xBottom.length-1; i >= 0; i--) { vertex(xBottom[i],yBottom[i]);}
 
   endShape();
 
   //Now draw the bill on top!:
   beginShape();
   texture(bill);

  //first draw the top half

  for (int i = 1; i < 4; i++) { vertex(xTop[i],yTop[i], map(i, 1, 3, 1, 100), 0); }   
 
 //now draw the bottom half
   for (int i = xBottom.length-3; i >= 0; i--) {
     
       if (i==0) {   }
       else if (i==1) {  {vertex(xBottom[i],yBottom[i], 0, 50);} }
       else{vertex(xBottom[i],yBottom[i], map(i, xBottom.length-3, 0, 100, 0), 50);}
     
   }
 
   endShape();
 
   start += 0.06; //move where the sin wave starts from so it moves
  
    //end fish
    popMatrix();
      
    
    //println("about to show values");
    if (showvalues == true) {
      //println("showing values");
      textFont(ArialSmall, 10); 
      fill(0);
      text(fishCode, loc.x, loc.y);
    }
    
  }//end display
  
 //Move to Currencies!
 void renderName(){
   
   if ((yText >= 70)&&(yText <=585)){
     
    fill(255);
    stroke(fishColor);
    ellipseMode(CENTER);
    
    if  (isSelected==true)  {  //if the item has been selected, it gets filled in
      fill(fishColor);
   }
    ellipse(width-120, yText-2, 7, 7);
    
    textFont(ArialSmall, 10); 
    fill(0);
    text(fishName, width-110, yText); 
    
   }//end if
  
 }
 
  
  // A method that calculates a steering vector towards a target
  // Takes a second argument, if true, it slows down as it approaches the target
PVector steer(PVector target, boolean slowdown) {
    // HACK TO STOP ARRIVING
    //slowdown = false;

    PVector steer;  // The steering vector
    PVector desired = PVector.sub(target,loc);  // A vector pointing from the location to the target
    float d = desired.mag(); // Distance from the target is the magnitude of the vector
    // If the distance is greater than 0, calc steering (otherwise return zero vector)
    if (d > 0) {
      // Normalize desired
      desired.normalize();
      // Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if ((slowdown) && (d < 100.0f)) desired.mult(maxspeed*(d/100.0f)); // This damping is somewhat arbitrary
      else desired.mult(maxspeed);
      // Steering = Desired minus Velocity
      steer = PVector.sub(desired,vel);
      steer.limit(maxforce);  // Limit to maximum steering force.  
    } //end if
    else {
      steer = new PVector(0,0);
    }
    return steer;
}//end steer

  
  
void seek(PVector target) {
    acc.add(steer(target,false));
  } //end seek
  
  

void arrive(PVector target) {
    acc.add(steer(target,true));
  }   //end arrive
  
}//end Boid Class
