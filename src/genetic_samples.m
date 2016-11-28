% a mutator with
% every bit flips with a probability of 10%
close all;
rational = MutatorFactory.get_range(0.1);

% a fitnes function
% 50 is the maximal value of the fitnes
fit = FitnesFactory.get_desired_mindistance(50, 0.05);

% a selector
select =  SelectCandidateFactory.get_generic(Selectors.get_fitnessWeighted());

% a merger
merger = MergeFactory.get_generic(Merges.get_naiverandommerge());

gen = GeneticAlgorithm(10, 1, 0.5, fit, select, merger, rational);
gen.main(50, true);

for i = 1:length(gen.Population)
    close all;
    sc = gen.Population(i).get_scenario();
    sc.RunParkingPilot();
    sc.Replay(0.04, 3);
    
    pause(2);
end