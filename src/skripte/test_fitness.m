close all;
x = 161; % x = 15*self.carx/bit_max - 7.5; (x + 7.5) * 255 / 15 = carx
y = 153; % y = 5*self.cary/bit_max - 1; (y + 1) * 255 / 5 = cary
angle = 32; % angle = 2*pi*self.carangle/bit_max; angle * 255 / (2 * pi) = carangle
length = 0;
depth = 0;
chr = Chromosome(x, y, angle, length, depth);

fitness_func = FitnessFactory.get_distance_to_trajectory();

fitness_value = fitness_func(chr);
sc = chr.get_scenario();
sc.RunParkingPilot();
sc.Replay(0.04, 3);