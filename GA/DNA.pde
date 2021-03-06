class DNA {

  // The genetic sequence
  boolean[] genes;
  boolean RB;
  int randomNUM;
  public float fitness;
  public String recordGenes;

  // Laver en tilfældig DNA 
  DNA(int num) {
    genes = new boolean[num];
    for (int i = 0; i < genes.length; i++) {
      randomNUM = (int)random(0, 10); //Laver en 50/50 chance for at den er sand eller falsk
      if (randomNUM <= 5) { 
        genes[i]=false; // IKke i rægsækken
      } else {
        genes[i] = true;  //er i rygsækken
      }
    }
  }


  // Fitness funktion (returner int)
  void fitness () {
    int localscore = 0;
    int localweight = 0;
    for (int i = 0; i < genes.length; i++) {
      if (genes[i] == true) { 
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
    String binaryGenes = "";
    for(int i=0; i<genes.length; i++){
      if(genes[i])
      binaryGenes += '1';
      else
      binaryGenes += '0';
    }
    recordGenes = (String)binaryGenes;
    return recordGenes;
  }

  // Crossover
  DNA crossover(DNA partner) {
    // A new child
    DNA child = new DNA(genes.length);

    int midpoint = int(random(genes.length)); // Pick a midpoint

    // Half from one, half from the other
    for (int i = 0; i < genes.length; i++) {
      if (i > midpoint) child.genes[i] = genes[i];
      else              child.genes[i] = partner.genes[i];
    }
    return child;
  }

  // Based on a mutation probability, picks a new random character
  void mutate(float mutationRate) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < mutationRate) {
        randomNUM = (int)random(0, 1);
        if (randomNUM ==1) {
          genes[i]=false;
        } else {
        }
        genes[i] = true;  // Pick from range of chars
      }
    }
  }
}
