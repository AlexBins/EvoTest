classdef Car < RectangularElement
    %CAR The car of the current scenario
    %   Detailed explanation goes here
    
    properties
        Velocity
        arrowHandle
        canredraw
    end
    
    methods
        function obj = Car(x, y, angle)
            obj = obj@RectangularElement(x, y, 1.125, 0.75, angle);
            obj.canredraw = false;
            obj.Velocity = [ 0; 0; 0 ];
        end
        
        function Draw(self)
            self.Draw@RectangularElement('r');
            dx = cos(self.GetOrientationRadians());
            dy = sin(self.GetOrientationRadians());
            x = self.GetX();
            y = self.GetY();
            self.arrowHandle = quiver(x, y, dx, dy, 'k');
            self.canredraw = true;
        end
        
        function Redraw(self)
            if self.canredraw
                delete(self.plot_handle);
                delete(self.arrowHandle);
            end
            self.Draw();
        end
    end
    
end

