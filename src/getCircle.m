function [ x, y, r ] = getCircle( mx, my, mr, sx, sy, su, sv, lambda_start )
    % getcircle: enhances the location of the circle on the line defined by
    % (sx, sy)^T + lambda * (su, sv)^T so that the circle around (sx, sy)^T
    % + lambda_result * (su, sv)^T touches the point (sx, su)^T and has
    % distance mr from point (mx, my)^T
    
    % get the first point with the given lambda
    % depending on the error increase or decrease lambda
    tolerance = 0.00001;
    l = lambda_start;
    while true
        d1 = distance(mx, my, sx, sy, su, sv, l) - mr;
        d2 = norm([su; sv] * l);
        if abs(d1 - d2) < tolerance
            break;
        end
        
        if d1 < d2
            mod = -1;
        else
            mod = 1;
        end
        
        off = abs(d2 - d1) * 0.1;
        
        l = l + mod * off;
    end
    
    x = sx + l * su;
    y = sy + l * sv;
    r = d2;
end

function dist = distance(mx, my, sx, sy, su, sv, lambda)
    s = [sx; sy];
    u = [su; sv];
    m = [mx; my];
    dist = norm(m - (s + u * lambda));
end