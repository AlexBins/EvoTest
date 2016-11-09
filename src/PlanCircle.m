classdef PlanCircle
    %PLANCIRCLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PosX;
        PosY;
        Radius;
        RadiansStart;
        RadiansEnd;
        Direction;
    end
    
    methods
        function plan = PlanCircle(radius, radiansStart, radiansEnd, direction)
            % radius: the radius of the circle
            % radiansStart: the start angle in radians, where the car
            % starts driving
            % radiansEnd: the end angle in radians, where the car stops
            % driving
            plan.Radius = radius;
            plan.RadiansStart = radiansStart;
            plan.RadiansEnd = radiansEnd;
            plan.Direction = direction;
        end
        
        function ctrl_signal = CalculateControlSignal(self, velocity, axisDistance)
            % Based on the shape, calculate the (velocity,
            % steering_angle, duration) tuple from the velocity and the
            % distance between the axis
            if self.Direction
                dAngle = self.RadiansEnd - self.RadiansStart;
            else
                dAngle = self.RadiansStart - self.RadiansEnd;
            end
            steering_angle = atan(axisDistance/self.Radius);
            distance = dAngle*self.Radius;
            duration = distance / velocity;
            ctrl_signal = [velocity steering_angle duration];
        end
    end
    
end

