close all;
figure;
hold on;
axis([-4 4 -2 6]);

sc = StaticScenario(-4, 2, 3 * pi / 2);
sc.RunParkingPilot();

sc.Replay(1 / 60, 3);