sc = StaticScenario(0, 3.5, 0, 2.25, 1.25);
msa = sc.Car.maxSteeringAngle;
minr = sc.Car.Width / tan(msa);

% sc.World.Display();

[tl, to, tls] = ParkingPilot.getTarget(...
    sc.parkingSlot.GetX(), sc.parkingSlot.GetY(),...
    sc.parkingSlot.GetOrientationRadians(), ...
    sc.parkingSlot.Width, sc.parkingSlot.Height,...
    sc.Car.GetX(), sc.Car.GetY(),...
    sc.Car.Width, sc.Car.Height);

% plot(tl(1), tl(2), 'rx');
% quiver(tl(1), tl(2), cos(to), sin(to), 'Color', 'r');

[ip, gs, dl, do] = ParkingPilot.tryDirectParking(...
    sc.Car.GetX(), sc.Car.GetY(),...
    sc.Car.GetOrientationRadians(), ...
    tl(1), tl(2), to, 1, minr, tls);

% if ~ip
%     plot(dl(1), dl(2), 'rx');
%     quiver(dl(1), dl(2), cos(do), sin(do), 'Color', 'r');
%     
%     drawGS(gs);
% end

if ~ip
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
end

sc.ExecuteControlMatrix(gs.getControlMatrix(1, sc.Car.Width));
sc.Replay(1 / 60, 2);

coll = sc.Collision;
dist = sc.MinDistance;
if coll
    'Kollision'
    'Distance: '
    dist
else
    'Kollisionsfrei'
    'Distance: '
    dist
end