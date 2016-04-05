ArrayList boids;    // An arraylist for all the boids
ArrayList currencies;

class Flock {

Flock() {
    boids = new ArrayList();              // Initialize the arraylist
    currencies = new ArrayList();              // Initialize the arraylist
  }

  void addCurrency(Currency c) {  //Add a currency to the menu
    currencies.add(c);
  }//end addCurrency

  void addBoid(Boid b) {    //Add a fish to the pond
    boids.add(b);
  }
  
  void removeBoid(int removeCurrency) {    //remove a fish from the pond
    
    for (int i = 0; i < boids.size(); i++) {
      Boid b = (Boid) boids.get(i);
      
      if (b.arrayPosition==removeCurrency) {
         boids.remove(b); 
      }//end if
    }//end for
  }//end removeBoid

}  //end class
