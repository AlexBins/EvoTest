% manually derived
i = 1;
population = Chromosome.from_physical(5, 0, 0, 2.5, 1); % start right and collide
i = i+1;
population(i) = Chromosome.from_physical(-5, 0, 0, 2.5, 1); % start left and collide
i = i+1;
population(i) = Chromosome.from_physical(2, 0, -pi/2, 2.5, 1); % heading to boundary & collide
i = i+1;
population(i) = Chromosome.from_physical(4, 0, 0, 2.5, 1); % right and almost collide
i = i+1;
population(i) = Chromosome.from_physical(-4, 0, 0, 2.5, 1); % left and almost collide
i = i+1;
population(i) = Chromosome.from_physical(0, 4, 0, 2.5, 1); % start at top, almost colide
i = i+1;
population(i) = Chromosome.from_physical(0, 0, 0, 5, 2); % wierd parking
i = i+1;
population(i) = Chromosome.from_physical(2.5, 0, pi, 5, 1); % bad left hand side parking and collision
i = i+1;
population(i) = Chromosome.from_physical(-2.5, 0, pi, 5, 1); % bad left hand side parking
i = i+1;
population(i) = Chromosome.from_physical(2, 0, 0, 5, 1); % bad left hand side parking

fit = FitnessFactory.get_combined(FitnessFactory.get_desired_mindistance(1, 0.05), FitnessFactory.get_min_parking_slot(), FitnessFactory.get_min_distance_start());
for i=1:length(population)
    population(i).fitness = fit(population(i));
    fprintf('New fitness: %f\n', population(i).fitness);
end