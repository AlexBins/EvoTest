function [ sgn ] = isLeftOfLine( line_start, line_end, point )
    a = [line_start; 0];
    b = [line_end; 0];
    c = [point; 0];
    
    crss = cross((b - a), (c - a));
    sgn = sign(crss(3));
end

