classdef CircularElement < Element
    %CIRCULARELEMENT A circular element in the current scenario
    %   Detailed explanation goes here
    
    properties
        Radius
    end
    
    methods
        function obj = CircularElement(x, y, radius)
            obj.Location = [x; y; 1];
            obj.OrientationAngle = 0;
            obj.Radius = radius;
        end
        
        function Draw(self)
            x = self.Location(1);
            y = self.Location(2);
            rectangle('Position', [x - self.Radius, y - self.Radius, self.Radius * 2, self.Radius * 2], 'Curvature', [1 1]);
        end
    end
    
end

