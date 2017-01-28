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
            % DEPRECATED
            
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
            % DEPRECATED
            
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
            % DEPRECATED
            
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
        
        function pools = build_migration_pools(self, m_rate)
            self.log('Staring to build migration pools');
            % preallocate memory for performance
            pools = cell(1, self.npop);
            % iterate over all populations
            for i_pop = 1:self.npop
                % get the sorted fitness value indexes
                pop = self.pops(i_pop);
                fitness_values = [pop.chromosomes.fitness];
                [~, fitness_indexes] = sort(fitness_values, 'descend');
                % truncate the last indexes
                fitness_indexes = fitness_indexes(1:m_rate);
                % add the chromosomes to the pool
                pools{i_pop} = self.pops(i_pop).chromosomes(fitness_indexes);
            end
            self.log('Building migration pools finished');
        end
        
        function getter_func = policy_migrant_getter(self, m_policy)
            % Use methods returned by this function:
            % [migrant, pool] = getter_func(i_current_population,
            % n_previous_migrations, pool);
            
            self.log('Creating migrant getter functions');
            switch m_policy
                case 'ring'
                    self.log('Ring migration getter');
                    getter_func = @MultiPopulationGA.migrant_getter_ring;
                case 'unrestricted'
                    self.log('Unrestricted migration getter');
                    getter_func = @MultiPopulationGA.migrant_getter_unrestricted;
                case 'neighbour'
                    self.log('Neighbour migration getter ');
                    getter_func = @MultiPopulationGA.migrant_getter_neighbour;
                otherwise
                    self.log('Invalid migration policy specified');
            end
            
            getter_func = MultiPopulationGA.migrant_getter_wrapper(getter_func);
            self.log('Migration getter function created');
        end
        
        function apply_migration(self, m_policy, m_rate)
            self.log('starting migration');
            % Migrate
            % migration policy
            
            % TODO: IMPORTANT!!!
            % Build pools. one per population. m_rate chromosomes per pool.
            % get the migrant_getter function. depends on policy.
            % ring: input i_current_population. get and remove the migrant
            % from the last population's pool.
            % unrestricted: input i_current_population: get and remove the
            % migrant from any pool, but the own one.
            % neighbour: input i_current_population, left or right neighbour.
            % get and remove the migrant from one neighbouring population's
            % pool.
            
            migration_pools = self.build_migration_pools(m_rate);
            migrant_getter = self.policy_migrant_getter(m_policy);

            for i_population = 1:self.npop
                self.log('Reducing population size');
                pop = self.pops(i_population);
                pop.size = pop.size - m_rate;
                pop.reduce();
                
                self.log(['Migrating into population:', num2str(i_population)]);
                for i_migration_step = 1:m_rate
                    [migrant, migration_pools] = migrant_getter(i_population, i_migration_step - 1, migration_pools);
                    self.pops(i_population).insert(migrant);
                    self.gas(i_population).computeSingleFitness(migrant);
                end
            end
            
%            % Old way
%             switch m_policy
%                 case 'ring'
%                     self.log('applying ring migration');
%                     self.migration_ring(m_rate);
%                 case 'unrestricted'
%                     self.log('applying unrestricted migration');
%                     self.migration_unrestricted(m_rate);
%                 case 'neighbour'
%                     self.log('applying neighbour migration');
%                     self.migration_neighbour(m_rate);
%                 otherwise
%                     self.log('Invalid migration policy specified');
%             end
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
        function migrant_getter = migrant_getter_wrapper(getter_function)
            % wrapper to copy the migrant
            function [migrant, migration_pools] = getter(i_target_population, n_previous_migrations, migration_pools)
                [migrant, migration_pools] = getter_function(i_target_population, n_previous_migrations, migration_pools);
                migrant = Chromosome.copy(migrant);
            end
            migrant_getter = @getter;
        end
        
        function [migrant, migration_pools] = migrant_getter_neighbour(i_target_population, n_previous_migrations, migration_pools)
            % get the circular next and previous pool's index
            n_pools = length(migration_pools);
            i_prev_pop = mod(i_target_population - 2, n_pools) + 1;
            i_next_pop = mod(i_target_population, n_pools) + 1;
            
            % select the pool to choose from, depending on the previous
            % migration steps
            if mod(n_previous_migrations, 2) == 0
                i_source = i_next_pop;
            else
                i_source = i_prev_pop;
            end
            
            % Get the migrant and remove it from the pool
            i_mig = randi(length(migration_pools{i_source}));
            migrant = migration_pools{i_source}(i_mig);
            migration_pools{i_source}(i_mig) = [];
        end
        
        function [migrant, migration_pools] = migrant_getter_ring(i_target_population, ~, migration_pools)
            % Get the circular previous population
            i_pop = mod(i_target_population - 2, length(migration_pools)) + 1;
            % Get the random migrant's index from the population's pool
            i_mig = randi(length(migration_pools{i_pop}));
            % Get the migrant itself
            migrant = migration_pools{i_pop}(i_mig);
            % Delete the migrant from the pool
            migration_pools{i_pop}(i_mig) = [];
        end
        
        function [migrant, migration_pools] = migrant_getter_unrestricted(i_target_population, ~, migration_pools)
            % Exclude empty pools from the random pools selection
            
            % this holds the number of not empty pools in the end
            n_pools = length(migration_pools);
            % this holds the number of empty pools in the end
            n_empty_pools = 0;
            % this maps from the index of the 'not empty pool' list to the
            % actuall pools (e.g.: pool 2 and 4 are empty. 5 pools in
            % total: i_indexes = [1, 3, 5, ~, ~]. ~ because these are not
            % important anyways)
            i_indexes = 1:n_pools;
            
            for i = 1:n_pools
                % Using the comparison to i_target_population implicitly
                % gets rid of the self to self migration issue
                if isempty(migration_pools{i}) || i_target_population == i
                    n_empty_pools = n_empty_pools + 1;
                    i_indexes(i_indexes >= i) = i_indexes(i_indexes >= i) + 1;
                end
            end
            
            % Well if this happens... fuck... then we previously had bad
            % luck and now we are in the last population where we realise
            % all the other pools are empty, only ours is left. Then we
            % have to migrant from self to self. Not good, but otherwise
            % mpga will crash
            if n_empty_pools == n_pools
                i_pop = i_target_population;
            else
                % Get the index of non empty pools
                i_pop = randi(n_pools - n_empty_pools);
                % Map the index
                i_pop = i_indexes(i_pop);
            end
            % Get the migrant's index
            i_mig = randi(length(migration_pools{i_pop}));
            % Get the migrant itself
            migrant = migration_pools{i_pop}(i_mig);
            % Remove the migrant
            migration_pools{i_pop}(i_mig) = [];
        end
        
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
            % DEPRECATED
            
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

