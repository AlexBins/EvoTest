classdef DubinsCar
    %DUBINSCAR Method collection used in the implementation of the dubin's car model
    
    methods (Static)
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

        function tinv = getInvTraject(t)
            % reverse the order of columns in the matrix to get the reverse of a given
            % trajectory
            tinv = [t(:,3), t(:,2), t(:, 1)];
       end
        
        function d = getEncDir(sd, pos)
            switch sd(pos)
                case 'R'
                    d = 1;
                case 'S'
                    d = 0;
                case 'L'
                    d = -1;
                otherwise
                    return;
            end
        end
        
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
                csc = DubinsCar.getCSCTraject(S, G, r, cell2mat(i));
                if ~isnan(csc) 
                    if (isnan(min_csc)) || (min_csc > sum(csc(3,:), 2))
                        min_csc = sum(csc(3,:), 2);
                        % Apparently not used after this line anyways
                        %tr_d = cell2mat(i); 
                        tr_opt = csc;
                    end
                else
                    continue;
                end
            end
            % Find shortest trajectory backward by swapping goal and start
            min_csc_rev = NaN;
            for i = {'RSR', 'RSL', 'LSL', 'LSR'}
                csc_rev = DubinsCar.getCSCTraject(G, S, r, cell2mat(i));
                if ~isnan(csc_rev) 
                    if (isnan(min_csc_rev)) || (min_csc_rev > sum(csc_rev(3,:), 2))
                        min_csc_rev = sum(csc_rev(3,:), 2);
                        % Apparently not used after this line anyways
                        %tr_d_rev = cell2mat(i);
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
                tr_out = DubinsCar.getInvTraject(tr_opt_rev);
                % invert speed/moving direction
                tr_out(1,:) = -1*tr_out(1,:);
            else
                tr_out = tr_opt; % if no improvement use the intially calculated trajectory
            end
        end
        
        function [tr] = getCSCTraject(sp, gp, r, type)
            % calc CSC trajectory 
            vel = 1;
            % get cirles
            crc1 = [sp(1)+ DubinsCar.getEncDir(type, 1)* r*cos(sp(3)-pi/2), sp(2)+ DubinsCar.getEncDir(type, 1)*r*sin(sp(3)-pi/2)];
            crc2 = [gp(1)+ DubinsCar.getEncDir(type, 3)*r*cos(gp(3)-pi/2), gp(2)+DubinsCar.getEncDir(type, 3)*r*sin(gp(3)-pi/2)];

            % set constant speed, forward direction for all phases
            v1 = vel;
            v2 = vel;
            v3 = vel;
            % get tangent
            tl = DubinsCar.getTanLine(crc1, crc2, r, strcat(type(1), type(3)));

            if isnan(tl)
                tr = NaN;
                return;
            end

            tl_length = ((tl(1,2)-tl(1, 1))^2 + (tl(2,2)-tl(2, 1))^2)^0.5;
            % get arcs
            al1 = DubinsCar.getArcLength(crc1, sp(1:2), tl(:,1)', r, DubinsCar.getEncDir(type, 1));
            if al1 >= pi*r
                al1 = 2*pi*r-al1;
                v1 = -1*v1;
            end
            al2 = DubinsCar.getArcLength(crc2, tl(:,2)', gp(1:2), r, DubinsCar.getEncDir(type, 3));
            % drive the smaller arc in reverse if al2 bigger then half the
            % circumference
            if al2 >= pi*r
                al2 = 2*pi*r-al2;
                v3 = -1*v3;
            end
            tr = [v1, v2, v3;
                DubinsCar.getEncDir(type, 1), DubinsCar.getEncDir(type, 2), DubinsCar.getEncDir(type, 3); 
                al1/abs(v1), tl_length/abs(v2), al2/abs(v3)];

        end
        
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
    end
    
end

