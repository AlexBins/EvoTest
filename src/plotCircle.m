% TODO Replace with the implementation in GeometricUtility.plotCircle
% DONE
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

