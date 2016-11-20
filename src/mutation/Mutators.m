classdef Mutators
    methods(Static)
        function mutator = get_value(deviation)
            mutator = @(x) x + random('norm', 0, deviation);
        end
        
        function mutator = get_genome(offset, fliprate)
            flipper = BinaryUtils.get_uniformFlipper(fliprate);
            function new_value = mutate(old_value)
                genom = BinaryUtils.to_genom(old_value*offset);
                new_genom = flipper(genom);
                new_value = BinaryUtils.to_value(new_genom)/offset;
            end
            mutator = @mutate;
        end
    end
    
end