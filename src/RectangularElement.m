classdef RectangularElement < Element
    %RECTANGULARELEMENT A rectangular element in the current scenario
    %   Detailed explanation goes here
    
    properties (Access = public)
        Width
        Height
    end
    
    properties (Access = protected)
        plot_handle
    end
    
    methods
        function obj = RectangularElement(centerx, centery, width, height, angle)
            obj = obj@Element(centerx, centery, angle);
            obj.Width = width;
            obj.Height = height;
        end
        
        function Draw(self, varargin)
            if (length(varargin) < 1)
                color = 'b';
            else
                color = varargin{1};
            end
            x = self.GetX();
            y = self.GetY();
            rect = CreateRectangle(x - self.Width / 2, y - self.Height / 2, self.Width, self.Height);
            tlin = CreateTranslation(-x, -y);
            tlout = CreateTranslation(x, y);
            rot = CreateRotation(self.GetOrientationRadians());
            rect = tlout * rot * tlin * rect;
            self.plot_handle = fill(rect(1,:), rect(2,:), color);
        end
        
        function rect = GetRectangle(self)
            rect = CreateRectangle(x - self.Width / 2, y - self.Height / 2, self.Width, self.Height);
        end
    end
    
end

