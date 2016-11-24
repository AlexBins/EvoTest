classdef PlanCircle < PlanObject
    %PLANCIRCLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PosX;
        PosY;
        Radius;
        RadiansStart;
        RadiansEnd;
        Direction;
        Forward;
    end
    
    methods
        function plan = PlanCircle(radius, radiansStart, radiansEnd, direction)
            % radius: the radius of the circle
            % radiansStart: the start angle in radians, where the car
            % starts driving
            % radiansEnd: the end angle in radians, where the car stops
            % driving
            plan.Radius = radius;
            plan.RadiansStart = mod(radiansStart, 2 * pi);
            plan.RadiansEnd = mod(radiansEnd, 2 * pi);
            plan.Direction = direction;
            plan.Forward = 1;
        end
        
        function ctrl_signal = CalculateControlSignal(self, velocity, axisDistance)
            debug = false;
            
            % Based on the shape, calculate the (velocity,
            % steering_angle, duration) tuple from the velocity and the
            % distance between the axis
            if sign(self.Direction) == +1
                dAngle = self.RadiansEnd - self.RadiansStart;
            else
                dAngle = self.RadiansStart - self.RadiansEnd;
            end
            dAngle = mod(dAngle + 2 * pi, 2 * pi);
            
            % steering direction:
            % bool: 1       | 0
            % f =   forward | backward
            % d =   clockw  | counterclockw
            % steer = left  | right
            %
            % f | d || s
            % 1 | 1 || 1
            % 1 | 0 || 0
            % 0 | 1 || 0
            % 0 | 0 || 1
            % 
            % numeric: s = f * d since s = +1 = left s= -1 = right
            
            steering_direction = sign(self.Direction) * sign(self.Forward);
            steering_angle = atan(axisDistance/self.Radius) * steering_direction;
            distance = dAngle*self.Radius;
            duration = abs(distance / velocity);
            v = velocity * sign(self.Forward);
            ctrl_signal = [v steering_angle duration];
            if debug
                if sign(self.Direction) == +1
                    start = self.RadiansStart;
                else
                    start = self.RadiansEnd;
                end
                rad = start:0.1:dAngle + start;
                X = cos(rad) * self.Radius + self.PosX;
                Y = sin(rad) * self.Radius + self.PosY;
                plot(X, Y, 'r');
            end
        end
    end
end

