function [coll, dist] = fRectDist(A, B)
% INPUT: A, B - matrices with rectangle coordinates [x;y] for 4 vertices in order: 
% LowerLeft, LowerRigt, UpRigth, UpLeft
%A = [0, 1, 1, 0; 0, 0, 1, 1];
%B = [0, 1, 1, 0; 2, 2, 3, 3];

% calculate axes for projection
%A
a1 = A(:,2) - A(:,1);
a2 = A(:,4) - A(:,1);
%B
a3 = B(:,2) - B(:,1);
a4 = B(:,4) - B(:,1);
axes = [a1, a2, a3, a4];
out = struct('A',[],'B',[], 'projax', [], 'maxA', [], 'minA', [], 'maxB', [], 'minB', [], 'dist', []);
coll = 1;


% Project all rectangle vertices on axes
for a = 1 : 4 % iterate over projecting axes
%     if coll == 0
%         break
%     end
ax = axes(:, a);
out(a).projax = ax;
dist = nan;

% project each vertex of rectangle A on selected projecting ax
outA = [];
for i = 1:4
        vertex = A(:, i);
        proj = vertex'* ax/(ax'*ax)*ax; 
        outA = [outA, proj];        
end


% save projected vectors to struct
out(a).A = outA;
[out(a).maxA(1,1), out(a).maxA(1,2)]  = max(ax'*outA); % dot muplitply projected vector by the projection axis to get scalar value for comparison
[out(a).minA(1,1), out(a).minA(1,2)]  = min(ax'*outA);

% project each vertex of rectangle B on selected projecting ax
outB = [];
for i = 1:4
        vertex = B(:, i);
        proj = vertex'* ax/(ax'*ax)*ax; 
        outB = [outB, proj];
end

% save to struct
out(a).B = outB;
[out(a).maxB(1,1), out(a).maxB(1,2)]  = max(ax'*outB);
[out(a).minB(1,1), out(a).minB(1,2)]  = min(ax'*outB);

% evaluate collision
coll = 1;
% check collision and calculate distance in no collision
% compare scalar values and decide if rectangles overlap
% TD: write function for euclidian distance
if (out(a).maxA(1,1) < out(a).minB(1,1)) ||  (out(a).maxB(1,1) < out(a).minA(1,1))
    coll = 0;
    if (out(a).maxA(1,1) < out(a).minB(1,1))
        dist = (((out(a).B(1, out(a).minB(1,2))-out(a).A(1, out(a).maxA(1,2)))^2 + (out(a).B(2, out(a).minB(1,2))-out(a).A(2, out(a).maxA(1,2)))^2))^0.5;
  
    else
        dist = (((out(a).A(1, out(a).minA(1,2))-out(a).B(1, out(a).maxB(1,2)))^2 + (out(a).A(2, out(a).minA(1,2))-out(a).B(2, out(a).maxB(1,2)))^2))^0.5;
        
    end
end
out(a).dist = dist;
end
mdist = nan;

 
for j = 1:4
    if (isnan(mdist) ==1) || (out(j).dist > mdist)
        mdist = out(j).dist;
    end
end

dist = mdist;

if isnan(dist)
    coll = 1;
else
    coll = -1;
end
end