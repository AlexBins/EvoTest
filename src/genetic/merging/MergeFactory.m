classdef MergeFactory
    properties
        merge_handle
    end
    
    methods
        function instance = MergeFactory(merge_handle)
            instance.merge_handle = merge_handle;
        end
        
        function merged = merge(self, Chromosome1, Chromosome2)
            merged = self.merge_handle(Chromosome1, Chromosome2);
        end
    end
    
    methods (Static)
        function merge = get_generic(merge_handle)
            instance = MergeFactory(merge_handle);
            merge = instance.merge_handle;
        end
    end
end

