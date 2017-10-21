int lifetime;  // How long should each generation live

Population population;  // Population

int lifecycle;          // Timer for cycle of generation
int recordtime;         // Fastest time to target
int simSpeed = 5, mouseLocX = 0, mouseLocY = 0;

Obstacle target;        // Target position

//int diam = 24;          // Size of target

ArrayList<Obstacle> obstacles;  //an array list to keep track of all the obstacles!

void setup() {
  size(1280, 720);
  // The number of cycles we will allow a generation to live
  lifetime = round(1000/simSpeed*1.5);

  // Initialize variables
  lifecycle = 0;
  recordtime = lifetime;

  target = new Obstacle(width-24, height/2-12, 24, 24);

  // Create a population with a mutation rate, and population max
  float mutationRate = 0.01;
  population = new Population(mutationRate, 200);

  // Create the obstacle course  
  obstacles = new ArrayList<Obstacle>();
  //obstacles.add(new Obstacle(width/2-100, height/2, 200, 40));
}

void draw() {
  background(255);

  // Draw the start and target positions
  target.display();
  // Draw the obstacles
  for (Obstacle obs : obstacles) {
    obs.display();
  }

  // If the generation hasn't ended yet
  if (lifecycle < lifetime) {
    population.live(obstacles);
    if ((population.targetReached()) && (lifecycle < recordtime)) {
      recordtime = lifecycle;
    }
    lifecycle++;
    // Otherwise a new generation
  } else {
    lifecycle = 0;
    population.fitness();
    population.reproduction();
  }  

  // Display some info
  fill(0);
  text("Generation #: " + population.getGenerations(), 10, 18);
  text("Cycles left: " + (lifetime-lifecycle), 10, 36);
  recordtime = lifetime;
  text("Record cycles: " + recordtime, 10, 54);

  if (mousePressed) {
    stroke(0);
    fill(175);
    strokeWeight(2);
    rectMode(CORNER);
    rect(mouseLocX, mouseLocY, mouseX-mouseLocX, mouseY-mouseLocY);
  }
}

// Move the target if the mouse is pressed
// System will adapt to new target

void mousePressed() {
  mouseLocX = mouseX;
  mouseLocY = mouseY;
  println(mouseLocX);
}

void mouseReleased() {
  int tempX = mouseLocX, tempY = mouseLocY;
  if(tempX > mouseX)
    tempX = mouseX;
  if(tempY > mouseY)
    tempY = mouseY;
  
  obstacles.add(new Obstacle(tempX, tempY, abs(mouseX-mouseLocX), abs(mouseY-mouseLocY)));
}