function population = evolute(pop_size, new_pop, max_epochs, verbose)
    % a mutator with
    % every bit flips with a probability of 10%
    close all;
    mutator = MutatorFactory.get_range(0.1);

    % a fitness function
    fit = FitnessFactory.get_combined(FitnessFactory.get_desired_mindistance(1, 0.05),...
        FitnessFactory.get_min_parking_slot(), FitnessFactory.get_min_distance_start());

    % a selector
    select =  SelectCandidateFactory.get_generic(Selectors.get_fitnessWeighted());

    % a merger
    merger = MergeFactory.get_generic(Merges.get_naiverandommerge());

    gen = GenericGA(new_pop, fit, select, merger, mutator);
    gen.verbose = true;
    population = Population(pop_size);
    gen.runEpochs(population, max_epochs);
end