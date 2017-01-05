classdef Chromosome < handle
    %Chromosome Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        carx;
        cary;
        carangle;
        slotlength;
        slotdepth;
        fitness;
    end
    
    methods
        function chr = Chromosome(x, y, angle, length, depth)
            chr.carx = x;
            chr.cary = y;
            chr.carangle = angle;
            chr.slotlength = length;
            chr.slotdepth = depth;
            chr.fitness = NaN;
        end
        
        function [x, y, angle, length, depth] = get_physical_data(self)
            bit_max = Chromosome.get_max_value();
            x = 15*self.carx/bit_max - 7.5;
            y = 5*self.cary/bit_max - 1;
            angle = 2*pi*self.carangle/bit_max;
            length = 2.75*self.slotlength/bit_max + 2.25;
            depth = self.slotdepth/bit_max + 1;
        end
        
        function scenario = get_scenario(self)
            [x,y,angle,length, depth] = self.get_physical_data();
            scenario = StaticScenario(x,y,angle,length,depth);
        end
        
        function set_fitnes(self, fitness)
            self.fitness = fitness;
        end
    end
    
    methods (Static)
        function chromosome = get_random()
            mav_val = Chromosome.get_max_value();
            chromosome = Chromosome(randi(mav_val)-1,randi(mav_val)-1,randi(mav_val)-1,randi(mav_val)-1,randi(mav_val)-1);
        end
        
        function val = get_max_value()
            val = 255;
        end
        
        function chr = from_physical(x, y, angle, length, depth)
            bit_max = Chromosome.get_max_value();
            x = bit_max*(x+7.5)/15;
            y = bit_max*(y+1)/5;
            angle = bit_max*angle/(2*pi);
            length = bit_max*(length-2.25)/2.75;
            depth = bit_max*(depth-1);
            chr = Chromosome(x, y, angle, length, depth);
        end
    end
end

