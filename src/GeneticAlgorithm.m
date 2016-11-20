classdef GeneticAlgorithm
    
    properties
        % The amount of candidates that should form the population
        % Number > 0
        PopulationSize
        % The current epoch
        % Number >= 0
        Epoch
        % The mutation rate
        % Number 0 <= MutationRate <= 1
        % TODO: @Manuel Is this still necessary?
        MutationRate
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
        function main(self)
            % TODO: implement
        end
        
        function Initialise(self)
            % TODO: implement
        end
        
        function AddToPopulation(self, candidate)
            % TODO: implement
        end
        
        function ReducePopulation(self)
            % TODO: implement
        end
    end
    
end

