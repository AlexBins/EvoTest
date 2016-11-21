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

