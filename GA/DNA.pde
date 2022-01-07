// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Genetic Algorithm, Evolving Shakespeare

// A class to describe a psuedo-DNA, i.e. genotype
//   Here, a virtual organism's DNA is an array of character.
//   Functionality:
//      -- convert DNA into a string
//      -- calculate DNA's "fitness"
//      -- mate DNA with another set of DNA
//      -- mutate DNA


class DNA {

  // The genetic sequence
  boolean[] genes;
  boolean RB;
  int randomNUM;
  float fitness;

  // Constructor (makes a random DNA)
  DNA(int num) {
    genes = new boolean[num];
    for (int i = 0; i < genes.length; i++) {
      randomNUM = (int)random(0, 1);
      if (randomNUM ==1) {
        genes[i]=false;
      } else {
      }
      genes[i] = true;  // Pick from range of chars
    }
  }

  // Converts character array to a String
  /*
  String getPhrase() {
   return new String(genes);
   }
   */
  // Fitness function (returns floating point % of "correct" characters)
  void fitness (int score) {
    int localscore = 0;
    int localweight = 0;
    for (int i = 0; i < genes.length; i++) {
      if (genes[i] == true) { 
        localscore += objects[i].x;
        localweight += objects[i].y;
      }
    }
    if (localweight > 5000)
    { 
      fitness = 0;
    } else {

      fitness = (float)localscore;
    }
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
