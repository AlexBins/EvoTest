classdef Mutators
    methods(Static)
        function mutator = get_deviator(deviation)
            mutator = @(x) x + random('norm', 0, deviation);
        end
        
        function mutator = get_signedUniformFlipper(flip_probability, max_value, number_of_decimals)
            flipper = Mutators.get_unsignedUniformFlipper(flip_probability, max_value, number_of_decimals);
            sign_flipper = BinaryUtils.get_uniformFlipper(flip_probability);
            
            
            function new_value = mutate(old_value)
                negative = dec2bin(old_value<0);
                new_genom = sign_flipper(negative);
                negative = bin2dec(new_genom(1));
                
                new_value = flipper(old_value);
                if negative
                    new_value = -new_value;
                end
            end
            
            mutator = @mutate;
        end
        
        function mutator = get_unsignedUniformFlipper(flip_probability, max_value, number_of_decimals)
            flipper = BinaryUtils.get_uniformFlipper(flip_probability);
            max_bits = round(log2(max_value)+0.5)+number_of_decimals;
            offset = power(10,number_of_decimals);
            
            function new_value = mutate(old_value)
                genom = BinaryUtils.to_genom(old_value*offset);
                genom = BinaryUtils.fill_binary(genom, max_bits);
                new_genom = flipper(genom);
                new_genom = new_genom(2:end);
                new_value = BinaryUtils.to_value(new_genom)/offset;
            end
            
            mutator = @mutate;
        end
    end
end