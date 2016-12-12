classdef FitnesFactory    
    methods(Static)
        function fitnes_func = get_simple(good_fitnes_limit)
            function fitnes = fit(chr, varargin)
                scenario = chr.get_scenario();
                [min_distance, collision] = scenario.RunParkingPilot();
                if collision
                    penalty = 100;
                else
                    penalty = 0;
                end
                fitnes = 1/(penalty+min_distance+(1/good_fitnes_limit));
            end
            fitnes_func = @fit;
        end
        
        function fitness_func = get_combined(varargin)
            if isempty(varargin)
                fitness_func = FitnesFactory.get_simple(1);
                return;
            end
            
            function fitness = fit(chr)
                fitness = 1;
                
                scenario = FitnesFactory.run_scenario(chr);
                %scenario = chr.get_scenario();
                %scenario.RunParkingPilot();
                for i = 1:length(varargin)
                    f = varargin{i};
                    fitness = fitness * f(chr, scenario);
                end
            end
            fitness_func = @fit;
        end
        
        function fitness_func = get_min_distance_start()
            function fitnes = fit(chr, varargin)
                target = [0; -1.5];
                
                [x, y, ~, ~, ~] = chr.get_physical_data();
                start = [x; y];
                dist = norm((target - start) * 0.1);
                fitnes = 1 / (1 + dist);
            end
            fitness_func = @fit;
        end
        
        function fitnes_func = get_min_parking_slot()
            function fitnes = fit(chr, varargin)
                [~, ~, ~, l, d] = chr.get_physical_data();
                fitnes = 1 / (l + d);
                fitnes = fitnes ^ 2;
            end
            fitnes_func = @fit;
        end
        
        function fitnes_func = get_desired_mindistance(good_fitness_limit, desired_mindistance)
            % Generates a fitness function, that is best if the given
            % minimum distance is reached
            function fitnes = fit(chr, varargin)
                if isempty(varargin)
                    scenario = FitnesFactory.run_scenario(chr);
                    %scenario = chr.get_scenario();
                    %[min_distance, collision] = scenario.RunParkingPilot();
                else
                    scenario = varargin{1};
                end
                min_distance = scenario.MinDistance;
                collision = scenario.Collision;
                
                % Create d in a way, that it is 1 when min_distance equals
                % desired_mindistance and 0 when the min_distance equals 0
                % or infinite
                if min_distance < desired_mindistance
                    % The closer one gets to an obstacle, the worse it is.
                    % penalize distances closer to the desired distance
                    % really hard with taking it to the power of 4
                    d = (min_distance / desired_mindistance)^4;
                else
                    % The larger the distance, the worse the value
                    d = desired_mindistance / min_distance;
                end
                % d is NaN if min_distance and the desired distance are
                % equal to zero => collision => bad
                if isnan(d) || collision
                    d = 0;
                end
                
                fitnes = d * good_fitness_limit;
            end
            fitnes_func = @fit;
        end
    end
    
    methods (Static, Access = private)
        function sc = run_scenario(chr)
            sc = chr.get_scenario();
            sc.RunParkingPilot();
        end
    end
end

