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
            self.chromosomes(current_idx+1) = chromosome;
        end

        function reduce(self)
            current_worst_value = 1; 
            current_worst_idx = 1;
            overflow = length(self.chromosomes) - self.size;
            for i = 1:overflow
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
    end
    
end

