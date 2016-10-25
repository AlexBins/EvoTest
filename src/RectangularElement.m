classdef RectangularElement < Element
    %RECTANGULARELEMENT A rectangular element in the current scenario
    %   Detailed explanation goes here
    
    properties
        Width
        Height
    end
    
    methods
        function obj = RectangularElement(centerx, centery, width, height, angle)
            obj.Location = [ centerx; centery; 1];
            obj.OrientationAngle = angle;
            obj.Width = width;
            obj.Height = height;
        end
        
        function Draw(self)
            x = self.Location(1);
            y = self.Location(2);
            rect = CreateRectangle(x - self.Width / 2, y - self.Height / 2, self.Width, self.Height);
            tlin = CreateTranslation(-x, -y);
            tlout = CreateTranslation(x, y);
            rot = CreateRotation(self.OrientationAngle);
            rect = tlout * rot * tlin * rect;
            plot(rect(1,:), rect(2,:))
        end
    end
    
end

