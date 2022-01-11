Boolean simulate = false;

PFont f;
int score;
int weight;
int popmax;
float mutationRate;
Population population;
PVector objects[];
boolean firsttime = false;

ArrayList<TextBox> textBoxes = new ArrayList<TextBox>();
ArrayList<Button> buttons = new ArrayList<Button>();

Button Start, Save;
TextBox populationTB, mutationRateTB;

void setup() {
  frameRate(400);
  fullScreen();
  f = createFont("Courier", 32, true);
  popmax = 150;

  populationTB = new TextBox(new PVector(350, 50), new PVector(400, 70));
  mutationRateTB = new TextBox(new PVector(350, 150), new PVector(400, 70));
  textBoxes.add(populationTB);
  textBoxes.add(mutationRateTB);

  Start = new Button(new PVector(1000, 60), new PVector(150, 50), 20, color(0, 0, 255), color(0, 0, 180), color(200, 200, 255), "Start", 50);
  Save = new Button(new PVector(800, 60), new PVector(150, 50), 20, color(0, 0, 255), color(0, 0, 180), color(200, 200, 255), "Save", 50);
  buttons.add(Start);
  buttons.add(Save);

  mutationRate = 0.1; 
  mutationRateTB.Text = String.valueOf(mutationRate*100);
  populationTB.Text = String.valueOf(popmax);

  objects = new PVector[24];
  objects[0] = new PVector(90, 150);
  objects[1] = new PVector(130, 35);
  objects[2] = new PVector(1530, 200);
  objects[3] = new PVector(500, 160);
  objects[4] = new PVector(150, 60);
  objects[5] = new PVector(680, 45);
  objects[6] = new PVector(270, 60);
  objects[7] = new PVector(390, 40);
  objects[8] = new PVector(230, 30);
  objects[9] = new PVector(520, 10);
  objects[10] = new PVector(110, 70);
  objects[11] = new PVector(320, 30);
  objects[12] = new PVector(240, 15);
  objects[13] = new PVector(480, 10);
  objects[14] = new PVector(730, 40);
  objects[15] = new PVector(420, 70);
  objects[16] = new PVector(430, 75);
  objects[17] = new PVector(220, 80);
  objects[18] = new PVector(70, 20);
  objects[19] = new PVector(180, 12);
  objects[20] = new PVector(40, 50);
  objects[21] = new PVector(300, 10);
  objects[22] = new PVector(900, 1);
  objects[23] = new PVector(2000, 150);

  // Create a populationation with a target phrase, mutation rate, and populationation max
  population = new Population(mutationRate, popmax);
}

void mousePressed() {
  for (Button b : buttons) b.pressed();
  for (TextBox t : textBoxes) t.pressed(mouseX, mouseY);
}

void keyPressed() {
  for (TextBox t : textBoxes) {
    if (t.keyWasTyped(key, (int)keyCode));
  }
}

void draw() {
  background(255);

  if (Start.clicked) {
    simulate = !simulate;
    firsttime = true;
  }

  if (Save.clicked) {
    simulate = false;
    firsttime = false;
    mutationRate = float(mutationRateTB.Text + "f")/100;
   // println(mutationRate);
    popmax = int(populationTB.Text);
    population = new Population(mutationRate, popmax);
  } //<>//

  if (simulate) {

    if (int(populationTB.Text) != 0) {
      Start.Text = "Stop";
      Start.col = color(255, 0, 0);
      Start.overCol = color(180, 0, 0);

      // Generate mating pool
      population.naturalSelection();
      //Create next generation
      population.generate();
      // Calculate fitness
      population.calcFitness();
      population.getGenes();
      displayInfo();

      // If we found the target phrase, stop
      if (population.finished()) {
        println(millis()/1000.0);
        noLoop();
      }
      Graph();
    } else {
      fill(255, 0, 0);
      text("Error: Please Type Population Size", 300, 350);
      fill(0);
    }
  } else {
    Start.Text = "Start";
    Start.col = color(0, 0, 255);
    Start.overCol = color(0, 0, 180);
    displayInfo();
  }

  textSize(48);
  text("Population:", 0, populationTB.position.y+50);
  text("Mutation Rate:", 0, mutationRateTB.position.y+50);
  text("%", mutationRateTB.position.x+mutationRateTB.size.x+10, mutationRateTB.position.y+50);

  for (TextBox t : textBoxes) t.display();
  for (Button b : buttons) b.display();
}

void graph() {
  for (int i =0; i<population.population.length; i++) {
    circle(population.getGenerations(), population.population[i].fitness, 10);
  }
}

void displayInfo() {
  pushMatrix();
  translate(width/2, height/2);
  
  background(255);
  // Display current status of populationation

  //textFont(f);
  textAlign(LEFT);
  fill(0);


  textSize(24);
  text("Score:", 300, -500);
  textSize(40);
  textSize(18);
  text("Total generations:     " + population.getGenerations(), 300, -440);
  if (firsttime == true){
  text("Average fitness:        " + nf(population.getAverageFitness(), 0, 2), 300, -420);
  text("Best score:                " + worldrecord, 300, -380);
  }
  else {
  text("Average fitness:        " + 0, 300, -420);
  text("Best score:                " + 0, 300, -380);
  }
  text("Total population:      " + popmax, 300, -400);
  text("Mutation rate:           " + mutationRate * 100 + "%", 300, -360);
  text("Binary genecode:       "+ recordGenes, 300, -340);
  
  textSize(10);

  translate(0, 0);
  popMatrix();
}

void Graph() {
  fill(0);
  textSize(10);

  //1. akse
  rect(180, height-170, width-380, 1);
  triangle(width-200, height-170, width-220, height-180, width-220, height-160);
  for (int i = 200; i<width-975; i+=25) {
    rect(2*i-200, height-175, 1, 10);
    text(i-200, 2*i-195, height-155);
  }

  //2. akse
  rect(200, 250, 1, height-400);
  triangle(210, 270, 200, 250, 190, 270);
  for (int i = height-170; i>270; i-=25) {
    rect(195, i, 10, 1);
    text(2*(910-i), 160, i);
  }

  textSize(30);
  text("generationer", width-400, height-100);
  text("værdi", 50, 300);
}
