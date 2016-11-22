% a mutator with:
% every bit flips with a probability of 10%
% the maximal achievable position is between -32 and 32 meters (x and y
% each)
% The maximal slot dimensions are between 0 and 8 meters (length, depth)
% The accuracy of the values is 0.01
rational = MutatorFactory.get_rational(0.1, 32, 8, 2);

% a fitnes function
% 50 is the maximal value of the fitnes
fit = FitnesFactory.get_simple(50);

% a selector
select =  SelectCandidateFactory.get_generic(Selectors.get_uniform());

% a merger
merger = MergeFactory.get_generic(Merges.get_naiverandommerge());

gen = GeneticAlgorithm(10, 100, 0.1,0.5, fit, select, merger, rational);