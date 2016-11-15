classdef ParkingPilot < handle
    %PARKINGPILOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static)
        function [isDirectParkingPossibly, geometricSequence, dubinTarget, dubinOrientation] = tryDirectParking(carX, carY, carOrientation, targetX, targetY, targetOrientation, topofslot, minRadius)
           % debug = true;
            debug = false;
            
            % initialize the results
            geometricSequence = GeometricSequence();
            dubinTarget = [0; 0];
            dubinOrientation = 0;
            
            % vectorize the input (_l = location, _d = direction, _n =
            % normal pointing towards the circle centers, which is towards
            % the street for the slot normal, and towards the other side 
            
            % car
            carl = [carX; carY];
            card = [cos(carOrientation); sin(carOrientation)];
            % target
            targetl = [targetX; targetY];
            targetd = [cos(targetOrientation); sin(targetOrientation)];
            
            % z axis pointing in or out of the drawing pane. depending on
            % this, the side of the circles is chosen
            if acos(dot(card, targetd)) == 0
                upordown = cross([cos(carOrientation + 0.01); sin(carOrientation + 0.01); 0], [targetd(1); targetd(2); 0]);
            else 
                upordown = cross([card(1); card(2); 0], [targetd(1); targetd(2); 0]);
            end
            upordown = [0; 0; sign(upordown(3))];
            upordown = [0; 0; -sign(topofslot)];
            
            % get normals
            carnp = cross(upordown, [card; 0]);
            carn = [carnp(1); carnp(2)];
            
            targetnp = cross([targetd; 0], [0; 0; -sign(topofslot)]);
            targetn = [targetnp(1); targetnp(2)];
            
            if debug
               quiver(carl(1), carl(2), card(1), card(2), 'Color', 'b');
               quiver(targetl(1), targetl(2), targetd(1), targetd(2), 'Color', 'b');
               
               quiver(carl(1), carl(2), carn(1), carn(2), 'Color', 'r');
               quiver(targetl(1), targetl(2), targetn(1), targetn(2), 'Color', 'r');
            end
            
            % calculate the target turning circle 
            radtarget = minRadius;
            circtarget = targetl + targetn * radtarget;
            
            if debug
                viscircles([circtarget(1), circtarget(2)], radtarget, 'Color', 'b');
            end
            % calculate the car turning circle necessary for direct parking
            % (touching the target circle)
            % the center is the intersection of the line through the car
            % location in direction of the car normal AND the orthogonal
            % line through the middle of the car location and the closest
            % point on the target circle.
            % Correction: the calculated point is close to correct, but not
            % completly. Thus after that, there is an iterative algorithm
            % looking for the actual point since the analytic approach is
            % too complicated
            cartotargetcircle = circtarget - carl;
            closestpointontargetcircle = carl + cartotargetcircle - cartotargetcircle / norm(cartotargetcircle) * radtarget;
            orthogonaldirectionp = cross([cartotargetcircle; 0], upordown);
            orthogonaldirection = [orthogonaldirectionp(1); orthogonaldirectionp(2)];
            orthogonalstart = (closestpointontargetcircle + carl) / 2;
            orthogonalline = cross(PointToProj(orthogonalstart), PointToProj(orthogonalstart + orthogonaldirection));
            carline = cross(PointToProj(carl), PointToProj(carl + carn));
            circcarp = cross(carline, orthogonalline);
            
            if debug
                plot([carl(1) circtarget(1)], [carl(2) circtarget(2)], 'b:');
                plot(closestpointontargetcircle(1), closestpointontargetcircle(2), 'bx');
                quiver(orthogonalstart(1), orthogonalstart(2), orthogonaldirection(1) / norm(orthogonaldirection), orthogonaldirection(2) / norm(orthogonaldirection), 'Color', 'b');
            end
            
            
            % transform the point from projective geometry to normal
            % 2D geometry
            circcar = PointFromProj(circcarp);
            
            if debug
                plot(circcar(1), circcar(2), 'rx');
            end
            
            % iterative enhancement
            [tmpx, tmpy, tmpr] = getCircle(circtarget(1), circtarget(2), radtarget,...
                carl(1), carl(2), carn(1), carn(2), norm(circcar - carl) / norm(carn));
            circcar = [tmpx; tmpy];
            radcar = tmpr;
            
            if debug
                plot(circcar(1), circcar(2), 'bx');
                viscircles([circcar(1) circcar(2)], radcar, 'Color', 'b');
            end
            % the radius of the turning circle at the car is the distance
            % between the target circle center and the car circle center
            % minus the target circle radius
            %radcar = norm(circcar - carl);
            
            % directparking is only possible if the radius is at least the
            % minimum turning circle's radius
            if radcar < minRadius
                isDirectParkingPossibly = false;
            else
                isDirectParkingPossibly = true;
            end
            
            % if direct parking is possible, add the circle definitions to
            % the geometric sequence, else calculate the dubin's car target
            % location and direction
            if isDirectParkingPossibly
                
                ParkingPilot.fillWithElements(geometricSequence,...
                    carl, carn, targetl, targetn,...
                    circcar, circtarget, radcar, radtarget,...
                    card, targetd, debug);
            else % direct parking not possible => get dubin target position
                dir = turn2DVec(targetd, 7 * pi / 6);
                dir = dir / norm(dir);
                circcar = circtarget + dir * 2 * minRadius;
                radcar = minRadius;
                
                dubinOrientation = targetOrientation;
                dubinTarget = circcar + targetn * radcar;
                
                ParkingPilot.fillWithElements(geometricSequence,...
                    dubinTarget, -targetn, targetl, targetn, circcar, circtarget,...
                    radcar, radtarget, targetd, targetd, debug);
                
                if debug
                    drawGS(geometricSequence);
                    quiver(dubinTarget(1), dubinTarget(2), targetd(1) * 3, targetd(2) * 3, 'Color', 'r');
                end
            end
        end
        
        function fillWithElements(geometricSequence, ...
                carl, carn, targetl, targetn,...
                circcar, circtarget, radcar, radtarget, card, targetd,...
                debug)
                
                entryAngleCar = asin(-carn(2));
                % this calculation is robust in comparions to atan
                % considering division through zero but only returns and
                % angle with absolut value smaller or equal to 90 degree
                % => turn it when the direction vector points rather left
                % than right
                if carn(1) < 0
                    entryAngleCar = pi - entryAngleCar;
                end
                exitAngleTarget = asin(-targetn(2));
                if targetn(1) < 0
                    exitAngleTarget = pi - exitAngleTarget;
                end
                
                cartotarget = circtarget - circcar;
                cartotarget = cartotarget / norm(cartotarget);
                
                exitAngleCar = asin(cartotarget(2));
                entryAngleTarget = asin(-cartotarget(2));
                if cartotarget(1) < 0
                    exitAngleCar = pi - exitAngleCar;
                else
                    entryAngleTarget = pi - entryAngleTarget;
                end
                
                distCar = mod(exitAngleCar + 2 * pi - entryAngleCar, 2 * pi);
                
                if distCar > pi
                    dirCar = -1;
                    distCar = 2 * pi - distCar;
                else
                    dirCar = 1;
                end
                
                distTarget = mod(exitAngleTarget + 2 * pi - entryAngleTarget, 2 * pi);
                
                if distTarget > pi
                    dirTarget = -1;
                    distTarget = 2 * pi - distTarget;
                else
                    dirTarget = 1;
                end
                
                circ1 = PlanCircle(radcar, entryAngleCar, exitAngleCar, dirCar);
                circ1.PosX = circcar(1);
                circ1.PosY = circcar(2);
                
                circ2 = PlanCircle(radtarget, entryAngleTarget, exitAngleTarget, dirTarget);
                circ2.PosX = circtarget(1);
                circ2.PosY = circtarget(2);
                
                % calculate the driving direction
                cen = circtarget;
                
                outl = targetl;
                outd = targetd;
                inl = cen + turn2DVec(outl - cen, -distTarget * dirTarget);
                ind = turn2DVec(outd, -distTarget * dirTarget);
                
                if debug
                   quiver(inl(1), inl(2), ind(1), ind(2), 'Color', 'r'); 
                end
                
                targetforward = ...
                    isLeftOfLine(outl, cen, outl + outd) * ...
                    -isLeftOfLine(outl, cen, inl);
                
                cen = circcar;
                outl = inl;
                outd = ind;
                inl = carl;
                ind = card;
                
                carforward = ...
                    isLeftOfLine(outl, cen, outl + outd) * ...
                    -isLeftOfLine(outl, cen, inl);
                
                circ1.Forward = carforward;
                circ2.Forward = targetforward;
                
                geometricSequence.add(circ1);
                geometricSequence.add(circ2);
        end
        
        function [targetLocation, targetOrientation] = getTarget(...
                slotX, slotY, slotOrientation, slotLength, slotDepth, carX, carY, carLength, carWidth)
            %debug = true;
            debug = false;
            
            % since the target direction is the same as the slot direction
            % => (direction is normalized due to sin/cos properties)
            targetOrientation = slotOrientation;
            targetDirection = [cos(slotOrientation); sin(slotOrientation)];
            % vectorize locations
            slotLocation = [slotX; slotY];
            carLocation = [carX; carY];
            % direction vector of the parking slot
            slotDirection = [cos(slotOrientation); sin(slotOrientation)];
            % normal vector of the parking slot (pointing towards the
            % "left" of the direction)
            slotNormalProjected = cross([0; 0; 1], [slotDirection; 0]);
            slotNormal = [slotNormalProjected(1); slotNormalProjected(2)];
            % Using property of the cross product:
            %  given points a b c (projected geometry) and
            %   v := cross(b - a, c - a)
            %  c is to the left of the line through a and b <=> v(3) > 0
            %  c is on the line through a and b <=> v(3) = 0
            %  c is to the right of the line through a and b <=> v(3) < 0
            a = [slotLocation; 1];
            b = [slotLocation + slotNormal; 1];
            % c := carLocation
            v = cross(b - a, [carLocation; 1] - a);
            sgn = sign(v(3));
            
            % for simplification: treat sgn = 0 (car in the middle of the
            % parking slot) like sgn = -1 (car to the right of the normal
            % through the parking slot
            if sgn == 0
                sgn = -1;
            end
            
            % calculating the distance for the target location to the car
            % center
            % TODO: currently using abosult values (0.25). Try calculating the outer radius of the car edges or something like this 
            offsetFrontBack = carLength / 2 + carWidth  * 0.05;
            
            % if the car is to the left of the slot => position the target
            % IN POITIVE slot direction at the closest point to the street
            % (top side ?!). if the car is to the right of the slot =>
            % position the target IN NEGATIVE slot direction at the closest
            % point to the street (top side ?!). It doesn't matter in which
            % direction the slot is pointing (left side parking or right
            % side. this is taken care of during slotNormal calculation by
            % attributes of the cross product)
            targetLocation = ... Center of the slot
                [slotX; slotY] +...
                ... Move to the front / back of the parking slot with
                ... offset calculated above
                sgn * ((slotLength / 2) - offsetFrontBack) * targetDirection +...
                [0; slotDepth / 2 - carWidth / 2 - 0.05 * carLength];
            
            if debug
                x = [targetLocation(1) - carLength / 2, targetLocation(1) + carLength / 2, targetLocation(1) + carLength / 2, targetLocation(1) - carLength / 2];
                y = [targetLocation(2) - carWidth / 2, targetLocation(2) - carWidth / 2, targetLocation(2) + carWidth / 2, targetLocation(2) + carWidth / 2];
                fill(x, y, 'y');
                quiver(targetLocation(1), targetLocation(2), targetDirection(1) * 3, targetDirection(2) * 3, 'Color', 'r');
                quiver(slotX, slotY, targetDirection(1) * 3, targetDirection(2) * 3, 'Color', 'b');
                plot(carX, carY, 'bx');
                x = [slotX + slotLength / 2 slotX + slotLength / 2 slotX - slotLength / 2 slotX - slotLength / 2];
                y = [slotY + slotDepth / 2 slotY - slotDepth / 2 slotY - slotDepth / 2 slotY + slotDepth / 2];
                plot(x, y, 'b');
            end
        end
    end
    
end

