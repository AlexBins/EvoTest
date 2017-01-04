classdef GenericGA
    properties
        % The reproduction rate
        % 0 => not a single new candidate per epoch
        % 1 => 100 % of the current population size new candidates
        % Good values are probably about 0.5
        % Number >= 0
        ReproductionRate
        
        % The current population holding the candidates
        % Type: Array of structs. [ a, b, ... ] where a, b are structs
        Population
        
        % Pointer to the currently used fitness function
        % Function needs to accept a struct of the current candidate as the
        % input and returns a number representing its fitness value
        FitnessFunction
        % Pointer to the currently used select candidate function
        % Function needs to accept an array of structs (candidates) as its input and
        % return one of its struct according to the used probability
        SelectCandidateFunction
        % Pointer to the currently used merge function
        % Function needs to accept two structs (candidates) as input and
        % return a merged one with some values from one, and the rest from
        % the other candidate
        MergeFunction
        % Pointer to the currently used mutate function
        % Function needs to accept a struct (candidate) as input and return
        % a mutated version of it
        MutateFunction
        
        verbose=false;
    end
    
    methods
        % Class constructor
        function obj = GenericGA(reprate, fitfunc, selcfunc, mergfunc, mutfunc)
            obj.ReproductionRate = reprate;
            obj.FitnessFunction = fitfunc;
            obj.SelectCandidateFunction = selcfunc;
            obj.MergeFunction = mergfunc;
            obj.MutateFunction = mutfunc;
        end
        
        function log(self, msg)
            if self.verbose
                fprintf('%s|GGA|%s\n', datetime('now'), msg);
            end
        end

        function runEpochs(self, population, iterations)
            self.computeFitness(population);
            for i = 1:iterations
                self.runEpoch(population);
            end
        end

        function runEpoch(self, population)
            self.log('started a new epoch');
            number_of_new_chromosomes = length(population.chromosomes) * self.ReproductionRate;
            
            self.log(sprintf('computing %i new chromosomes', number_of_new_chromosomes));
            new_population = Chromosome.empty;
            
            for idx = 1:number_of_new_chromosomes
                parent1 = self.SelectCandidateFunction(population.chromosomes);
                parent2 = self.SelectCandidateFunction(population.chromosomes);
                
                newCandidate = self.MergeFunction(parent1, parent2);
                newCandidate = self.MutateFunction(newCandidate);
                new_population(idx) = newCandidate;
            end
            population.extend(new_population);
            self.computeFitness(population);
            population.reduce();
            self.log('done with epoch');
        end
        
        function computeFitness(self, population)
            self.log('Fitness-computation');
            for i = 1:length(population.chromosomes)
                if isnan(population.chromosomes(i).fitness)
                    fitness = self.FitnessFunction(population.chromosomes(i));
                    population.chromosomes(i).fitness = fitness;
                end
            end
        end
    end
    
end