PFont f;
String target;
int popmax;
float mutationRate;
Population population;
PVector objects[];

void setup() {
  size(640, 360);
  f = createFont("Courier", 32, true);
  target = "OH MY GOD, I'm going to cum!";
  popmax = 150;
  mutationRate = 0.01;
  
  objects = new PVector[24];
  objects[1] = new PVector(90,150);
  objects[2] = new PVector(130,35);
  objects[3] = new PVector(1530,200);
  objects[4] = new PVector(500,160);
  objects[5] = new PVector(150,60);
  objects[6] = new PVector(680,45);
  objects[7] = new PVector(270,60);
  objects[8] = new PVector(390,40);
  objects[9] = new PVector(230,30);
  objects[10] = new PVector(520,10);
  objects[11] = new PVector(110,70);
  objects[12] = new PVector(320,30);
  objects[13] = new PVector(240,15);
  objects[14] = new PVector(480,10);
  objects[15] = new PVector(730,40);
  objects[16] = new PVector(420,70);
  objects[17] = new PVector(430,75);
  objects[18] = new PVector(220,80);
  objects[19] = new PVector(70,20);
  objects[20] = new PVector(180,12);
  objects[21] = new PVector(40,50);
  objects[22] = new PVector(300,10);
  objects[23] = new PVector(900,1);
  objects[24] = new PVector(2000,150);

  // Create a populationation with a target phrase, mutation rate, and populationation max
  population = new Population(target, mutationRate, popmax);
}

void draw() {
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

void displayInfo() {
  background(255);
  // Display current status of populationation
  String answer = population.getBest();
  textFont(f);
  textAlign(LEFT);
  fill(0);
  
  
  textSize(24);
  text("Best phrase:",20,30);
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
