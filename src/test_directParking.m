plotTrajectory = false;

figure;
hold on;
axis([-4 4 -2 6]);

sc = StaticScenario(-1, 2, pi / 4);
sc.test();

if plotTrajectory
    tr = sc.Trajectory;
    plot(tr.Locations(:, 1), tr.Locations(:, 2), 'r--');
end

sc.DisplayScenario(0);
%sc.Replay(1 / 60, 1);