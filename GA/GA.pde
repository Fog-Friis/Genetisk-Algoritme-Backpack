Boolean simulate = false;

PFont f;
String target;
int popmax;
float mutationRate;
Population population;

Button Simulate;

void setup() {
  size(640, 360);
  f = createFont("Courier", 32, true);
  target = "To be or not to be.";
  popmax = 150;
  mutationRate = 0.01;

  Simulate = new Button(new PVector(width / 2, height / 2), new PVector(100, 50), 10, color(0, 0, 255), color(0, 0, 180), color(200, 200, 255), "simulate", 20);

  // Create a populationation with a target phrase, mutation rate, and populationation max
  population = new Population(target, mutationRate, popmax);
}

void mousePressed() {
  Simulate.pressed();
}

void draw() {

  if (Simulate.clicked) {
    simulate = !simulate;
  }

  println(Simulate.clicked);

  if (simulate) {
    // Generate mating pool
    population.naturalSelection();
    //Create next generation
    population.generate();
    // Calculate fitness
    population.calcFitness();
    displayInfo();

    // If we found the target phrase, stop
    if (population.finished()) {
      println(millis()/1000.0);
      noLoop();
    }
  }
  Simulate.display();
}

void displayInfo() {
  background(255);
  // Display current status of populationation
  String answer = population.getBest();
  textFont(f);
  textAlign(LEFT);
  fill(0);


  textSize(24);
  text("Best phrase:", 20, 30);
  textSize(40);
  text(answer, 20, 100);

  textSize(18);
  text("total generations:     " + population.getGenerations(), 20, 160);
  text("average fitness:       " + nf(population.getAverageFitness(), 0, 2), 20, 180);
  text("total population: " + popmax, 20, 200);
  text("mutation rate:         " + int(mutationRate * 100) + "%", 20, 220);

  textSize(10);
  text("All phrases:\n" + population.allPhrases(), 500, 10);
}
