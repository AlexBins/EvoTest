classdef Scenario < handle
    %SCENARIO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        World
        Car
        Trajectory
        CarStartInformation
        Collision
        MinDistance
    end
    
    methods
        function obj = Scenario(carprogress, carSide, rectangledescriptions, circlelocations)
            obj.Trajectory = Trajectory();
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
            obj.Collision = false;
            obj.MinDistance = NaN;
        end
        
        function ExecuteControlMatrix(self, control_matrix)
            % Execute the control matrix
            % Execute one by one the control vectors using an interval for
            % the trajectory generation, that doesn't lead to
            % discretization errors by fullfilling the equation n * dt =
            % vector.duration with n in Natural Numbers and the inequation
            % dt < 0.1 / vector.velocity and dt being maximal
            
            % iterate over the control matrix
            for idx=1:size(control_matrix, 1)
                % receive the currenct control vector
                ctr_vector = control_matrix(idx, :);
                % Extract the single values out of the vector
                velocity = ctr_vector(1);
                steering_angle = ctr_vector(2);
                duration = ctr_vector(3);
                % Calculate the maximum possible dt
                max_dt = 0.1 / abs(velocity);
                % Get the amount the maximum possible dt would be needed to
                % run the current control vector
                n = duration / max_dt;
                % Since an amount should be a natural number and dt must be
                % smaller or equal to the maximum dt, round up to the next
                % natural number
                n = ceil(n);
                % Calculate the actual dt
                dt = duration / n;
                % Now move the car the calculated amount of times
                for i = 1:n
                    % move the car according to the provided information
                    self.Car.Move(velocity, steering_angle, dt);
                    
                    car_rect = self.Car.GetRectangle();
                    for iElement = 1:length(self.World.RElements)
                        i_rect = self.World.RElements(iElement).GetRectangle();
                        
                        [doCollide, distance] = fRectDist(car_rect, i_rect);
                        
                        if doCollide == 1
                            self.Collision = true;
                        end
                        if isnan(self.MinDistance)
                            self.MinDistance = distance;
                        elseif (~isnan(distance))
                            if (distance < self.MinDistance)
                                self.MinDistance = distance;
                            end
                        end
                    end
                    % Log the new positions
                    self.Trajectory.LogCar(self.Car, dt);
                end
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
                %x = self.CarStartInformation(1) + x;
                %y = self.CarStartInformation(2) + y;
                %a = self.CarStartInformation(3) + a;
                self.Car.SetLocation(x, y);
                self.Car.SetOrientationAngle(a);
                self.Car.Redraw();
            end
        end
        
        function Replay(self, deltaT, speedupfactor)
            for t = 0:deltaT:self.Trajectory.GetDuration()
                self.DisplayScenario(t);
                pause(deltaT / speedupfactor);
            end
        end
        
        function [minDist, collision] = RunParkingPilot(self,...
                pLoc, pOr, pLength, pWidth)
            self.Trajectory = Trajectory();
            minr = self.Car.Width / tan(self.Car.maxSteeringAngle);
            
            [tl, to] = ParkingPilot.getTarget(...
                pLoc(1), pLoc(2), pOr, pLength, pWidth,...
                self.Car.GetX(), self.Car.GetY(),...
                self.Car.Width, self.Car.Height);
            
            [directParkingPossible, directParkingSequence,...
                dubinsLocation, dubinsOrientation] = ...
                ParkingPilot.tryDirectParking(...
                self.Car.GetX(), self.Car.GetY(),...
                self.Car.GetOrientationRadians(), ...
                tl(1), tl(2), to, 1, minr);
            
            if ~directParkingPossible
                ctrl_mat = getDubinsPath(...
                    [self.Car.GetX() self.Car.GetY() self.Car.GetOrientationRadians()],...
                    [dubinsLocation(1) dubinsLocation(2) dubinsOrientation], minr);
                ctrl_mat = transpose(ctrl_mat);

                for i = 1:3
                    if ctrl_mat(i, 2) > 0
                        ctrl_mat(i, 2) = -self.Car.maxSteeringAngle;
                    elseif ctrl_mat(i, 2) < 0
                        ctrl_mat(i, 2) = self.Car.maxSteeringAngle;
                    end
                end

                self.ExecuteControlMatrix(ctrl_mat);
            end
            
            self.ExecuteControlMatrix(directParkingSequence.getControlMatrix(...
                1, self.Car.Width));
            
            minDist = self.MinDistance;
            collision = self.Collision;
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

