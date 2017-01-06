classdef Population < handle
    
    properties
        chromosomes;
        size;
    end
    
    methods
        function population = Population(size)
            population.size = size;
            population.chromosomes = Chromosome.get_random();
            for i = 2:size
                chr = Chromosome.get_random();
                population.add(chr);
            end
        end
        
        function add(self, chromosome)
            current_idx = length(self.chromosomes);
            self.chromosomes(current_idx + 1) = chromosome;
        end
        
        function extend(self, chromosomes)
            current_idx = length(self.chromosomes);
            self.chromosomes(current_idx+1:current_idx+length(chromosomes)) = chromosomes;
        end

        function reduce(self)
            overflow = length(self.chromosomes) - self.size;
            for i = 1:overflow
                current_worst_value = 1; 
                current_worst_idx = 1;
                for j = 1:length(self.chromosomes)
                    current_fitness = self.chromosomes(j).fitness;
                    if (current_fitness < current_worst_value)
                        current_worst_idx = j;
                        current_worst_value = current_fitness;
                    end
                end
                self.chromosomes(current_worst_idx) = [];
            end
        end
        
        function remove(self, idx)
        % removes a chromosome with a given position index from the
        % population    
            if (idx <= self.size)
                self.chromosomes(idx) = [];
                self.size = self.size - 1;
            else
                self.log('Chromosome index out of range');
            end
        end
        
        function insert(self, chromosome)
        % Inserts new chromosome into population and updates population size    
            current_idx = length(self.chromosomes);
            self.chromosomes(current_idx + 1) = chromosome;
            self.size = self.size + 1;
        end
    end
    
end

