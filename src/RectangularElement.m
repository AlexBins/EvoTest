classdef RectangularElement < Element
    %RECTANGULARELEMENT A rectangular element in the current scenario
    %   Detailed explanation goes here
    
    properties
        Width
        Height
        plot_handle
    end
    
    methods
        function obj = RectangularElement(centerx, centery, width, height, angle)
            obj.Location = [ centerx; centery; 1];
            obj.OrientationAngle = angle;
            obj.Width = width;
            obj.Height = height;
        end
        
        function Draw(self, varargin)
            if (length(varargin) < 1)
                color = 'b';
            else
                color = varargin{1};
            end
            x = self.Location(1);
            y = self.Location(2);
            rect = CreateRectangle(x - self.Width / 2, y - self.Height / 2, self.Width, self.Height);
            tlin = CreateTranslation(-x, -y);
            tlout = CreateTranslation(x, y);
            rot = CreateRotation(self.OrientationAngle);
            rect = tlout * rot * tlin * rect;
            self.plot_handle = fill(rect(1,:), rect(2,:), color);
        end
    end
    
end

