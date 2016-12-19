classdef Car < RectangularElement
    %CAR The car of the current scenario
    %   Detailed explanation goes here
    
    properties
        arrowHandle
        canredraw
        maxSteeringAngle
        dt
    end
    
    methods
        function obj = Car(x, y, angle, varargin)
            obj = obj@RectangularElement(x, y, 1.125, 0.75, angle);
            obj.canredraw = false;
            if ~isempty(varargin)
                obj.maxSteeringAngle = varargin{1};
            else
                obj.maxSteeringAngle = pi/4;
            end
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
            if abs(steering_angle) > self.maxSteeringAngle
                throw(MException('Car:moveAngleToBig','Please provide another steering angle'));
            end
            % Get the orientation before
            orientation_before = self.GetOrientationRadians();
            % Calculate the orientation offset
            orientation_control = tan(steering_angle) / self.Width;
            % Calculate the orientation afterwards
            orientation_after = orientation_before + orientation_control * velocity * dt;
            
            % Calculate the average to get a better approximation of the
            % location
            orientation_avg = (orientation_after + orientation_before) / 2;
            % Get the location before
            location_before = [self.GetX(); self.GetY()];
            % Calculate the offset direction
            location_control = [cos(orientation_avg); sin(orientation_avg)];
            % Calculate the location afterwards
            location_after = location_before + location_control * velocity * dt;
            
            % Set the values accordingly
            self.SetLocation(location_after(1), location_after(2));
            self.SetOrientationAngle(orientation_after);

            % Deprecated due to a minor bug. Implementation above splits
            % the following into seperate orientation and location
            % calculation and uses the average orientation for the latter
%             % get the current state that has to be modified
%             % in order to apply a simple matrix multiplication
%             state = [self.GetX(); self.GetY(); self.GetOrientationRadians()];
%                     
%             % generate control matrix:
%             % position is moved by velocity in a certain direction (x,y)
%             % orientation is changed according to the steering_angle and
%             % the axis offset and the velocity
%             control = [cos(state(3))*dt; sin(state(3))*dt; dt*tan(steering_angle)/self.Width];
%             new_state = state  + control * velocity;
%             
%             % apply the new state vector to the car
%             self.SetLocation(new_state(1), new_state(2));
%             self.SetOrientationAngle(new_state(3));
        end
    end
    
end

