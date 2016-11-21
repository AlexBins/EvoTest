classdef SelectCandidateFactory
    
    properties
        selector;
    end
    
    methods 
        function instance = SelectCandidateFactory(selector)
            % The selector is a function handle, taking the input
            % chromosome array and selecting one as the output
            instance.selector = selector;
        end
        
        function selected = select(self, chromosomes)
            selected = self.selector(chromosomes);
        end
    end
    
    methods (Static)
        function selector = get_generic(selector)
            instance = SelectCandidateFactory(selector);
            selector = @instance.select;
        end
    end
end

