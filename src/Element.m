classdef Element < handle
    %ELEMENT Interface for an element in the current scenario
    %   
    properties
        Location
        OrientationAngle
    end
    
    methods
        function obj = Element(x, y, rad)
            obj.Location = [x; y; 1];
            obj.OrientationAngle = rad;
        end
        
        function Draw(self)
            % This method should be abstract, but due to some
            % implementation issues it's left as a virtual one. Consider it
            % pure virtual
        end
        
        function SetLocation(self, x, y)
            % SETLOCATION   Sets the location of this element
            %   param x = x coordinate
            %   param y = y coordinate
            self.Location = [x;y;1];
        end
        
        function x = GetX(self)
            % GETX   Gets the x coordinate of this element
            x = self.Location(1);
        end
        
        function y = GetY(self)
            % GETY   Gets the y coordinate of this element
            y = self.Location(2);
        end
        
        function SetOrientationAngle(self, radians)
            % SETORIENTATIOANGLE   Sets the orientation angle of this
            % element
            %    param radians = angle from x-axis in radians
            %    (counter-clock-wise)
            self.OrientationAngle = radians;
        end
        
        function rad = GetOrientationRadians(self)
            % GETORIENTATIONRADIANS   Gets the angle of this element in
            % radians (counter-clock-wise)
            rad = self.OrientationAngle;
        end
    end
end

