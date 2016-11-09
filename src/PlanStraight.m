classdef PlanStraight
    %PLANSTRAIGHT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        StartX;
        StartY;
        EndX;
        EndY;
    end
    
    methods
        function plan = PlanStraight(startX, startY, endX, endY)
            plan.StartX = startX;
            plan.StartY = startY;
            plan.EndX = endX;
            plan.EndY = endY;
        end
        
        function ctrl_signal = CalculateControlSignal(self, velocity)
            distance = power(power(self.StartX-self.EndX, 2)+power(self.StartY-self.EndY, 2), 0.5);
            duration = distance / velocity;
            ctrl_signal = [velocity 0 duration];
        end
    end
end

