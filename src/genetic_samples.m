% a mutator with
% every bit flips with a probability of 10%
rational = MutatorFactory.get_range(0.1);

% a fitnes function
% 50 is the maximal value of the fitnes
fit = FitnesFactory.get_simple(50);

% a selector
select =  SelectCandidateFactory.get_generic(Selectors.get_uniform());

% a merger
merger = MergeFactory.get_generic(Merges.get_naiverandommerge());

gen = GeneticAlgorithm(10, 1, 0.5, fit, select, merger, rational);
gen.main(2);
sc = gen.Population(1).get_scenario();
sc.RunParkingPilot();
sc.Replay(1/60, 1);