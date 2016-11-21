classdef Mutators
    methods(Static)
        function mutator = get_deviator(deviation)
            mutator = @(x) x + random('norm', 0, deviation);
        end
        
        function mutator = get_uniformFlipper(offset, flip_probability, max_number_bits)
            flipper = BinaryUtils.get_uniformFlipper(flip_probability);
            function new_value = mutate(old_value)
                genom = BinaryUtils.to_genom(old_value*offset);
                genom = BinaryUtils.fill_binary(genom, max_number_bits);
                new_genom = flipper(genom);
                new_value = BinaryUtils.to_value(new_genom)/offset;
            end
            mutator = @mutate;
        end
    end
    
end