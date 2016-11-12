figure;
hold on;
dim = 6;
axis([-dim / 2 dim / 2 -dim / 2 dim / 2]);
plot([-1.5 1.5 1.5 -1.5 -1.5], [1 1 0 0 1], 'k');

plot([-1 -1], [1 0], 'k-.');
plot([1 1], [1 0], 'k-.');

plot([-2 0], [0 1], 'r:');
plot([2 0], [0 1], 'r:');

c = [0 -1.5];
r = norm(c - [1 0.5]);

viscircles(c, [r], 'Color', 'b', 'LineStyle', '--');

plot([-1 0], [0.5 -1.5], 'b:');
plot([1 0], [0.5 -1.5], 'b:');

r = norm(c - [-1.5 1]);
viscircles(c, [r], 'Color', 'r', 'LineStyle', '--');

r = norm(c - [0 0]);
viscircles(c, [r], 'Color', 'r', 'LineStyle', '--');

plot([-1.1 -0.9], [0.45, 0.55], 'r', 'LineWidth', 2);
plot([1.1 0.9], [0.45, 0.55], 'r', 'LineWidth', 2);