class Population {

  float mutationRate;          // Mutation rate
  Rocket[] population;         // Array to hold the current population
  int generations;             // Number of generations

  // Initialize the population
  Population(float m, int num) {
    mutationRate = m;
    population = new Rocket[num];
    generations = 0;
    //make a new set of creatures
    for (int i = 0; i < population.length; i++) {
      PVector position = new PVector(width/2, height+20);
      population[i] = new Rocket(position, new DNA(), population.length);
    }
  }

  void live (ArrayList<Obstacle> os) {
    // For every creature
    for (int i = 0; i < population.length; i++) {
      // If it finishes, mark it down as done!
      population[i].checkTarget();
      population[i].run(os);
    }
  }

  // Did anything finish?
  boolean targetReached() {
    for (int i = 0; i < population.length; i++) {
      if (population[i].hitTarget) return true;
    }
    return false;
  }

  // Calculate fitness for each creature
  void fitness() {
    for (int i = 0; i < population.length; i++) {
      population[i].fitness();
    }
  }

  // Making the next generation
  void reproduction() {
    // Refill the population with children from the mating pool
    Rocket[] newPop = new Rocket[population.length];
    for (int i = 0; i < population.length; i++) {

      // Pick two parents
      Rocket mom = acceptReject();
      Rocket dad = acceptReject();
      // Get their genes
      DNA momgenes = mom.getDNA();
      DNA dadgenes = dad.getDNA();
      // Mate their genes
      DNA child = momgenes.crossover(dadgenes);
      // Mutate their genes
      child.mutate(mutationRate);
      // Fill the new population with the new child
      PVector position = new PVector(width/2, height+20);
      newPop[i] = new Rocket(position, child, population.length);
    }
    population = newPop;
    generations++;
  }

  Rocket acceptReject() {
    while (true) {
      int index = floor(random(population.length));
      float r = random(getMaxFitness());
      Rocket partner = population[index];
      if (r < partner.fitness)  
        return partner;
    }
  }

  int getGenerations() {
    return generations;
  }

  // Find highest fintess for the population
  float getMaxFitness() {
    float record = 0;
    for (int i = 0; i < population.length; i++) {
      if (population[i].getFitness() > record) {
        record = population[i].getFitness();
      }
    }
    return record;
  }
}