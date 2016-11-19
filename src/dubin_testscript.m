%Initial data
r = 1;
S = [1, 4, pi/2];
G = [1.5, 0.5, pi/2];

%Setup graph
figure;
hold on;
axis equal;

z = getDubinsPath(S, G, r);

% Manually create cricles for drawing
% Start
P = S;
C1 = struct('R', [], 'L', []);
C2 = struct('R', [], 'L', []);

C1.R = [P(1)+r*cos(P(3)-pi/2), P(2)+r*sin(P(3)-pi/2)];
C1.L = [P(1)-r*cos(P(3)-pi/2), P(2)-r*sin(P(3)-pi/2)];

% view circles
crplot(C1.R(1), C1.R(2), r); 
crplot(C1.L(1), C1.L(2), r);

% Goal
P = G;
C2.R = [P(1)+r*cos(P(3)-pi/2), P(2)+r*sin(P(3)-pi/2)];
C2.L = [P(1)-r*cos(P(3)-pi/2), P(2)-r*sin(P(3)-pi/2)];

crplot(C2.R(1), C2.R(2), r); 
crplot(C2.L(1), C2.L(2), r);


% Find shortest CSC trajectory, forward
min_csc = NaN;
for i = {'RSR', 'RSL', 'LSL', 'LSR'}
csc = getCSCTraject(S, G, r, cell2mat(i));
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

% Find shortest CCC trajectory
% min_CCC = NaN;
% for j = {'RLR', 'LRL'}
% ccc = getCCCTraject(S, G, r, cell2mat(j));
% if ~isnan(csc) 
% if (isnan(min_csc)) || (min_csc > sum(csc(2,:), 2))
% min_csc = sum(csc(2,:), 2);
% tr_d = cell2mat(i);
% tr_opt = csc;
% end
% else
%     continue;
% end
% end
