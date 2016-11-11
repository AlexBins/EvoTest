sc = Scenario.CreateWithSlot(0.5, 1.5, 1, 1, (1.5 + 1.25) / 2);
sc.DriveCircle(-5,30*pi/180, 5, 0.1);
sc.Replay(0.05, 1);