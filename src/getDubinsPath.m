% TODO Replace with the implementation in DubinsCar.getDubinsPath
function tr_out = getDubinsPath(S, G, r )
% This funtions finds the shortest CSC path from point S to point G
% Each Path consists of a 3 subpaths : Left/Right, Straight, Left/Right
% driven forwards or backwards
% INPUT: 
% S - 1x3 vector [x, y, phi], where (x, y) - coordinates of the start
% position; phi - heading of the car at start position in radians
% G - same as S for the goal position
% r - radius of the minimal turning circle of the vehicle
% OUTPUT:
% a 3x3 matrix of steering signals where each column vector is of type [velocity, steering_angle, duration]
% velocity: positive => forward movement; negative => backward movement; 
% steering_angle: -1 => full left; 1 => full right; 0 => straight

% Find shortest CSC trajectory, forward
min_csc = NaN;
for i = {'RSR', 'RSL', 'LSL', 'LSR'}
[csc, hc1, hc2, hl] = getCSCTraject(S, G, r, cell2mat(i));
if ~isnan(csc) 
if (isnan(min_csc)) || (min_csc > sum(csc(3,:), 2))
min_csc = sum(csc(3,:), 2);
tr_d = cell2mat(i);
tr_opt = csc;
end
else
    continue;
end

end
% Find shortest trajectory backward by swapping goal and start
min_csc_rev = NaN;
for i = {'RSR', 'RSL', 'LSL', 'LSR'}
csc_rev = getCSCTraject(G, S, r, cell2mat(i));
if ~isnan(csc_rev) 
if (isnan(min_csc_rev)) || (min_csc_rev > sum(csc_rev(3,:), 2))
min_csc_rev = sum(csc_rev(3,:), 2);
tr_d_rev = cell2mat(i);
tr_opt_rev = csc_rev;
end
else
    continue;
end

end

if (min_csc_rev < min_csc)
% use optimal reverse trajectory in swapped order and velocity if it
% presents a better solution

% invert order of signals
tr_out = getInvTraject(tr_opt_rev);
% invert speed/moving direction
tr_out(1,:) = -1*tr_out(1,:);
else
    tr_out = tr_opt; % if no improvement use the intially calculated trajectory
end

end

