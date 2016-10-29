sc = Scenario.CreateWithSlot(0.5, 1.5, 1, 1, -1.5);
sc.Trajectory.Add(1, 0, 0, 1);
sc.Trajectory.Add(1, 0, pi * 2, 4);
sc.Trajectory.Add(2, 0, pi * 2.25, 1);
sc.Trajectory.Add(3, 0, pi * 2, 1);
sc.Trajectory.Add(4, 0, pi * 2, 1);

sc.Replay(0.03, 2);