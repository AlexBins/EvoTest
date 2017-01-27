classdef MultiPopulationGA < handle
    properties
        npop % number of populations
        
        pops % array of population class objects
        
        gas % array of handles for GenericGA objects
        
        mr % migration rate (number of chromosomes migrated from one population to another in a single run
        
        mi % migration interval (number of epochs passed between two consequent migrations)
        
        defaultPopulationSize
        
        ga_params % struct of parameters for genericGA
        
        verbose = false;
    end
    
    methods
        function obj = MultiPopulationGA(popsize)
            % This is the class constructor
            % Get GA Parameters
            obj.npop = 0;
            obj.defaultPopulationSize = popsize;

            % Generate array with populations and GAs
            obj.pops = Population.empty;
            obj.gas = GenericGA.empty;
        end
        
        function enable_logging(self, enabled)
            self.verbose = enabled;
            for i = 1:length(self.gas)
                self.gas(i).verbose = enabled;
            end
        end
        
        function pop = addPopulation(self, varargin)
            % Adds a new population
            % 
            % arg1: fitness function. (optional)
            % arg2: population size. If none is given, defaults to the
            % MPGA's defautl population size
            
            params = self.getGAParams();
            self.npop = self.npop + 1;
            
            if length(varargin) >= 1
                fit = varargin{1};
            else
                fit = params.fit;
            end
            if length(varargin) >= 2
                size = varargin{2};
            else
                size = self.defaultPopulationSize;
            end
            
            pop = Population(size);
            ga = GenericGA(params.rr, fit, params.select, params.merger, params.rational);
            ga.Population = pop;
            
            self.gas(self.npop) = ga;
            self.pops(self.npop) = pop;
        end
        
        function runMPGA(self, m_rate, m_int, n_int, m_policy)
            % This function runs MPGA routine with specified parameters
            % m_rate - migration rate
            % m_int - migration interval
            % n_int - number of intervals
            self.log('Started Multipopulation evolution');
            % Perform evolution and migration cycles for n_int intervals
            self.evolute(1, n_int, m_int);
            for e = 2:n_int
                self.apply_migration(m_policy, m_rate);
                self.evolute(e, n_int, m_int);
            end
            self.log('done with multipopulation evolution');
        end
        
        function migration_unrestricted(self, m_rate)
            % iterate over all populations
            for idx = 1:self.npop
                % 1. for each population create migration pool from the
                % rest populations
                mp = struct('chr', [], 'pop', []);
                for i = 1:self.npop
                    if (i ~= idx)
                        mp(end+1) = struct('chr', self.gas(i).Population.get_best_idx(), 'pop', i);
                    end    
                end
                mp(1) = [];
                % account for migration rate
                for m = 1:m_rate
                    % 2. select migrant randomly from migration pool
                    idx_source = randi(length(mp));
                    % 3. migrate selected chromosome from pool to current
                    % population
                    MultiPopulationGA.migrate(self.gas(idx).Population, self.gas(mp(idx_source).pop).Population, mp(idx_source).chr);
                    % remove migrated chromosome from migration pool to
                    % avoid duplicates
                    mp(idx_source) = []; 
                end
            end
        end
        
        function migration_ring(self, m_rate)
            % migrate to the next neighbor clockwise
            for idx = 1:self.npop
                idx_next = mod(idx, self.npop)+1;
                %nrand = NaN;
                % apply migration rate
                for migrant = 1:m_rate
                    % select random chromosome from source population
                    %nprev = nrand;
                    %%while (nprev == nrand) % assert no duplicate selection
                    nrand = randi(self.gas(idx).Population.size);
                    % perform migration by replacement
                    MultiPopulationGA.migrate(self.gas(idx_next).Population, self.gas(idx).Population, nrand);   
                end
            end
        end
        
        function migration_neighbour(self, m_rate)
            % iterate over all populations
            for idx = 1:self.npop
                % 1. for each population create migration pool from the
                % neighbour (forward and backward) populations
                idx_next = mod(idx, self.npop)+1;
                idx_prev = mod(idx-2, self.npop)+1;

                % 2. create migration pool using best chromosomes from
                % neighbour populations
                mp = struct('chr', self.gas(idx_prev).Population.get_best_idx(), 'pop', idx_prev);
                mp(2) = struct('chr', self.gas(idx_next).Population.get_best_idx(), 'pop', idx_next);

                % assure enough chromosomes in migration pool
                if (m_rate<=length(mp))
                    % account for migration rate
                    for m = 1:m_rate

                        % 3. select migrant randomly from migration pool
                        idx_source = randi(length(mp));
                        % 4. migrate selected chromosome from pool to current
                        % population
                        MultiPopulationGA.migrate(self.gas(idx).Population, self.gas(mp(idx_source).pop).Population, mp(idx_source).chr);
                        % remove migrated chromosome from migration pool to
                        % avoid duplicate migrants
                        mp(idx_source) = []; 
                    end
                end
            end
        end
        
        function apply_migration(self, m_policy, m_rate)
            self.log('starting migration');
            % Migrate
            % migration policy
            switch m_policy
                case 'ring'
                    self.log('applying ring migration');
                    self.migration_ring(m_rate);
                case 'unrestricted'
                    self.log('applying unrestricted migration');
                    self.migration_unrestricted(m_rate);
                case 'neighbour'
                    self.log('applying neighbour migration');
                    self.migration_neighbour(m_rate);
                otherwise
                    self.log('Invalid migration policy specified');
            end
            self.log('migration done');
        end
        
        function evolute(self, e, n_int, m_int)
            self.log(sprintf('starting a new migration-free interval %d/%d', e, n_int));
            % Run all GAs for m_int epochs
            for i=1:self.npop
                self.log(sprintf('started a new evolution step for population %d/%d', i, self.npop));
                self.gas(i).runEpochs(self.gas(i).Population, m_int);
            end
            self.log('Evolution done');
        end
        
        function log(self, msg)
            if self.verbose
                fprintf('%s|MPA|%s\n', datetime('now'), msg);
            end
        end
    end
        
    methods (Static)
        function policy = get_migration_policy_ring()
            policy = 'ring';
        end
        function policy = get_migration_policy_unrestricted()
            policy = 'unrestricted';
        end
        function policy = get_migration_policy_neighbour()
            policy = 'neighbour';
        end
        
         function migrate(p_dest, p_source, idx_source)
            % This function migrates a single selected chromosome 
            % from  source population to destination population 
            % The migrated chromosome replaces the chromosome with the worst
            % fitness value

            % Get the chromosome (if p_dest == p_source => it could be the
            % deleted chromosome that is to be migrated)
            chr = Chromosome.copy(p_source.chromosomes(idx_source));
            
            % Remove worst chromosome from the destination population
            p_dest.size = p_dest.size - 1;    
            p_dest.reduce();
            % Insert selected chromosome to destination population
            p_dest.insert(chr);
            % Remove chromosome from the source population
            %p_source.remove(idx_source);
        
        end
        
        function p = getGAParams()
            % a mutator with
            % every bit flips with a probability of 10%
            %close all;
            p.rational = MutatorFactory.get_range(0.1);

            % reproduction rate
            p.rr = 0.1;
            % a fitness function
            % 50 is the maximal value of the fitness
            %fit = FitnessFactory.get_desired_mindistance(50, 0.05);
            p.fit = FitnessFactory.get_combined(FitnessFactory.get_desired_mindistance(1, 0.05),...
                FitnessFactory.get_min_parking_slot(), FitnessFactory.get_min_distance_start());

            % a selector
            p.select =  SelectCandidateFactory.get_generic(Selectors.get_fitnessWeighted());

            % a merger
            p.merger = MergeFactory.get_generic(Merges.get_naiverandommerge());
        
        end
    end
    
end

