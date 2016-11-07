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
        
        
        function Move(self, velocity, steering_angle, dt)
            % get the current state that has to be modified
            % in order to apply a simple matrix multiplication
            state = [self.GetX(); self.GetY(); self.GetOrientationRadians()];
                    
            % generate control matrix:
            % position is moved by velocity in a certain direction (x,y)
            % orientation is changed according to the steering_angle and
            % the axis offset and the velocity
            control = [cos(state(3))*dt; sin(state(3))*dt; dt*tan(steering_angle)/self.Width(1)];
            new_state = state  + control * velocity;
            
            % apply the new state vector to the car
            self.SetLocation(new_state(1), new_state(2));
            self.SetOrientationAngle(new_state(3));
        end
    end
    
end

