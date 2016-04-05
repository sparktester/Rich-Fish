//this is the class that will direct each fish in what to do by calling the apooropriate functions.  
//It also displays the background prettyness

//Universal constants for MN

int xPond;
int yPond;
int pondWidth;
int pondHeight;

//splash
ParticleSystem ps1;
ParticleSystem ps2;
ParticleSystem ps3;

//smoke
SParticleSystem ps;
Random generator;



class Mother_Nature {
  
  int ripple, ripple2;
  
  boolean  mouseIsInTheHouse;
  int menuHeight;
  PFont Arial;
  
  color topArrowColor;
  color bottomArrowColor;
  
   PImage fishBack;
   PImage fishFront;
  
Mother_Nature() {
  
   fishBack = loadImage("fish_back.gif");
   fishFront = loadImage("fish_front.gif");
    
  xPond = 610;
  yPond= 480;
  pondWidth = 410;
  pondHeight = 200;
  
  topArrowColor=color(100);
  bottomArrowColor= color(255);
  
  Arial = loadFont("BerlinSansFB-Reg-18.vlw");
  
  mouseIsInTheHouse = false;  //this keeps track of if the user is selecting new fish!
  menuHeight = 0;
  
   //splashes
   ps1 = new ParticleSystem(320, 310, 320, 365, 3, 3, 440);  //xMin, yMin, xMax, yMax, xSpeedMin, xSpeed, yStop
   ps2 = new ParticleSystem(505, 90, 505, 115, -3, -3, 185);  //xMin, yMin, xMax, yMax, xSpeed, yStop
   ps3 = new ParticleSystem(665, 200, 750, 200, -1, 0, 365);  //xMin, yMin, xMax, yMax, xSpeed, yStop
   
   //This is smoke particle System stuff - move to separate function
  generator = new Random();
  // Create an alpha masked image to be applied as the particle's texture
  PImage msk = loadImage("texture.gif");
  PImage img = new PImage(msk.width,msk.height);
  for (int i = 0; i < img.pixels.length; i++) img.pixels[i] = color(255);
  img.mask(msk);
  ps = new SParticleSystem(0,new PVector(width/2,height-20),img);
  
//splashes

  ripple = 40;
  ripple2 = 110;
  

  }//end constructor
  
void display() { 
    
   image(fishBack, 0, 0);
 
  //fill(255); //why isn't this smooth?
  //ellipse(xPond, yPond, pondWidth, pondHeight);
  
  //we could perhaps move this to a new function called mn.runSplash.  but whatever.
  ps1.run();
  ps1.addParticle();
  ps2.run();
  ps2.addParticle();
  ps3.run();
  ps3.addParticle();
  
}//end display

void displayFront(){
  image(fishFront, 0, 0);
  
  //now display the splashes
  strokeWeight(3);
   noFill();
   ellipseMode(CORNER);
   stroke (255, 230-ripple);
   ellipse (475-ripple/3, 450-ripple/5, ripple, ripple/2);
   stroke (255, 230-ripple2);
   ellipse (475-ripple2/3, 450-ripple2/5, ripple2, ripple2/2);
   ellipseMode(CENTER);
   
   ripple= ripple+1;
   ripple2= ripple2+1;
   
   if (ripple >= 230) {
     ripple = 40;
   }
   
   if (ripple2 >= 230) {
     ripple2 = 40;
   }
  
}

void run() {    
  
    for (int i = 0; i < boids.size(); i++) {
      Boid b = (Boid) boids.get(i);
      
      if (b.onTheMove) {  //if the fish is on the move
        b.follow(path);
        b.runPath();
        
        //check if its time to put him back in the pond!
        if ((b.loc.x > (width-260)) && (b.loc.y < 200))   {  //change this depending on where the end is!
          
          b.maxspeed = .3; //set the swim strength back to normal
          b.onTheMove = false;
          //change his maxSpeed back to .3
          
          b.fishTimer = -b.getGoing-(60*10); //set the new fishtimer to twice the old one, plus 10 secs
          
          //println("Fish " + i + " - OnThe Move: " + b.onTheMove + " - Max Speed: " + b.maxspeed);
          
        }//end if its the end of the line
        
      }//end if onTheMove
      
      else{
        b.runFlock(boids); 
      
        //check if its time to put him onTheMove!
        if (b.fishTimer==b.getGoing){  
          
          b.maxspeed = b.swimStrength;  //change his speed
          b.onTheMove = true; //send him off!
          //change his maxSpeed to his currencyStrength
          
          //println("Fish " + i + " - OnThe Move: " + b.onTheMove + " - Max Speed: " + b.maxspeed);
        
         }//end if
  
      }//end else
         
    }//end for
    
     
   
  }//end run
  
 void menu()  {  
   noStroke();
   fill(200, 200);
   
  //first, make sure they're clicking in the right spot
    if ((mouseX > width-180) && (mouseY < 100)){  
      mouseIsInTheHouse = true;
    }//end if
    
    if (mouseX < width-180){  //every time through, make sure they're no longer selecting fish
      mouseIsInTheHouse = false;
      //println(menuHeight);
      }//end if
    
    if (mouseIsInTheHouse==true) {
      
      rect(width-180, 0, 180.0, menuHeight);
      menuHeight = menuHeight+12;
      menuHeight = constrain(menuHeight, 40, height);
       //println(menuHeight);
    }//end if
    
    else { 
       menuHeight = menuHeight-12;
      menuHeight = constrain(menuHeight, 40, height);
      rect(width-180, 0, 180.0, menuHeight);
    }
   
   //the text at the top
    fill(100);
    stroke(100);
    strokeWeight(3);   
    textFont(Arial, 18); 
    text("Add a Fish", width-134, 25);
    
    //now the cute little arrows
    line(width-154, 15, width-147, 22);
    line(width-147, 22, width-140, 15);
    line(width-154, 19, width-147, 26);
    line(width-147, 26, width-140, 19);
    
    line(width-49, 15, width-42, 22);
    line(width-42, 22, width-35, 15);
    line(width-49, 19, width-42, 26);
    line(width-42, 26, width-35, 19);
    strokeWeight(2);  //set it back
    
    //Now go through the arraylist of Currencies and render thier names! 
    if (menuHeight >= height) {  //only when we have a full menu
      
      stroke(topArrowColor);
      triangle(width - 75, 42, width-65, 57, width-85, 57);    //top arrow
      
      stroke(bottomArrowColor);
      triangle(width - 75, 607, width-65, 592, width-85, 592);    //bottom arrow
      
      
      for (int i = 0; i < currencies.size(); i++) {  //this is what is slowing down the loop.  fuck.
        
        Currency c = (Currency) currencies.get(i); 
       
        c.render();
     
      }//enbd for
    }//end if
    strokeWeight(1);  //set it back
   
  }//end menu
  
void mouseLogicMap (int tMouseX, int tMouseY)  {  //I'm not actually using these, I'm just getting it straight from the source
  
  //evrything here should only work if the mouseIsInTheHouse!
  
  if (mouseIsInTheHouse==true)  {
   
    
    //Are they clicking on the list?  If so, find out where!
        if ((mouseX > width-180 ) && (mouseY >= 60) && (mouseY <= 590))  {    //if they're clicking on the list
          
          float tempMouseY = float(mouseY);
        
          float clickIndex = ((tempMouseY)/15)*15;
        
          //println ("Click Index: " + clickIndex);
        
           for (int i = 0; i < currencies.size(); i++) {
              Currency c = (Currency) currencies.get(i);
             
             if ((clickIndex >= (c.yText)-10)&&(clickIndex <= (c.yText+5))) {
               
               //make that fish selected, baby!  This will, among other things, color in the circle.
               println ("Fish " + i + " Has been selected");
               c.isSelected = !(c.isSelected);
               
               //now, create or destroy the fish depending on what's the deal with isSelected.
               if (c.isSelected ==true){
    
                  flock.addBoid(new Boid(i, c.fishName, c.fishName, c.getGoing, c.swimStrength));  
                 
               }
               
               else {
    
                  flock.removeBoid(i);  //take it off the boids arraylist
                 
               }
                 
               
             }  //end if
          }//end for
        }//end if they're clicking on the list
    
  strokeWeight(1); 
  
  //check if the top triangle has been triggered
   if ((mouseX <= width-65) && (mouseX >= width-85) && (mouseY >= 42) && (mouseY <= 57))  //the first triangle has been triggered
        {  
         
          Currency f = (Currency) currencies.get(0); 
             if (f.yText < 70 ){  //if the first fish name is still above the arrow
           
            topArrowColor = color(255);
            bottomArrowColor = color(255);
            
            
            for (int i=0; i< currencies.size() ; i++){  
               Currency c = (Currency) currencies.get(i);  
               c.yText = c.yText + 15; 
            }  //end for
         }//end if the last item is already visible
        else {
           topArrowColor = color(100);
           //println("you've already reached the bottom of the list!");
        }
     }//end if first triangle
     
     
   //check if the bottom triangle has been triggered
   if ((mouseX <= width-65) && (mouseX >= width-85) && (mouseY >= 592) && (mouseY <= 607))  //the first triangle has been triggered
        {  
        
         Currency f = (Currency) currencies.get((currencies.size())-1); 
         //println(boids.size()-1);
         if (f.yText > 585 ){  //if the last fish name is still below the arrow

            bottomArrowColor = color(255);
            topArrowColor = color(255);
             

          for (int i=0; i< currencies.size() ; i++){  
           Currency c = (Currency) currencies.get(i);  
           c.yText = c.yText - 15; 
          }  //end for
          
        }//end if the fish is not yet visible
        
         else {
           bottomArrowColor = color(100);
           //println("you've reached the top of the list!");
        }  //end else
     }//end if second triangle
  
  }//end mouseIsInTheHouse!
  
}//end mouselogic function
  
}//end class




