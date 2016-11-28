classdef GeneticAlgorithm < handle
    
    properties
        % The amount of candidates that should form the population
        % Number > 0
        PopulationSize
        % The current epoch
        % Number >= 0
        Epoch
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
        % For debug purposes: Stores the maximum fitness value in the
        % population
        max_fitnes
    end
    
    methods
        % Class constructor
        function obj = GeneticAlgorithm(psize, epoch, reprate, fitfunc, selcfunc, mergfunc, mutfunc)
            obj.PopulationSize = psize; 
            obj.Epoch = epoch;
            obj.ReproductionRate = reprate;
            obj.FitnessFunction = fitfunc;
            obj.SelectCandidateFunction = selcfunc;
            obj.MergeFunction = mergfunc;
            obj.MutateFunction = mutfunc;
            %self.Population = NaN;
            obj.max_fitnes = 0;
            
        end
        function main(self, max_epoch, varargin)
            if length(varargin) >= 1 && varargin{1}  
                prnt = @Utility.print;
            else
                prnt = @Utility.DoNothing;
            end
            if length(varargin) >= 2 && varargin{2}
                start_time = @tic;
                end_time = @toc;
            else
                start_time = @Utility.DoNothing;
                end_time = @Utility.DoNothing;
            end
            % Initialize the population
            
            prnt('Init');
            start_time();
            self.Initialize();
            end_time()
            
            MaxEpoch = max_epoch;
            
            prnt('First fitness calculation');
            start_time();
            % Calculate each candidate's fitness
            for i = 1:self.PopulationSize
                % TODO: Assume struct.Fitness exists
                self.Population(i).fitnes =...
                    self.FitnessFunction(self.Population(i));
                self.max_fitnes = max(self.max_fitnes, self.Population(i).fitnes);
            end
            end_time()
            
            % Get the amount of candidates to be created per epoch
            nNewCandidatesPerEpoch =...
                self.ReproductionRate * self.PopulationSize;
            nNewCandidatesPerEpoch = ceil(nNewCandidatesPerEpoch);
            
            % Enter the epoch loop
            while true
                prnt('starting epoch:', self.Epoch);
                self.Epoch = self.Epoch + 1;
                % Select, merge, mutate and add
                prnt('creating', nNewCandidatesPerEpoch, 'new candidates');
                start_time();
                for i = 1:nNewCandidatesPerEpoch
                    parent1 = self.SelectCandidateFunction(self.Population);
                    parent2 = self.SelectCandidateFunction(self.Population);
                    
                    newCandidate = self.MergeFunction(parent1, parent2);
                    newCandidate = self.MutateFunction(newCandidate);
                    
                    self.AddToPopulation(newCandidate);
                end
                end_time()
                
                % Reduce the population again
                self.ReducePopulation();
                
                if self.Epoch >= MaxEpoch
                    return;
                end
            end
        end
        
        function Initialize(self)
            % TODO: implement restrictions to ensure scenario plausibility
            N = self.PopulationSize;
            xy_max = 10;
            xy_min = 0;
            length_max = 10;
            length_min = 1;
            depth_max = 10;
            depth_min = 1;
            t = Cromosome.empty;
            for i = 1:10
            %self.Population(i) 
            t(i) = Cromosome(randi([xy_min xy_max],1,1), randi([xy_min xy_max],1,1), (0 + (2*pi-0).*rand()), randi([length_min length_max],1,1), randi([depth_min depth_max],1,1));  
            end
            self.Population  = t;
        end
        
        function AddToPopulation(self, candidate)
            % Set the value first, then add it to the population (If the
            % Fitness is set second, then it will be lost due to candidate
            % not inheriting from handle)
            candidate.fitnes = self.FitnessFunction(candidate);
            self.max_fitnes = max(self.max_fitnes, candidate.fitnes);
            self.Population(length(self.Population) + 1) = candidate;
        end
        
        function ReducePopulation(self)
            n = length(self.Population);
            fitness_values = zeros(n, 1);
            % Collect all fitness values
            for i = 1:n
                fitness_values(i) = self.Population(i).fitnes;
            end
            % I(i) returns the index of the fitness_values(i)-th according
            % chromosome
            [~, I] = sort(fitness_values, 'descend');
            % the last few entries in I contain the indexes with the lowest
            % fitness => trim I to these indexes and sort it, so that the
            % highest index is at the front. (this is because removing an
            % element messes with the indexes behind that element => thus
            % work from back to front)
            I = sort(I(self.PopulationSize + 1:end), 'descend');
            for i = 1:length(I)
                self.Population(I(i)) = [];
            end
        end
    end
    
end

