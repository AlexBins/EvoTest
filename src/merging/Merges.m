classdef Merges
    
    methods (Static)
        function merge_handle = get_naiverandommerge()
            function merged = merge(c1, c2)
                function r = get_random(a, b)
                    if rand > 0.5
                        r = a;
                    else
                        r = b;
                    end
                end
                
                merged = Cromosome(...
                    get_random(c1.carx, c2.carx),...
                    get_random(c1.cary, c2.cary),...
                    get_random(c1.carangle, c2.carangle),...
                    get_random(c1.slotlength, c2.slotlength),...
                    get_random(c1.slotdepth, c2.slotdepth));
            end
            merge_handle = @merge;
        end
    end
    
end

