function [ yy ] = interpolate( x, y, xx )
    curmin = 1;
    yy = zeros(length(xx), 1);
    for i = 1:length(xx)
        current = xx(i);
        
        if current > x(curmin + 1)
            curmin = curmin + 1;
        end
        
        min = y(curmin);
        max = y(curmin + 1);
        yy(i) = min + (max - min) * (current - x(curmin));
    end
end

