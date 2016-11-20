classdef BinaryUtils    
    methods(Static)
        function inverted = toggle_bit(original)
            if original =='1'
                inverted = '0';
            else
                inverted = '1';
            end
        end
        
        function flipper = get_uniformFlipper(flip_probability)
            function new_genom = flip(old_genom)
                old_genom = BinaryUtils.fill_binary(old_genom);
                number_bits = length(old_genom);
                new_genom = ''; 
                for i=1:number_bits
                    current_bit = old_genom(i);
                    decision = random('unif', 0, 1);
                    if decision <= flip_probability
                        current_bit = BinaryUtils.toggle_bit(current_bit);
                    end
                    new_genom = strcat(new_genom, current_bit);
                end
            end
            flipper = @flip;
            
        end
        
        function filled = fill_binary(genom)
            max_bit = 32;
            filled = '';
            delta = max_bit - length(genom);
            if delta > 0
                for i = 1:delta
                    filled = strcat(filled, '0');
                end
            end
            filled = strcat(filled, genom);
        end
        function genom = to_genom(value)
            genom = dec2bin(value);
        end

        function value = to_value(genom)
            value = bin2dec(genom);
        end
    end
    
end

