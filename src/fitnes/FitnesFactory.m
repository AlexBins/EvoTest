classdef FitnesFactory
    properties
    end
    
    methods(Static)
        function fitnes_func = get_simple(good_fitnes_limit)
            function fitnes = fit(chr)
                scenario = StaticScenario(chr.carx, chr.cary, chr.carangle, chr.slotlength, chr.slotdepth);
                [min_distance collision] = scenario.RunParkingPilot();
                if collision
                    penalty = 0;
                else
                    penalty = 1;
                end
                fitnes = 1/(penalty*min_distance+(1/good_fitnes_limit));
            end
            fitnes_func = @fit;
        end
    end
    
end

