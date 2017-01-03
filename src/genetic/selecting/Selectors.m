classdef Selectors
    methods (Static)
        function selector = get_fitnessWeighted()
            function selected = select(chromosomes)
                % p(x = x1) = (1 / n) * prop(x1)
                % n = length(chromosomes)
                % prop(x1) = if directpropotionalfitnessfunction
                %   Fitness(x1) / avg
                %       if indirectproportionalfitnessfunction
                %   avg / Fitness(x1)
                % not proven that sum over all xi in chromosomes of
                % p(x=xi) = 1
                % indirect proportional does not work this way.
                % TODO: fix indirect Proporitonality
                n = length(chromosomes);
                total_fitness = 0;
                for i = 1:n
                    total_fitness = total_fitness + chromosomes(i).fitness;
                end
                current_fitness = 0;
                idx = 0;
                rand_number = rand * total_fitness;
                while current_fitness <= rand_number
                    idx = idx + 1;
                    current_fitness =...
                        current_fitness + chromosomes(idx).fitness;
                end
                selected = chromosomes(idx);
            end
            selector = @select;
        end
        
        function selector = get_uniform()
            function selected = select(chromosomes)
                n = length(chromosomes);
                selected = chromosomes(randi(n));
            end
            selector = @select;
        end
    end
    
end

