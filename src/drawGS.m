% TODO Replace with implementation in Utility.drawGS
% DONE
function drawGS(gs)
    for i = 1:gs.length()
        element = gs.getAt(i);
        if isa(element, 'PlanCircle')
            GeometricUtility.plotCircle(element.PosX, element.PosY,...
                element.Radius, element.RadiansStart, ...
                element.RadiansEnd, element.Direction);
        else
        end
    end
end