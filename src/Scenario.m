classdef Scenario
    %SCENARIO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        World
        Car
        Trajectory
        CarStartInformation
    end
    
    methods
        function obj = Scenario(carprogress, carSide, rectangledescriptions, circlelocations)
            obj.Trajectory = Trajectory(0, 0, 0);
            obj.World = World(0, 0, 0);
            obj.World.Street = Street([-3 0; 3 0], [0 0], [0 0]);
            obj.Car = obj.World.Car;
            obj.World.PlaceElement(obj.Car, carprogress, carSide, -0.5);
            for i = 1:length(rectangledescriptions)
                rc = RectangularElement(0, 0, 1.125, 0.75, 0);
                obj.World.AddElement(rc);
                obj.World.PlaceElement(rc, rectangledescriptions(i, 1), rectangledescriptions(i, 2), 0.5);
            end
            for i = 1:length(circlelocations)
                cc = CircularElement(circlelocations(i, 1), circlelocations(i, 2), 0.25);
                obj.World.AddElement(cc);
            end
            
            obj.CarStartInformation = [obj.Car.GetX(), obj.Car.GetY(), obj.Car.GetOrientationRadians()];
        end
        
        function ExecuteControlMatrix(self, control_matrix, dt)
            % Execute each column in the control matrix for dt seconds
            % control_matrix(1) contains 2 entries: velocity and
            % steering_angle
            for idx=1:length(control_matrix);
                ctr_vector = control_matrix(:,idx);
                self.Car.Move(ctr_vector(1), ctr_vector(2), dt);
                self.Trajectory.LogCar(self.Car, dt);
            end
        end
        
        function DriveCircle(self, velocity, steering_angle, duration, dt)
            ctrl = zeros(2, duration/dt);
            for idx = 1:duration/dt
                ctrl(:,idx) = [velocity; steering_angle];
            end
            self.ExecuteControlMatrix(ctrl, dt);
        end
        
        function DisplayScenario(self, time)
            if (time <= 0)
                self.Car.SetLocation(self.CarStartInformation(1), self.CarStartInformation(2));
                self.Car.SetOrientationAngle(self.CarStartInformation(3));
                self.World.Display();
            elseif(time > self.Trajectory.GetDuration())
                time = self.Trajectory.GetDuration();
                self.DisplayScenario(time);
            else
                [x, y, a] = self.Trajectory.GetAtTime(time);
                x = self.CarStartInformation(1) + x;
                y = self.CarStartInformation(2) + y;
                a = self.CarStartInformation(3) + a;
                self.Car.SetLocation(x, y);
                self.Car.SetOrientationAngle(a);
                self.Car.Redraw();
            end
        end
        
        function Replay(self, deltaT, speedupfactor)
            accumulatedT = 0;
            for t = 0:deltaT:self.Trajectory.GetDuration()
                self.DisplayScenario(accumulatedT);
                accumulatedT = accumulatedT + deltaT;
                pause(deltaT / speedupfactor);
            end
        end
    end
    
    methods(Static)
        function result = CreateWithSlot(slotProgress, slotWidth, slotDepth, slotSide, carOffset)
            carWidth = 1.125;
            carHeight = 0.75;
            
            street = Street([-3 0; 3 0], [0 0], [0 0]);
            [slotLoc, slotDir] = street.GetLocation(slotProgress, slotSide, slotDepth / 2);
            slotDir = slotDir / sqrt(slotDir(1) ^ 2 + slotDir(2) ^ 2);
            
            result = Scenario(slotProgress, slotSide, [;], [;]);
            cl = [result.Car.GetX(); result.Car.GetY()];
            cl = cl + slotDir * carOffset;
            result.Car.SetLocation(cl(1), cl(2));
            result.CarStartInformation = [result.Car.GetX(), result.Car.GetY(), result.Car.GetOrientationRadians()];
            
            obs1 = RectangularElement(slotLoc(1) - slotDir(1) * (slotWidth + carWidth) / 2, slotLoc(2) - slotDir(2) * (slotWidth + carWidth) / 2, carWidth, carHeight, 0);
            result.World.AddElement(obs1);
            
            obs2 = RectangularElement(slotLoc(1) + slotDir(1) * (slotWidth + carWidth) / 2, slotLoc(2) + slotDir(2) * (slotWidth + carWidth) / 2, carWidth, carHeight, 0);
            result.World.AddElement(obs2);
            
            obs3 = RectangularElement(0, 0, 6, 6, 0);
            result.World.AddElement(obs3);
            result.World.PlaceElement(obs3, 0.5, slotSide, slotDepth + 3);
        end
    end
end

