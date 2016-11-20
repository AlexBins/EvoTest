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
            % Initialize the population
            self.Initialize();
            
            % Calculate each candidate's fitness
            for i = 1:self.PopulationSize
                % TODO: Assume struct.Fitness exists
                self.Population(i).Fitness =...
                    self.FitnessFunction(self.Population(i));
            end
            
            % Get the amount of candidates to be created per epoch
            nNewCandidatesPerEpoch =...
                self.ReproductionRate * self.PopulationSize;
            nNewCandidatesPerEpoch = ceil(nNewCandidatesPerEpoch);
            
            % Enter the epoch loop
            while true
                self.Epoch = self.Epoch + 1;
                
                for i = 1:nNewCandidatesPerEpoch
                    parent1 = self.SelectCandidateFunction(self.Population);
                    parent2 = self.SelectCandidateFunction(self.Population);
                    
                    newCandidate = self.MergeFunction(parent1, parent2);
                    newCandidate = self.MutateFunction(newCandidate);
                    
                    self.AddToPopulation(newCandidate);
                end
                
                self.ReducePopulation();
            end
            % TODO: implement
        end
        
        function Initialize(self)
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

