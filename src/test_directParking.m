plotTrajectory = true;

figure;
hold on;
axis([-10 10 -10 10]);

sc = StaticScenario(-2, 5, pi / -100);
sc.test();

if plotTrajectory
    tr = sc.Trajectory;
    plot(tr.Locations(:, 1), tr.Locations(:, 2), 'r--');
end

sc.Replay(1 / 60, 1);