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
    end
    
end

