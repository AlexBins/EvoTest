% TODO Replace with implementation in GeometricUtility.distancePointLine
% DONE
% Annotation: Unused, consider removing
function [ distance, pl ] = distancePointLine( pp, l )
    l1 = [l(1, 1) l(2, 1)];
    l2 = [l(1, 2) l(2, 2)];
    p = [pp(1, 1) pp(2, 1)];
    
    va = l2 - l1;
    vb = p - l1;
    
    sqrL = dot(va, va);
    scale = dot(va, vb) / sqrL;
    
    if(scale > 1)
        scale = 1;
    elseif (scale < 0)
        scale = 0;
    end
    
    pl = l1 + scale * va;
    distance = sqrt(dot(pl - p, pl - p));
end