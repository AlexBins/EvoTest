% Deprecated. Doesn't work due to the used car model

figure;
hold on;
dim = 6;
axis([-dim / 2 dim / 2 -dim / 2 dim / 2]);
plot([-dim / 2 dim / 2], [0 0], 'k:');
plot([0 0], [-dim / 2 dim / 2], 'k:');
carWidth = 1;
carLength = 3;
axisDistance = 2;
plot([-carLength / 2 carLength / 2 carLength / 2 -carLength / 2 -carLength / 2], [carWidth / 2 carWidth / 2 -carWidth / 2 -carWidth / 2 carWidth / 2], 'k');

plot([-axisDistance / 2  -axisDistance / 2], [carWidth / 2 -carWidth / 2], 'k-.');
plot([axisDistance / 2 axisDistance / 2], [carWidth / 2 -carWidth / 2], 'k-.');

plot([-axisDistance / 2 - 1 -axisDistance / 2 + 1], [-0.5 0.5], 'r:');
plot([axisDistance / 2 + 1 axisDistance / 2 - 1], [-0.5 0.5], 'r:');

c = [0 -2];
axisCenter = [-axisDistance / 2, 0];
radius = norm(c - axisCenter);

viscircles(c, [radius], 'Color', 'b', 'LineStyle', '--');

plot([-axisDistance / 2, 0], [0, -2], 'b:');
plot([axisDistance / 2, 0], [0, -2], 'b:');

topLeft = [-carLength / 2, carWidth / 2];

radius = norm(c - topLeft);
viscircles(c, [radius], 'Color', 'r', 'LineStyle', '--');

botCenter = [0, -carWidth / 2];

radius = norm(c - botCenter);
viscircles(c, [radius], 'Color', 'r', 'LineStyle', '--');

plot([-axisDistance / 2 - 0.2, -axisDistance / 2 + 0.2], [-0.1 0.1], 'r', 'LineWidth', 2);
plot([axisDistance / 2 + 0.2, axisDistance / 2 - 0.2], [-0.1 0.1], 'r', 'LineWidth', 2);

r = PlanCircle.getOuterRadius(norm(c - axisCenter), carWidth, carLength, axisDistance);
viscircles(c, [r], 'Color', 'r', 'LineStyle', ':');