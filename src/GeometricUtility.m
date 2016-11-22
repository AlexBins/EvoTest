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
    end
    
end

