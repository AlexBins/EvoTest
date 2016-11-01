sc = Scenario.CreateWithSlot(0.5, 1.5, 1, 1, (1.5 + 1.25) / 2);
sc.Trajectory.Add(-0.2, 0, pi/16, 1);
sc.Trajectory.Add(-0.45, -0.05, pi / 8, 1);
sc.Trajectory.Add(-0.65, -0.1, 3 * pi / 16, 1);
sc.Trajectory.Add(-0.85, -0.25, pi / 4, 1);
sc.Trajectory.Add(-1.3, -0.7, pi / 4, 4);
sc.Trajectory.Add(-1.35, -0.8, 3 * pi / 16, 1);
sc.Trajectory.Add(-1.4, -0.9, pi / 8, 1);
sc.Trajectory.Add(-1.45, -0.95, pi / 16, 1);
sc.Trajectory.Add(-1.5, -1, 0, 1);
sc.Trajectory.Add(-1.375, -1, 0, 1);

sc.Replay(0.03, 2);