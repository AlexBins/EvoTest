function drawGS(gs)
    for i = 1:gs.length()
        element = gs.getAt(i);
        if isa(element, 'PlanCircle')
            viscircles([element.PosX, element.PosY], element.Radius, 'Color', 'b');
        else
        end
    end
end