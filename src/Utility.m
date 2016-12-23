classdef Utility
    
    methods (Static)
        function DoNothing(varargin)
            % Intentionally does nothing
        end
        
        function print(varargin)
            if isempty(varargin)
                disp('\n');
                return;
            end
            if isnumeric(varargin{1})
                line = num2str(varargin{1});
            else
                line = varargin{1};
            end
            for i = 2:length(varargin)
                if isnumeric(varargin{i})
                    x = num2str(varargin{i});
                else
                    x = varargin{i};
                end
                line = strcat(line, {' '}, x);
            end
            if iscell(line)
                line = cell2mat(line);
            end
            disp(line);
        end
        
        function drawGS(gs)
            for i = 1:gs.length()
                element = gs.getAt(i);
                if isa(element, 'PlanCircle')
                    plotCircle(element.PosX, element.PosY,...
                        element.Radius, element.RadiansStart, ...
                        element.RadiansEnd, element.Direction);
                else
                end
            end
        end
    end
    
end

