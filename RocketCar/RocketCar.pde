int lifetime;  // How long should each generation live

Population population;  // Population

int lifeCounter;          // Timer for cycle of generation
int simSpeed = 5;
float maxFitnessGlobal =0.0;

PVector target;        // Target position

void setup() {
  size(640, 360);
  // The number of cycles we will allow a generation to live
  lifetime = height/simSpeed;

  // Initialize variables
  lifeCounter = 0;

  target = new PVector(width/2, 24);

  // Create a population with a mutation rate, and population max
  float mutationRate = 0.001;
  population = new Population(mutationRate, 50);
}

void draw() {
  background(255);
  
  // Draw the start and target positions
  fill(0);
  ellipse(target.x, target.y, 24, 24);

  
  // If the generation hasn't ended yet
  if (lifeCounter < lifetime) {
    population.live();
    lifeCounter++;
    // Otherwise a new generation
  } else {
    lifeCounter = 0;
    population.fitness();

    population.selection();
    population.reproduction();
  }

  // Display some info
  fill(0);
  text("Generation #    : " + population.getGenerations(), 10, 18);
  text("Cycles left     : " + (lifetime-lifeCounter), 10, 36);
  text("Maximum Fitness : " + maxFitnessGlobal, 10, 54);

  text("Simulation speed : " + (simSpeed), 10, height-18);
}

// Move the target if the mouse is pressed
// System will adapt to new target
void mousePressed() {
  target.x = mouseX;
  target.y = mouseY;
}