% TODO Remove (unused)
function [ distance, vertex, linePoint] = calculateDistance( element1, element2 )
    x = element1.GetX();
    y = element1.GetY();
    r1 = CreateRectangle(x - element1.Width / 2, y - element1.Height / 2, element1.Width, element1.Height);
    
    tlin = CreateTranslation(-x, -y);
    tlout = CreateTranslation(x, y);
    rot = CreateRotation(element1.GetOrientationRadians());
    r1 = tlout * rot * tlin * r1;
    
    x = element2.GetX();
    y = element2.GetY();
    r2 = CreateRectangle(x - element2.Width / 2, y - element2.Height / 2, element2.Width, element2.Height);
    
    tlin = CreateTranslation(-x, -y);
    tlout = CreateTranslation(x, y);
    rot = CreateRotation(element2.GetOrientationRadians());
    r2 = tlout * rot * tlin * r2;
    
    distance = 10000;
    for i = 1:4
        a1 = r1(:, i);
        a2 = r2(:, i);
        for j = 1:4
            b = [r2(:, j) r2(:, j+ 1)];
            [dist, p1] = distancePointLine(a1, b);
            if(dist < distance)
                distance = dist;
                point1 = p1;
                point2 = r1(:, i);
            end
            b = [r1(:, j) r1(:, j+1)];
            [dist, p1] = distancePointLine(a2, b);
            if(dist < distance)
                distance = dist;
                point1 = p1;
                point2 = r2(:, i);
            end
        end
    end
    
    vertex = [point1(1); point1(2); 1];
    linePoint = point2;
    
    figure;
    hold on;
    plot(r1(1, :), r1(2, :), 'k');
    plot(r2(1, :), r2(2, :), 'k');
    plot([vertex(1, 1) linePoint(1, 1)], [vertex(2, 1) linePoint(2, 1)], 'r');
    axis([-5 5 -5 5]);
end

