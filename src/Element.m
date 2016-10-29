classdef Element < handle
    %ELEMENT Interface for an element in the current scenario
    %   
    properties
        Location
        OrientationAngle
    end
    
    methods
        function Draw(self)
            % This method should be abstract, but due to some
            % implementation issues it's left as a virtual one. Consider it
            % pure virtual
        end
        
        function SetLocation(self, x, y)
            self.Location = [x;y;1];
        end
        
        function x = GetX(self)
            x = self.Location(1);
        end
        
        function y = GetY(self)
            y = self.Location(2);
        end
        
        function SetOrientationAngle(self, radians)
            self.OrientationAngle = radians;
        end
    end
end

