classdef Car < RectangularElement
    %CAR The car of the current scenario
    %   Detailed explanation goes here
    
    properties
        arrowHandle
        canredraw
        dt
    end
    
    methods
        function obj = Car(x, y, angle)
            obj = obj@RectangularElement(x, y, 1.125, 0.75, angle);
            obj.canredraw = false;
            obj.dt = 0.1;
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
        
        
        function Move(self, velocity, steering_angle)
            state = [self.GetX(); self.GetY(); self.GetOrientationRadians()];
                    
            control = [cos(state(3))*self.dt; sin(state(3))*self.dt; self.dt*tan(steering_angle)/self.Width(1)];
            new_state = state  + control * velocity;
            
            self.SetLocation(new_state(1), new_state(2));
            self.SetOrientationAngle(new_state(3));
        end
    end
    
end

