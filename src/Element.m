classdef Element < handle
    %ELEMENT Interface for an element in the current scenario
    %   
    properties
        Location
        OrientationAngle
    end
    
    methods
        function Draw(self)
        end
        
        function SetLocation(self, x, y)
            self.Location = [x;y;1];
        end
    end
end

