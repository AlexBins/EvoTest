function population = evolute(pop_size, new_pop, max_epochs, verbose)
    % a mutator with
    % every bit flips with a probability of 10%
    close all;
    rational = MutatorFactory.get_range(0.1);

    % a fitnes function
    fit = FitnesFactory.get_combined(FitnesFactory.get_desired_mindistance(1, 0.05),...
        FitnesFactory.get_min_parking_slot(), FitnesFactory.get_min_distance_start());

    % a selector
    select =  SelectCandidateFactory.get_generic(Selectors.get_fitnessWeighted());

    % a merger
    merger = MergeFactory.get_generic(Merges.get_naiverandommerge());

    gen = GeneticAlgorithm(pop_size, 1, new_pop, fit, select, merger, rational);
    gen.main(max_epochs, verbose);
    population = gen.Population;
end