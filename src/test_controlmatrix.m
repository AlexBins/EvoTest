sc = Scenario.CreateWithSlot(0.5, 2, 1, 1, 0);
pc = PlanCircle(2, pi * 1.5, 2 * pi, -1);
pl = PlanStraight(0, 0, 1, 0);
ctrl2 = pl.CalculateControlSignal(2, 1.125);
ctrl1 = pc.CalculateControlSignal(2, 1.125);
mat = [ctrl1; ctrl1; ctrl2; ctrl1; ctrl2; ctrl1;];

sc.DisplayScenario(0);
sc.ExecuteControlMatrix(mat);
sc.Replay(1 / 60, 1);