classdef Cromosome < handle
    %CROMOSOME Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        carx;
        cary;
        carangle;
        slotlength;
        slotdepth;
        fitnes;
    end
    
    methods
        function chr = Cromosome(x, y, angle, length, depth)
            chr.carx = x;
            chr.cary = y;
            chr.carangle = angle;
            chr.slotlength = length;
            chr.slotdepth = depth;
            chr.fitnes = NaN;
        end
        
        function [x, y, angle, length, depth] = get_physical_data(self)
            bit_max = 255;
            x = 15*self.carx/bit_max - 7.5;
            y = 5*self.cary/bit_max - 1;
            angle = 360*self.carangle/bit_max;
            length = 2.75*self.slotlength/bit_max + 2.25;
            depth = self.slotdepth/bit_max + 1;
        end
        
        function scenario = get_scenario(self)
            [x,y,angle,length, depth] = self.get_physical_data();
            scenario = StaticScenario(x,y,angle,length,depth);
        end
        
        function set_fitnes(self, fitnes)
            self.fitnes = fitnes;
        end
    end
    
    methods (Static)
        function cromosome = get_random()
            cromosome = Cromosome(rand, rand, rand, rand, rand);
        end
    end
end

