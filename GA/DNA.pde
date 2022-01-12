class DNA {

  // The jeantic sequence
  boolean[] jeans;
  boolean RB;
  int randomNUM;
  public float fitness;
  public String recordjeans;

  // Constructor (makes a random DNA)
  DNA(int num) {
    jeans = new boolean[num];
    for (int i = 0; i < jeans.length; i++) {
      randomNUM = (int)random(0, 10);
      if (randomNUM <= 5) {
        jeans[i]=false;
      } else {
        jeans[i] = true;  // Pick from range of chars
      }
    }
  }

  // Converts character array to a String
  /*
  String getPhrase() {
   return new String(jeans);
   }
   */
  // Fitness function (returns floating point % of "correct" characters)
  void fitness () {
    int localscore = 0;
    int localweight = 0;
    for (int i = 0; i < jeans.length; i++) {
      if (jeans[i] == true) { 
        localscore += objects[i].y;
        localweight += objects[i].x;
      }
    }
    if (localweight > 5000)
    { 
      fitness = 0;
    } else {

      fitness = (float)localscore;
    }
    
  }
  
  String components(){
    String binaryjeans = "";
    for(int i=0; i<jeans.length; i++){
      if(jeans[i])
      binaryjeans += '1';
      else
      binaryjeans += '0';
    }
    recordjeans = (String)binaryjeans;
    return recordjeans;
  }

  // Crossover
  DNA crossover(DNA partner) {
    // A new child
    DNA child = new DNA(jeans.length);

    int midpoint = int(random(jeans.length)); // Pick a midpoint

    // Half from one, half from the other
    for (int i = 0; i < jeans.length; i++) {
      if (i > midpoint) child.jeans[i] = jeans[i];
      else              child.jeans[i] = partner.jeans[i];
    }
    return child;
  }

  // Based on a mutation probability, picks a new random character
  void mutate(float mutationRate) {
    for (int i = 0; i < jeans.length; i++) {
      if (random(1) < mutationRate) {
        randomNUM = (int)random(0, 1);
        if (randomNUM ==1) {
          jeans[i]=false;
        } else {
        }
        jeans[i] = true;  // Pick from range of chars
      }
    }
  }
}
