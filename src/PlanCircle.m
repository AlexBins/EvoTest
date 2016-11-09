classdef PlanCircle
    %PLANCIRCLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PosX;
        PosY;
        Radius;
        Arc_start;
        Arc_end;
        Direction;
    end
    
    methods
        function plan = PlanCircle(posX, posY, radius, arc_start, arc_end, direction)
            plan.PosX = posX;
            plan.PosY = posY;
            plan.Radius = radius;
            plan.Arc_start = arc_start;
            plan.Arc_end = arc_end;
            plan.Direction = direction;
        end
    end
    
end

