% TODO Replace with the implementation in GeometricUtility.PointFromProj
% DONE
function r = PointFromProj( p )
    r = [p(1); p(2)] / p(3);
end

