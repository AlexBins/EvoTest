% a mutator with
% every bit flips with a probability of 10%
close all;
rational = MutatorFactory.get_range(0.1);

% a fitness function
% 50 is the maximal value of the fitness
%fit = FitnessFactory.get_desired_mindistance(50, 0.05);
fit = FitnessFactory.get_combined(FitnessFactory.get_desired_mindistance(1, 0.05),...
    FitnessFactory.get_min_parking_slot(), FitnessFactory.get_min_distance_start());

% a selector
select =  SelectCandidateFactory.get_generic(Selectors.get_fitnessWeighted());

% a merger
merger = MergeFactory.get_generic(Merges.get_naiverandommerge());

gen = GeneticAlgorithm(10, 1, 0.1, fit, select, merger, rational);
gen.main(20, true);

for i = 1:length(gen.Population)
    close all;
    sc = gen.Population(i).get_scenario();
    sc.RunParkingPilot();
    sc.Replay(0.04, 3);
    return;
    pause(2);
end