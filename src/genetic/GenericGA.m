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
    end
    
    methods
        % Class constructor
        function obj = GeneticAlgorithm(reprate, fitfunc, selcfunc, mergfunc, mutfunc)
            obj.ReproductionRate = reprate;
            obj.FitnessFunction = fitfunc;
            obj.SelectCandidateFunction = selcfunc;
            obj.MergeFunction = mergfunc;
            obj.MutateFunction = mutfunc;
        end

        function runEpoch(self, population)
            
        end

        function runEpochs(self, population, iterations)
            for i = 1:iterations
                self.runEpoch(population);
            end
        end
    end
    
end

