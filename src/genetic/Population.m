classdef Population < handle
    
    properties
        chromosomes;
        size;
        fitness_log = [];
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
        
        function log_fitness(self)
            sum = 0;
            chr_count = length(self.chromosomes);
            for i = 1:chr_count
                sum = sum + self.chromosomes(i).fitness;
            end
            self.fitness_log(length(self.fitness_log)+1) = sum / chr_count;
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
        
        function best_idx = get_best_idx(self)
            % Returns index of the chromosome with best(lowest) fitness value
                current_best_idx = 1;
                current_best_fitness = 1;
                for j = 1:length(self.chromosomes)
                    current_fitness = self.chromosomes(j).fitness;
                    if (current_fitness < current_best_fitness)
                        current_best_idx = j;
                        current_best_fitness = current_fitness;
                    end
                end
                best_idx = current_best_idx;
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

