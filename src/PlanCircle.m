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
        function plan = PlanCircle(posX, posY, radius, radiansStart, radiansEnd, direction)
            plan.PosX = posX;
            plan.PosY = posY;
            plan.Radius = radius;
            plan.RadiansStart = radiansStart;
            plan.RadiansEnd = radiansEnd;
            plan.Direction = direction;
        end
        
        function ctrl_signal = CalculateControlSignal(self, velocity, axisDistance)
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

