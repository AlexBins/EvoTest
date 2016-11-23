classdef MutatorFactory
    % Generate a Mutator that mutatates the values modular
    
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
            % actually mutating all 5 values within a cromosome
            % parse cromosome
            xpos = cromosome.carx;
            ypos = cromosome.cary;
            theta = cromosome.carangle;
            width = cromosome.slotdepth;
            length = cromosome.slotlength;

            % mutate the actual values
            xpos = self.x_mutator(xpos);
            ypos = self.y_mutator(ypos);
            theta = self.theta_mutator(theta);
            width = self.width_mutator(width);
            length = self.length_mutator(length);

            % create new storage instance
            mutant = Cromosome(xpos, ypos, theta, length, width);
        end
    end
    
    methods(Static)
        function mutator = get_generic(mut_x, mut_y, mut_theta, mut_width, mut_length)
            % generate a new mutator instance from the 5 value mutators
            % provided
            instance = MutatorFactory(mut_x, mut_y, mut_theta, mut_width, mut_length);
            mutator = @instance.mutate;
        end
        
        function mutator = get_deviatorUniform(std_deviation)
            % apply a uniform distribution to all 5 values
            std_mut = Mutators.get_deviator(std_deviation);
            mutator = MutatorFactory.get_generic(std_mut, std_mut, std_mut, std_mut, std_mut);
        end
        
        function mutator = get_deviatorCategory(deviation_position, deviation_theta, deviation_slot)
            % apply different normal distributions to pos, theta and the
            % slot
            pos_mutator = Mutators.get_deviator(deviation_position);
            theta_mutator = Mutators.get_deviator(deviation_theta);
            slot_mutator = Mutators.get_deviator(deviation_slot);
            mutator = MutatorFactory.get_generic(pos_mutator, pos_mutator, theta_mutator, slot_mutator, slot_mutator);
        end
        
        function mutator = get_signedGenomeUniform(flip_probability, max_value, number_of_decimals)
            mut = Mutators.get_signedUniformFlipper(flip_probability, max_value, number_of_decimals);
            mutator = MutatorFactory.get_generic(mut, mut, mut, mut, mut);
        end
        
        function mutator = get_rational(mutation_probability, max_pos, max_slot, number_of_decimals)
            % generate a mutator, maximal outcome for position and slot
            pos_mutator = Mutators.get_signedUniformFlipper(mutation_probability, max_pos, number_of_decimals);
            theta_mutator = Mutators.get_unsignedUniformFlipper(mutation_probability, 2*pi, number_of_decimals);
            slot_mutator = Mutators.get_unsignedUniformFlipper(mutation_probability, max_slot, number_of_decimals);
            mutator = MutatorFactory.get_generic(pos_mutator, pos_mutator, theta_mutator, slot_mutator, slot_mutator);
        end
        
        function mutator = get_range(flip_probability)
            mut = Mutators.get_range_flipper(flip_probability);
            mutator = MutatorFactory.get_generic(mut, mut, mut, mut, mut);
        end
    end    
end

