classdef MutatorFactory
    %MUTATORFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x_mutator;
        y_mutator;
        theta_mutator;
        width_mutator;
        length_mutator;
    end
    
    methods
        function instance = MutatorFactory(mut_x, mut_y, mut_theta, mut_width, mut_length)
            % The mutators are function handles, modifying one input and
            % generating one output
            instance.x_mutator = mut_x;
            instance.y_mutator = mut_y;
            instance.theta_mutator = mut_theta;
            instance.width_mutator = mut_width;
            instance.length_mutator = mut_length;
        end
        
        function [mutant] = mutate(self, cromosome)
            % parse cromosome
            xpos = 0;
            ypos = 0;
            theta = 0;
            width = 0;
            length = 0;

            % mutate the actual values
            xpos = self.x_mutator(xpos);
            ypos = self.y_mutator(ypos);
            theta = self.theta_mutator(theta);
            width = self.width_mutator(width);
            length = self.length_mutator(length);

            % create new storage instance
            mutant.xpos = xpos;
            mutant.ypos = ypos;
            mutant.theta = theta;
            mutant.width = width;
            mutant.length = length;
        end
    end
    
    methods(Static)
        function mutator = generic(mut_x, mut_y, mut_theta, mut_width, mut_length)
            instance = MutatorFactory(mut_x, mut_y, mut_theta, mut_width, mut_length);
            mutator = @instance.mutate;
        end
        
        function mutator = uniform(std_deviation)
            std_mut = mutator_normal(std_deviation);
            mutator = MutatorFactory.generic(std_mut, std_mut, std_mut, std_mut, std_mut);
        end
        
        function mutator = category(deviation_position, deviation_theta, deviation_slot)
            pos_mutator = mutator_normal(deviation_position);
            theta_mutator = mutator_normal(deviation_theta);
            slot_mutator = mutator_normal(deviation_slot);
            mutator = MutatorFactory.generic(pos_mutator, pos_mutator, theta_mutator, slot_mutator, slot_mutator);
        end
    end
    
end

