close all;

gx = @(x) (x + 7.5) * 255 / 15;
gy = @(y) (y + 1) * 255 / 5;
ga = @(a) a * 255 / (2 * pi);

x = gx(1);
y = gy(0);
angle = ga(0);

length = 0;
depth = 0;
chr = Chromosome(x, y, angle, length, depth);

fitness_func_loc = FitnessFactory.get_car_location_punishing(2, 0, 1, 1);
ff2 = FitnessFactory.get_combined(fitness_func_loc, fitness_func_loc);
l = 6;
r = 1;
fitness_orientation = FitnessFactory.get_car_orientation_punishing(l, r);

fitness_value_1 = fitness_func_loc(chr);
fitness_value_2 = ff2(chr);

fitness_func_cmb = FitnessFactory.get_combined(fitness_orientation, fitness_func_loc);

n = 50;
x = linspace(-7.5, 7.5, n);
a = linspace(0, 2 * pi, n);
for i = 1:n
    for j = 1:n
        chr = Chromosome(gx(x(i)), y, ga(a(j)), length, depth);
        ffv(i, j) = fitness_func_cmb(chr);
    end
end
figure; hold on;
surf(a, x, ffv)
