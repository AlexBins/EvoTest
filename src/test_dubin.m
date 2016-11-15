sc = StaticScenario(-0.1, 0.75, 0);
msa = sc.Car.maxSteeringAngle;
minr = sc.Car.Width / tan(msa);

[tl, to] = ParkingPilot.getTarget(...
    sc.parkingSlot.GetX(), sc.parkingSlot.GetY(),...
    sc.parkingSlot.GetOrientationRadians(), ...
    sc.parkingSlot.Width, sc.parkingSlot.Height,...
    sc.Car.GetX(), sc.Car.GetY(),...
    sc.Car.Width, sc.Car.Height);
[ip, gs, dl, do] = ParkingPilot.tryDirectParking(...
    sc.Car.GetX(), sc.Car.GetY(),...
    sc.Car.GetOrientationRadians(), ...
    tl(1), tl(2), to, 1, minr);
ctrl_mat = getDubinsPath([sc.Car.GetX() sc.Car.GetY() sc.Car.GetOrientationRadians()], [dl(1) dl(2) do], minr);
ctrl_mat = transpose(ctrl_mat);
for i = 1:3
    if ctrl_mat(i, 2) > 0
        ctrl_mat(i, 2) = -sc.Car.maxSteeringAngle;
    elseif ctrl_mat(i, 2) < 0
        ctrl_mat(i, 2) = sc.Car.maxSteeringAngle;
    end
end

sc.ExecuteControlMatrix(ctrl_mat);
sc.ExecuteControlMatrix(gs.getControlMatrix(1, sc.Car.Width));
sc.Replay(1 / 60, 1);

sc.MinDistance
sc.Collision