% TODO Replace with implementation in DubinsCar.getArcLength
function al = getArcLength(center, p1, p2, radius, left)
v1 = p1'-center';
v2 = p2' - center';

theta = atan2(v2(2),v2(1)) - atan2 (v1(2), v1(1));
if (theta < 0) && (left==-1)
    theta = theta + 2*pi;
elseif (theta > 0) && ~(left==-1)
    theta = theta - 2*pi;
end
al = abs(theta * radius);

end