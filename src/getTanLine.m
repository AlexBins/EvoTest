% TODO Replace with the implementation in DubinsCar.getTanLine
function tl = getTanLine(c1, c2, r, type)

d_sq = (c2(1)-c1(1))^2 + (c2(2)-c1(2))^2;
d = d_sq^0.5;
vx = (c2(1)-c1(1))/d;
vy = (c2(2)-c1(2))/d;

switch type
    case 'RR'
        sign1 = 1; 
        sign2 = 1;
    case 'LL'
        sign1 =  1; 
        sign2 = -1;
    case 'RL'
        sign1 = -1; 
        sign2 =  1;
    case 'LR'
        sign1 = -1; 
        sign2 = -1;
    otherwise
        return;
end

c = (r-sign1*r)/d;
if (c*c > 1)
    tl = NaN;
    return;
end
h = (max(0, 1-c*c))^0.5;

nx = vx*c - sign2*h*vy;
ny = vy*c+sign2*h*vx;
t1 = [c1(1)+r*nx, c1(2)+r*ny];
t2 = [c2(1)+sign1*r*nx, c2(2)+sign1*r*ny];
tl = [t1',t2'];

end
