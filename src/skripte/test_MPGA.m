close all;
test = MultiPopulationGA(10); % initialisiert MPGA mit 6 Populationen á 10 Chromosomen

fit = FitnessFactory.get_complete();
fit2 = FitnessFactory.get_car_location_punishing([0; 0], [1; 0], true, 0);
fit3 = FitnessFactory.get_car_location_punishing([0; 5], [-1; 0], true, 0);
fit4_1 = FitnessFactory.get_car_location_punishing([-2; 0], [0; 1], true, 0);
fit4_2 = FitnessFactory.get_car_location_punishing([2; 0], [0; 1], false, 0);
fit5_1 = FitnessFactory.get_car_location_punishing([-5; 0], [0; -1], true, 0);
fit5_2 = FitnessFactory.get_car_location_punishing([5; 0], [0; 1], true, 0);
fit6 = FitnessFactory.get_collision_enforcing(0.001);

test.addPopulation(FitnessFactory.get_combined(fit, fit2, fit3, fit4_1, fit5_1, fit6));
test.addPopulation(FitnessFactory.get_combined(fit, fit2, fit3, fit4_2, fit5_2, fit6));

test.runMPGA(1, 20, 5, 'ring'); % führt MPGA durch  mit MigrationRate 1, Migration interval - 3 Epochen, Anzahl Migrationsvorgänge 2

pops = test.pops;
n = test.npop;
chrs = Chromosome.empty;
for i = 1:n
    chrs(:,i) = pops(i).chromosomes;
end
figure;
hold on;
axis([-2.5 2.5 -1 4]);
for i = 1:size(chrs, 1)
    for j = 1:size(chrs,2)
        [x, y, angle, ~, ~] = chrs(i, j).get_physical_data();
        quiver(x, y, cos(angle), sin(angle), 'Color', colors(j));
        continue;
        sc = chrs(i, j).get_scenario();
        sc.RunParkingPilot();
        sc.Replay(0.1, 3);
        pause(1);
    end
end