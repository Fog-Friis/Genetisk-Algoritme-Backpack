import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GA extends PApplet {

Boolean simulate = false, paused = false;
PImage logo;
PFont f;
int popmax;
float mutationRate;
Population population;
PVector objects[];
boolean firsttime = true;

ArrayList<TextBox> textBoxes = new ArrayList<TextBox>();
ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<Datapoint> datapoints = new ArrayList<Datapoint>();
ArrayList<Datapoint> datapoints2 = new ArrayList<Datapoint>();

Button Start, Save, Pause;
TextBox populationTB, mutationRateTB;

public void setup() {
  frameRate(400);
  
  f = createFont("Courier", 32, true);
  popmax = 150;
  logo = loadImage("minilogo.jpg");
  populationTB = new TextBox(new PVector(350, 50), new PVector(400, 70));
  mutationRateTB = new TextBox(new PVector(350, 150), new PVector(400, 70));
  textBoxes.add(populationTB);
  textBoxes.add(mutationRateTB);

  Start = new Button(new PVector(1000, 60), new PVector(150, 50), 20, color(0, 0, 255), color(0, 0, 180), color(200, 200, 255), "Start", 50);
  Save = new Button(new PVector(800, 60), new PVector(150, 50), 20, color(0, 0, 255), color(0, 0, 180), color(200, 200, 255), "Save", 50);
  Pause = new Button(new PVector(1000, 160), new PVector(150, 50), 20, color(0, 0, 255), color(0, 0, 180), color(200, 200, 255), "Pause", 50);
  buttons.add(Start);
  buttons.add(Save);
  buttons.add(Pause);

  mutationRate = 0.1f; 
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

  //Laver en populationation med en mutation rate and populationation størrelse
  // population = new Population(mutationRate, popmax);
}

public void mousePressed() {
  for (Button b : buttons) b.pressed();
  for (TextBox t : textBoxes) t.pressed(mouseX, mouseY);
}

public void keyPressed() {
  for (TextBox t : textBoxes) {
    if (t.keyWasTyped(key, (int)keyCode));
  }
}

public void draw() {
  background(255);

  if (Start.clicked) {
    simulate = !simulate;
    firsttime = true;
    paused = false;
    Pause.Text = "Pause";
  }

  if (Save.clicked) {
    worldrecord = 0;
    simulate = false;

    firsttime = true; 
    mutationRate = PApplet.parseFloat(mutationRateTB.Text + "f")/100; 
    popmax = PApplet.parseInt(populationTB.Text);
  } 



  if (Pause.clicked) {
    paused = !paused;
  }

  if (simulate) {

    if (!paused) {
      if (firsttime == true) {
        worldrecord = 0;
        population = new Population(mutationRate, popmax);
        firsttime = false;
      }
      if (PApplet.parseInt(populationTB.Text) != 0) {
        Start.Text = "Stop";
        Start.col = color(255, 0, 0);
        Start.overCol = color(180, 0, 0);

        // Generate mating pool

        population.naturalSelection();
        //Create next generation
        population.generate();
        // Udregner fitness og laver nye gener
        population.calcFitness();
        population.getGenes();
        //Opdatter infomartion

        displayInfo();

        // If population finished
        if (population.finished()) {
          println(millis()/1000.0f);
          noLoop();
        }
        Graph();
      } else {
        fill(255, 0, 0);
        text("Error: Please Type Population Size", 300, 350);
        fill(0);
      }
      Pause.textSize = 50;
      Pause.Text = "Pause";
    } else {
      Pause.textSize = 35;
      Pause.Text = "Unpause";
      Graph();
      displayInfo();
    }
  } else {
    datapoints.clear();
    datapoints2.clear();
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
  fill(0,0,255);
  for (Datapoint d : datapoints) d.display();
  fill(255,0,0);
  for (Datapoint d : datapoints2) d.display();
  fill(255);
}

public void graph() {
  for (int i =0; i<population.population.length; i++) {
    circle(population.getGenerations(), population.population[i].fitness, 10);
  }
}

public void displayInfo() {
  pushMatrix();
  translate(width/2, height/2);

  //background(255);
  // Display current status of populationation

  //textFont(f);
  textAlign(LEFT);
  fill(0);


  textSize(24);
  text("Score:", 300, -500);
  textSize(40);
  textSize(18);

  if (firsttime == false) {    
    text("Average fitness:        " + nf(population.getAverageFitness(), 0, 2), 300, -420);
    text("Best score:                " + worldrecord, 300, -380);
    text("Total generations:     " + population.getGenerations(), 300, -440);
  } else {
    recordGenes = "0";
    worldrecord = 0;
    text("Average fitness:        " + 0, 300, -420);
    text("Best score:                " + worldrecord, 300, -380);
  }

  text("Total population:      " + popmax, 300, -400);
  text("Mutation rate:           " + mutationRate * 100 + "%", 300, -360);
  text("Binary genecode:       "+ recordGenes, 300, -340);

  textSize(10);
  image(logo, (1920/2)-150, -541);
  translate(0, 0);
  popMatrix();
}

public void Graph() {
  fill(0);
  textSize(10);

  //1. akse
  rect(180, height-170, width-380, 1);
  triangle(width-200, height-170, width-220, height-180, width-220, height-160);
  for (int i = 200; i<width-975; i+=25) {
    rect(2*i-200, height-175, 1, 10);
    text(10*i/25-80, 2*i-195, height-155);
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

  datapoints.add(new Datapoint(5*population.getGenerations()+200, height-170-PApplet.parseInt(worldrecord)/2));
  datapoints2.add(new Datapoint(5*population.getGenerations()+200, height-170));
}
class Button {

  //buttons position and size
  float scroll;
  PVector pos;
  PVector size;

  //colors
  int col, overCol, pressedCol;

  //radius of circles
  float radius;

  //boxes positions and size
  PVector box1size, box1pos, box2size, box2pos;
  PVector circle1pos, circle2pos, circle3pos, circle4pos;

  //if button is clicked
  boolean clicked;

  //text and textsize
  String Text;
  float textSize;

  //Constructor
  Button(PVector p, PVector s, float r, int col, int ocol, int pcol, String Text, float textSize) {

    this.pos = p;
    this.size = s;
    this.radius = r;
    this.col = col;
    this.overCol = ocol;
    this.pressedCol = pcol;
    this.Text = Text;
    this.textSize = textSize;


    box1pos = new PVector(pos.x, pos.y-radius/2);
    box2pos = new PVector(pos.x-radius/2, pos.y);

    box1size = new PVector(size.x, size.y+radius);
    box2size = new PVector(size.x+radius, size.y);

    circle1pos = new PVector(pos.x, pos.y);
    circle2pos = new PVector(pos.x+size.x, pos.y);
    circle3pos = new PVector(pos.x+size.x, pos.y+size.y);
    circle4pos = new PVector(pos.x, pos.y+size.y);
  }

  //check if mouse is over button
  public boolean over() {
    if ((mouseX <= box1pos.x+box1size.x && mouseX >= box1pos.x && mouseY <= box1pos.y+box1size.y+scroll && mouseY >= box1pos.y+scroll) ||
      (mouseX <= box2pos.x+box2size.x && mouseX >= box2pos.x && mouseY <= box2pos.y+box2size.y+scroll && mouseY >= box2pos.y+scroll) ||
      (dist(mouseX, mouseY-scroll, circle1pos.x, circle1pos.y)<radius/2) ||
      (dist(mouseX, mouseY-scroll, circle2pos.x, circle2pos.y)<radius/2) ||
      (dist(mouseX, mouseY-scroll, circle3pos.x, circle3pos.y)<radius/2) ||
      (dist(mouseX, mouseY-scroll, circle4pos.x, circle4pos.y)<radius/2)) {
      return true;
    } else {
      return false;
    }
  }

  //check if mouse was pressed
  public void pressed() {
    if (over()) {
      clicked = true;
    }
  }
  
  public void released(){
    clicked = false;
  }

  //draw and run the button
  public void display() {   

      noStroke();

      if (clicked) {
        fill(pressedCol);
        clicked=false;
      } else if (over()) {
        fill(overCol);
      } else {
        fill(col);
      }

      //rectangles
      rect(box1pos.x, box1pos.y, box1size.x, box1size.y);
      rect(box2pos.x, box2pos.y, box2size.x, box2size.y);

      //rounded corners
      circle(circle1pos.x, circle1pos.y, radius);
      circle(circle2pos.x, circle2pos.y, radius);
      circle(circle3pos.x, circle3pos.y, radius);
      circle(circle4pos.x, circle4pos.y, radius);

      textAlign(CENTER);
      fill(0, 0, 0);
      textSize(textSize);
      text(Text, pos.x+size.x/2, pos.y+2*textSize/3);
      textAlign(CORNER);
  }
}
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
  public void fitness () {
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
  
  public String components(){
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
  public DNA crossover(DNA partner) {
    // A new child
    DNA child = new DNA(genes.length);

    int midpoint = PApplet.parseInt(random(genes.length)); // Pick a midpoint

    // Half from one, half from the other
    for (int i = 0; i < genes.length; i++) {
      if (i > midpoint) child.genes[i] = genes[i];
      else              child.genes[i] = partner.genes[i];
    }
    return child;
  }

  // Based on a mutation probability, picks a new random character
  public void mutate(float mutationRate) {
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
class Datapoint{
  int x,y;
  Datapoint(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public void display(){
    circle(x,y,3);
  }
}
float worldrecord = 0;
String recordGenes;
class Population {
  float mutationRate;           // Mutation rate
  DNA[] population;             // Array to hold the current population
  ArrayList<DNA> matingPool;    // ArrayList which we will use for our "mating pool"
  String target;                // Target phrase
  int generations;              // Number of generations
  boolean finished;             // Are we finished evolving?
  int perfectScore;

  Population(float m, int num) {
    mutationRate = m;
    population = new DNA[num];
    for (int i = 0; i < population.length; i++) {
      population[i] = new DNA(objects.length);
    }
    calcFitness();
    matingPool = new ArrayList<DNA>();
    finished = false;
    generations = 0;
    
    perfectScore = 1;
  }
  
  public void getGenes() {
    for (int i = 0; i < population.length; i++) {
      population[i].components();
    }
  }

  // Fill our fitness array with a value for every member of the population
  public void calcFitness() {
    for (int i = 0; i < population.length; i++) {
      population[i].fitness();
    }
    wrecord();
  }

  // Generate a mating pool
  public void naturalSelection() {
    // Clear the ArrayList
    matingPool.clear();

    float maxFitness = 0;
    for (int i = 0; i < population.length; i++) {
      if (population[i].fitness > maxFitness) {
        maxFitness = population[i].fitness;
      }
    }

    // Based on fitness, each member will get added to the mating pool a certain number of times
    // a higher fitness = more entries to mating pool = more likely to be picked as a parent
    // a lower fitness = fewer entries to mating pool = less likely to be picked as a parent
    for (int i = 0; i < population.length; i++) {
      
      float fitness = map(population[i].fitness,0,maxFitness,0,1);
      int n = PApplet.parseInt(fitness * 100);  // Arbitrary multiplier, we can also use monte carlo method
      for (int j = 0; j < n; j++) {              // and pick two random numbers
        matingPool.add(population[i]);
      }
    }
  }

  // Create a new generation
  public void generate() {
    // Refill the population with children from the mating pool
    for (int i = 0; i < population.length; i++) {
      int a = PApplet.parseInt(random(matingPool.size()));
      int b = PApplet.parseInt(random(matingPool.size()));
      DNA partnerA = matingPool.get(a);
      DNA partnerB = matingPool.get(b);
      DNA child = partnerA.crossover(partnerB);
      child.mutate(mutationRate);
      population[i] = child;
    }
    generations++;
  }

  public void wrecord() {
    int index;
    for (int i = 0; i < population.length; i++) {
      if (population[i].fitness > worldrecord) {
        index = i;
        worldrecord = population[i].fitness;
        recordGenes = population[i].components();
      }
  }
  return;
}

  // Compute the current "most fit" member of the population

  public boolean finished() {
    return finished;
  }

  public int getGenerations() {
    return generations;
  }

  // Compute average fitness for the population
  public float getAverageFitness() {
    float total = 0;
    for (int i = 0; i < population.length; i++) {
      total += population[i].fitness;
    }
    return total / (population.length);
  }


}
class TextBox {

  //position and size
  PVector position, size;
  float scroll;

  //colors
  public int Background = color(140, 140, 140);
  public int Foreground = color(0, 0, 0);
  public int BackgroundSelected = color(160, 160, 160);
  public int Border = color(30, 30, 30);

  //border
  public boolean BorderEnable = false;
  public int BorderWeight = 1;

  //text and textsize
  public int TEXTSIZE = 48;
  public String Text = "";
  public int TextLength = 0;

  //if button is clicked
  private boolean selected = false;

  TextBox() {
  }
  //constructor
  TextBox(PVector position, PVector size) {
    this.position = position;
    this.size = size;
  }

  //display and run textbox
  public void display() {
    // DRAWING THE BACKGROUND
    if (selected) {
      fill(BackgroundSelected);
    } else {
      fill(Background);
    }

    //  println(Text, protectedText);

    if (BorderEnable) {
      strokeWeight(BorderWeight);
      stroke(Border);
    } else {
      noStroke();
    }

    rectMode(CORNER);

    rect(position.x, position.y, size.x, size.y);

    // DRAWING THE TEXT ITSELF
    fill(Foreground);
    textSize(TEXTSIZE);

    text(Text, position.x + (textWidth("a") / 2), position.y + TEXTSIZE);
  }

  //check if key has been typed
  public boolean keyWasTyped(char KEY, int KEYCODE) {

    if (selected) {
      if (KEYCODE == (int)BACKSPACE) {
        backSpace();
      } else if (KEYCODE == 32) { 
        addText(' ');
      } else if (KEYCODE == (int)ENTER) {
        return true;
      } else {
        // CHECK IF THE KEY IS A LETTER OR A NUMBER
        boolean isKeyCapitalLetter = (KEY >= 'A' && KEY <= 'Ø');
        boolean isKeySmallLetter = (KEY >= 'a' && KEY <= 'ø');
        boolean isKeyNumber = (KEY >= '0' && KEY <= '9');
        boolean isKeySign = (KEY >= 30 && KEY <= 200);


        if (isKeyCapitalLetter || isKeySmallLetter || isKeyNumber || isKeySign) {

          addText(KEY);
        }
      }
    }
    return false;
  }

  //add text to textbox
  private void addText(char text) {    
    if (textWidth(Text+text) < size.x-30) {
      Text += text;
      TextLength++;
    }
  }

  //remove text if backspace is pressed
  private void backSpace() {

    if (TextLength - 1 >= 0) {
      Text = Text.substring(0, TextLength - 1);
      TextLength--;
    }
  }

  //check if mouse is over box
  private boolean overBox(int x, int y) {
    if (x >= position.x && x <= position.x + size.x) {
      if (y >= position.y + scroll && y <= position.y + size.y + scroll) {
        return true;
      }
    }

    return false;
  }

  //check if mouse has been pressed
  public void pressed(int x, int y) {
    if (overBox(x, y)) {
      selected = true;
    } else {
      selected = false;
    }
  }

  //remove all text
  public void clearText() {
    TextLength = 0;
    Text = "";
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "GA" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
