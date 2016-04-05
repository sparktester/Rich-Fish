//particle streams on top
//numbers for fish


import processing.opengl.*;
import simpleML.*;

//for the xml feed
XMLRequest xmlRequest;  //getting the information to initialize particles...with
boolean bodiesReady; 
boolean showName;

//objects
Flock flock;
Mother_Nature mn;
Path path;

//general settings
int scl;//= 8;
PVector center;
PFont f;
boolean showvalues;
boolean debug = false;

int startScreen;

//NOTE: fish and currency arraylists are declared in Flock

void setup() {
  size(950,625,OPENGL);
  //size(950,625, P3D);
   smooth();
   noStroke();
   ellipseMode(CENTER);
   frameRate(60);
   
   fill(0);
   rect(0, 0, width, height); 
   float now = 0.0;
 
   mn = new Mother_Nature();  //set up the scenery
   newPath();  //function that generates a new path item
   flock = new Flock();
   showvalues = false;
  
  //for xml
  xmlRequest = new XMLRequest(this, "http://www.binaryspark.com/Academia/Nature/Midterm/financialGrab.php" );  //make the XML request
  xmlRequest.makeRequest();
  bodiesReady = false;
  
  startScreen = 0;

}//end setup

 

void draw() {
  fill(0);
  rect(0, 0, width, height); 

  mn.display();
  //path.display();  //this can be removed if we want.
  
    //if (bodiesReady == true)  {
    //}

    mn.run(); //this will become mn.run
    mn.displayFront();
    
    ps.run();                     
    ps.addParticle();

    mn.menu();
    
    if (startScreen <= 30) {
      fill(255);
      rect (0, 0, width, height); 
      
      startScreen++;
    }
    
    else if (startScreen <= 60) {
      int opacity = 0-startScreen;
      fill(255, map(opacity, -60, -31,  0, 255));
      rect (0, 0, width, height); 
      
      startScreen++;
    }
    
    else {
      //nothing!
    }

}//end draw


void newPath() {  //this can probably be moved to Path, not inside the class tho
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  path = new Path();
  path.addPoint(530,460);//start
  path.addPoint(450,435);//bottom of first waterfall
  path.addPoint(390,370);//top of first waterfall
  
  path.addPoint(125,320);//bend1 in the curve
  path.addPoint(125,260);//bend2 in the curve
  
  path.addPoint(350,210);//bottom of second waterfall
  path.addPoint(420,140);//top second waterfall
  path.addPoint(695,90);//top final waterfall
  path.addPoint(705,100);//bottom final waterall
}

public void keyPressed() {
  //debug = !debug;
   showvalues = !showvalues;
   println("keys been pressed, showvalues = " + showvalues);
}


void mousePressed() {
  
    mn.mouseLogicMap (mouseX, mouseY);
  
}
 
 
void netEvent(XMLRequest ml) {
  
  // Retrieving an array of all XML elements inside"  title*  "tags
  String[] codes = ml.getElementArray( "code" );
  String[] rates = ml.getElementArray( "rate" );
  String[] names = ml.getElementArray( "description" );
  //for (int i = 0; i < codes.length; i++ ) {  //for testing purposes only
    //println(codes[i]);
    //println(rates[i]);
  //}
  
    //Now, let's make some bodies!
  for (int i = 0; i < codes.length; i++) {                    
    
    float currentRate = float(rates[i]); //get the rate for this article of currency
     //now calculate currentRate so it falls between .09 and .4
     println (currentRate);
     
    currentRate = constrain(40/currentRate, 1, 50);  // invert so the less something is worth, the smaller it is, make sure it's never oto small or too big
    
    currentRate=map (currentRate, 1, 50, .1, .5);  //so we get an even range
    
    String currentName = names[i];
    
    String code = codes[i];

    flock.addCurrency(new Currency(i, code, currentName, int(random (500, 5000)), currentRate));
  
  }//end for 
  
  bodiesReady = true;  //we've got bodies, so we're ready to do something with them

}


