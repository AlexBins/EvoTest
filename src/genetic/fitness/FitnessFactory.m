classdef FitnessFactory    
    methods(Static)
        function fitness_func = get_complete()
            % This function returns a complete fitness function, taking
            % care of slot size, collision distance and minimal distance but not the car position (since this differs
            % from Population to Population)
            function fitness_value = fitness(chr)
                % Get the scenario. Simulation already complete.
                scenario = chr.get_scenario();
                scenario.RunParkingPilot();
                
                % calculate the slot size multiplier
                [~, ~, ~, len, dep] = chr.get_physical_data();
                [min_len, min_dep] = Chromosome.get_min_slot_size();
                slot_length_multiplier = 1 / (1 + len - min_len);
                slot_depth_multiplier = 1 / (1 + dep - min_dep);
                slot_size_multiplier = 2 * slot_depth_multiplier * slot_length_multiplier;
                
                if isempty(scenario.MinDistanceTime)
                    fitness_value = 0;
                    return;
                end
                
                [coll_car_x, coll_car_y, coll_car_angle] = scenario.Trajectory.GetAtTime(scenario.MinDistanceTime);
                rect_coll_car = ...
                    RectangularElement(...
                    coll_car_x, coll_car_y, scenario.Car.Width / 4, scenario.Car.Height / 4, coll_car_angle). ...
                    GetRectangle();
                rect_parking_slot = RectangularElement(scenario.parkingSlot.GetX(), scenario.parkingSlot.GetY(),...
                    scenario.parkingSlot.Width / 2, scenario.parkingSlot.Height, scenario.parkingSlot.GetOrientationRadians()). ...
                    GetRectangle();
                [~, distance] = GeometricUtility.fRectDist(rect_coll_car(1:2,1:5), rect_parking_slot(1:2,1:5));

                % if distance = 0: perfect. Collision inside the slot
                % if distance < 0.5: still ok. No penalty
                % if distance > 0.5: that's bad. Probably out of PP
                % scope => penalty
                max_distance_multiplier = 2;
                collision_distance_multiplier = max_distance_multiplier / (1 + distance);
                
                acceptable_min_distance = 0.15;
                min_distance = scenario.MinDistance;
                temporary_helper = min_distance * (-5) / acceptable_min_distance + 5;
                min_distance_multiplier = max_distance_multiplier * (1 / (1 + exp(-temporary_helper)));
                
                fitness_value = min_distance_multiplier * collision_distance_multiplier * slot_size_multiplier;
            end
            fitness_func = @fitness;
        end
        
        function fitnes_func = get_simple(good_fitnes_limit)
            function fitness = fit(chr, varargin)
                scenario = chr.get_scenario();
                [min_distance, collision] = scenario.RunParkingPilot();
                if collision
                    penalty = 100;
                else
                    penalty = 0;
                end
                fitness = 1/(penalty+min_distance+(1/good_fitnes_limit));
            end
            fitnes_func = @fit;
        end
        
        function fitness_func = get_combined(varargin)
            if isempty(varargin)
                fitness_func = FitnessFactory.get_simple(1);
                return;
            end
            
            function fitness = fit(chr)
                fitness = 1;
                
                scenario = FitnessFactory.run_scenario(chr);
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
            function fitness = fit(chr, varargin)
                target = [0; -1.5];
                
                [x, y, ~, ~, ~] = chr.get_physical_data();
                start = [x; y];
                dist = norm((target - start) * 0.1);
                fitness = 1 / (1 + dist);
            end
            fitness_func = @fit;
        end
        
        function fitnes_func = get_min_parking_slot()
            function fitness = fit(chr, varargin)
                [~, ~, ~, l, d] = chr.get_physical_data();
                fitness = 1 / (l + d);
                fitness = fitness ^ 2;
            end
            fitnes_func = @fit;
        end
        
        function fitnes_func = get_desired_mindistance(good_fitness_limit, desired_mindistance)
            % Generates a fitness function, that is best if the given
            % minimum distance is reached
            function fitness = fit(chr, varargin)
                if isempty(varargin)
                    scenario = FitnessFactory.run_scenario(chr);
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
                
                fitness = d * good_fitness_limit;
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

