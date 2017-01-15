% a mutator with
% every bit flips with a probability of 10%
close all;
rational = MutatorFactory.get_range(0.1);

% a fitness function
% 50 is the maximal value of the fitness
%fit = FitnessFactory.get_desired_mindistance(50, 0.05);
fit1 = FitnessFactory.get_complete();
fit2 = FitnessFactory.get_car_location_punishing([0; 0], [1; 0], true, 0);
fit3 = FitnessFactory.get_car_location_punishing([-5; 0], [0; -1], true, 0);
fit4 = FitnessFactory.get_car_location_punishing([5; 0], [0; 1], true, 0);
fit5 = FitnessFactory.get_car_location_punishing([0; 5], [-1; 0], true, 0);
fit6 = FitnessFactory.get_collision_enforcing(0.01);
fit = FitnessFactory.get_combined(fit1, fit2, fit3, fit4, fit5, fit6);
%fit = FitnessFactory.get_combined(FitnessFactory.get_desired_mindistance(1, 0.05),...
%    FitnessFactory.get_min_parking_slot(), FitnessFactory.get_min_distance_start());

% a selector
select =  SelectCandidateFactory.get_generic(Selectors.get_fitnessWeighted());

% a merger
merger = MergeFactory.get_generic(Merges.get_naiverandommerge());

gen = GeneticAlgorithm(10, 1, 0.1, fit, select, merger, rational);
gen.main(200, true);

for i = 1:max(size(gen.Population))
    close all;
    sc = gen.Population(i).get_scenario();
    sc.RunParkingPilot();
    sc.Replay(0.04, 3);
    
    pause(2);
end