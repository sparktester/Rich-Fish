//this class controls the overall list of currencies and their listing in the menu.
class Currency {
  
  //Items to pass to Boid
  
  String fishName;
  String fishCountry;
  int getGoing; //a frame on which he should set out
  float swimStrength;
  int arrayPosition;  //what order it is in Currency
  
  //Items Boid doesn't care about, or can get again
  int yText;  //what is the y position of the item on the list 
  PFont ArialSmall;
  boolean isSelected;
  PImage bill;
  color fishColor;
  float maxspeed;  //max speed  these will get changed back and forth depending on if it's on the move
  float maxforce;   //max force..does not have to be here!
  //end fish items
  
  

  //constructor
Currency(int tempArrayPosition, String tempName, String tempCountry, int whenToStart, float tempSwimStrength) {
    
    getGoing = whenToStart;
    swimStrength = tempSwimStrength; //This will be moved for when fish is On The Move
    fishName = tempName;
    fishCountry = tempCountry;
    

     bill = loadImage(fishName + ".jpg");
     fishColor = bill.get(50, 25);
     //fill(fishColor);
     println (fishColor);
    
     ArialSmall = createFont("Arial",10,true);//loadFont("ArialMT-10.vlw");
     arrayPosition = tempArrayPosition;  //now we know what order it should appear at right.
     yText = (arrayPosition*15)+70;  //the name appears on the right side 70n pixels down in the order it was created
     //end rendering items
     
     //Items to move to Currencies
      isSelected = false;
     
  }//end constructor
  
 void render(){
   
   if ((yText >= 70)&&(yText <=585)){
     
    fill(fishColor);
    stroke(fishColor);
    strokeWeight(3);
    ellipseMode(CENTER);
    
    if  (isSelected==true)  {  //if the item has been selected, it gets filled in
      fill(255);
   }
    ellipse(width-150, yText-2, 7, 7);
    
    textFont(ArialSmall, 10); 
    fill(0);
    text(fishCountry, width-140, yText); 
    
   }//end if
  
 }//end render

 
  
}//end Boid Class
