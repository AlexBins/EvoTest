classdef FitnesFactory
    properties
    end
    
    methods(Static)
        function fitnes_func = get_simple(good_fitnes_limit)
            function fitnes = fit(chr)
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
        
        function fitnes_func = get_desired_mindistance(good_fitness_limit, desired_mindistance)
            % Generates a fitness function, that is best if the given
            % minimum distance is reached
            function fitnes = fit(chr)
                scenario = chr.get_scenario();
                [min_distance, collision] = scenario.RunParkingPilot();
                
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
                    d = 1 - (min_distance - desired_mindistance) / min_distance;
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
    
end

