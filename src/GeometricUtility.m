classdef GeometricUtility
    
    methods (Static)
        function [direction, radDist] = GetShorterDirection(radIn, radOut)
            radIn = mod(radIn, 2 * pi);
            radOut = mod(radOut, 2 * pi);
            
            if radOut < radIn
                radOut = radOut + 2 * pi;
            end
            
            radDist = radOut - radIn;
            
            if radDist > pi
                direction = -1;
                radDist = 2 * pi - radDist;
            else
                direction = 1;
            end
        end
        
        function angle = GetAngle(vector)
            x = vector(1);
            y = vector(2);
            if x == 0
                if y == 0
                    angle = NaN;
                elseif y > 0
                    angle = pi / 2;
                else
                    angle = -pi / 2;
                end
            elseif x > 0
                angle = atan(y / x);
            elseif y < 0
                angle = atan(y / x) - pi;
            else
                angle = atan(y / x) + pi;
            end
        end
        
        function [ v ] = turn2DVec( vec, rad )
            mat = [cos(rad) -sin(rad); sin(rad) cos(rad)];
            v = mat * vec;
        end

        function [ isEqual ] = ProjLineEqual( l1, l2 )
            l1 = l1 / norm(l1);
            l2 = l2 / norm(l2);
            isEqual = isequal(l1, l2) || isequal(l1, -l2);
        end
        
        function [ r ] = PointToProj( p )
            r = [p(1); p(2); 1];
        end
        
        function r = PointFromProj( p )
            r = [p(1); p(2)] / p(3);
        end
        
        function [ handle ] = plotCircle( x, y, radius, varargin )
            % plotcircle: Plots a circle around (x, y) with the given radius.
            %   'if alpha and beta are not given, the whole circle is drawn
            %   'if direction is not given, clockwise is assumed
            %   'if style is not given, one black line is assumed
            % param x: center x-coordinate
            % param y: center y-coordinate
            % param radius: radius
            % param alpha: startangle (default 0)
            % param beta: endangle (default 0)
            % param direction: 1 => alpha -> beta clockwise, -1 => alpha -> beta
            % counterclockwise
            % param style: LineSpec for the plot (default: black line)

            nargs = length(varargin);
            if nargs >= 2
                alpha = varargin{1};
                beta = varargin{2};

                alpha = mod(alpha, 2 * pi);
                beta = mod(beta, 2 * pi);
            else
                alpha = 0;
                beta = 0;
            end
            if nargs == 3
                direction = varargin{3};
            else
                direction = 1;
            end
            if nargs == 4
                style = varargin{4};
            else
                style = 'k';
            end

            subdivides_for_radius_one = 8 * 4; % 8 Abschnitte pro Viertel-Kreis
            subdivides = ceil(subdivides_for_radius_one * radius);
            if direction > 0
                if beta <= alpha
                    beta = beta + 2 * pi;
                end
            else
                if alpha <= beta
                    alpha = alpha + 2 * pi;
                end
            end

            step = (beta - alpha) / subdivides;
            angles = alpha:step:beta;
            X = cos(angles) * radius + x;
            Y = sin(angles) * radius + y;

            handle = plot(X, Y, style);
        end
        
        function [ x, y, r ] = getCircle( mx, my, mr, sx, sy, su, sv, lambda_start )

            % getcircle: enhances the location of the circle on the line defined by
            % (sx, sy)^T + lambda * (su, sv)^T so that the circle around (sx, sy)^T
            % + lambda_result * (su, sv)^T touches the point (sx, su)^T and has
            % distance mr from point (mx, my)^T

            % get the first point with the given lambda
            % depending on the error increase or decrease lambda
            tolerance = 0.00001;

            l = lambda_start;
            mod = 1;
            miss = inf;
            while true

                x = sx + l * su;
                y = sy + l * sv;

                d1 = distance(mx, my, sx, sy, su, sv, l) - mr;
                r = norm([su; sv] * l);

                if norm([x - mx; y - my]) < mr
                    return;
                end

                lastmiss = miss;
                miss = abs(d1 - r);

                if miss < tolerance
                    break;
                end

                if lastmiss < miss
                    mod = -1 * mod;
                end

                off = abs(r - d1) * 0.1;

                l = l + mod * off;
            end
        end

        function dist = distance(mx, my, sx, sy, su, sv, lambda)
            s = [sx; sy];
            u = [su; sv];
            m = [mx; my];
            dist = norm(m - (s + u * lambda));
        end
        
        function [coll, dist] = fRectDist(A, B)
            % For efficiency precalculate the B directions beforehand
            DIRSB = zeros(2, 4);
            DIRSB(:, 1) = B(:, 1) - B(:, 2);
            DIRSB(:, 2) = B(:, 2) - B(:, 3);
            DIRSB(:, 3) = -DIRSB(:, 1);
            DIRSB(:, 4) = -DIRSB(:, 2);

            for i = 1:4
                i1 = i + 1;
                DIRA = A(:, i1) - A(:, i);
                for j = 1:4
                    M = [DIRA, DIRSB(:, j)];
                    if det(M) < 10^-5 % parallel lines
                        dotp = dot(B(:, j) - A(:, i), DIRA);
                        if ...
                                (B(2, j) - A(2, i)) *...
                                (A(1, i1) - A(1, i)) -...
                                (B(1, j) - A(1, i)) *...
                                (A(2, i1) - A(2, i)) == 0 && ...
                                ... This was the 3rd component of the cross product between the extended (B - A) and (A+1, A) vectors.
                                ... If this component is zero, A, B and A+1 are linear dependent (are on the same line)
                                dotp > 0 &&... If this dot product is larger than zero, B and A+1 are on the same side of A
                                dotp <= dot(DIRA, DIRA) % If this condition is fulfilled, then B is not farther away from A than A+1
                            % This is because dotp is B-A * A+1 - A. IFF |B-A| is
                            % less or equal to |A+1-A| (which is what tells us,
                            % there is a collision) then we can conclude:
                            % |B-A| = dot(B-A, B-A) <= dot(B-A, A+1-A) <=
                            % dot(A+1-A, A+1-A) = |A+1-A|
                            % Thus B is on the line segment between A and A+1 =>
                            % collision
                            coll = 1;
                            dist = 0;
                            return;
                        end
                    else
                        v = M \ (B(:, j) - A(:, i));

                        if 0 <= v(1) && v(1) <= 1 && 0 <= v(2) && v(2) <= 1
                            coll = 1;
                            dist = 0;
                            return;
                        end
                    end
                end
            end

            coll = false;
            distances = zeros(16, 1);
            for i = 1:4
                for j = 1:4
                    distances((i - 1) * 4 + j) = sum((A(:,i) - B(:, j)) .^ 2);
                end
            end

            dist = sqrt(min(distances));
        end
        
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
        
        function [ m ] = CreateTranslation( x, y )
            m = [1, 0, x; 0, 1, y; 0, 0, 1];
        end
        
        function [ m ] = CreateRotation( angle )
            m = [ cos(angle), -sin(angle), 0;
                sin(angle), cos(angle), 0;
                0, 0, 1];
        end
        
        function rect = CreateRectangle(x, y, w, h)
            rect = [ x, x+w, x+w, x, x; y, y, y+h, y+h, y; 1, 1, 1, 1, 1];
        end
    end
    
end

