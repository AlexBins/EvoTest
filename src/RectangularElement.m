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
            x = self.GetX();
            y = self.GetY();
            w = self.Width;
            h = self.Height;
            a = self.GetOrientationRadians();
            
            l = [x; y];
            s1 = [w; 0];
            s2 = [0; h];
            c = cos(a); s = sin(a);
            rot = [c -s; s c];
            s1 = rot * s1;
            s2 = rot * s2;
            l = l - (s1 + s2) / 2;
            rect = [l, l + s1, l + s1 + s2, l + s2, l];
        end
    end
    
end

