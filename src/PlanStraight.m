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
    end
    
end

