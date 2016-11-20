function [tr, handlec1, handlec2, handlel1] = getCSCTraject(sp, gp, r, type)
debug = false;

% calc CSC trajectory 
vel = 1;
% get cirles
crc1 = [sp(1)+ getEncDir(type, 1)* r*cos(sp(3)-pi/2), sp(2)+ getEncDir(type, 1)*r*sin(sp(3)-pi/2)];
crc2 = [gp(1)+ getEncDir(type, 3)*r*cos(gp(3)-pi/2), gp(2)+getEncDir(type, 3)*r*sin(gp(3)-pi/2)];

if debug
    handlec1 = viscircles(crc1, r, 'Color', 'y');
    handlec2 = viscircles(crc2, r, 'Color', 'y');
else
    handlec1 = [];
    handlec2 = [];
end

% set constant speed, forward direction for all phases
v1 = vel;
v2 = vel;
v3 = vel;
% get tangent
tl = getTanLine(crc1, crc2, r, strcat(type(1), type(3)));

if isnan(tl)
    tr = NaN;
    handlel1 = [];
    return;
end

if debug
    handlel1 = plot(tl(1, :), tl(2, :), 'y');
else
    handlel1 =[];
end

tl_length = ((tl(1,2)-tl(1, 1))^2 + (tl(2,2)-tl(2, 1))^2)^0.5;
% get arcs
al1 = getArcLength(crc1, sp(1:2), tl(:,1)', r, getEncDir(type, 1));
if al1 >= pi*r
al1 = 2*pi*r-al1;
v1 = -1*v1;
end
al2 = getArcLength(crc2, tl(:,2)', gp(1:2), r, getEncDir(type, 3));
% drive the smaller arc in reverse if al2 bigger then half the
% circumference
if al2 >= pi*r
al2 = 2*pi*r-al2;
v3 = -1*v3;
end
tr = [v1, v2, v3;
    getEncDir(type, 1), getEncDir(type, 2), getEncDir(type, 3); 
    al1/abs(v1), tl_length/abs(v2), al2/abs(v3)];

% calc circles
% tangent
%tanline = getTanLine(C1.L, C2.R, r, 'LR');
%plot(tl(1,:), tl(2,:))

end
