close all;
x = 255 / 2; % x = 0
y = 255 / 5; % y = 0
angle = 0;
length = 0;
depth = 0;
chr = Chromosome(x, y, angle, length, depth);

fitness_func = FitnessFactory.get_complete();

fitness_value = fitness_func(chr);
sc = chr.get_scenario();
sc.RunParkingPilot();
sc.Replay(0.04, 3);