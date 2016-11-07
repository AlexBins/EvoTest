classdef Trajectory < handle
    %TRAJECTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Locations
        Angles
        Timestamps
    end
    
    methods
        function obj = Trajectory(startx, starty, startangle)
            obj.Locations = [startx starty;];
            obj.Angles = [startangle];
            obj.Timestamps = [0];
        end
        
        function Add(self, x, y, angle, deltaTime)
            index = length(self.Timestamps) + 1;
            self.Locations(index, :) = [x y];
            self.Angles(index) = angle;
            self.Timestamps(index) = self.Timestamps(index - 1) + deltaTime;
        end
        
        function LogCar(self, car, deltaTime)
            self.Add(car.GetX(), car.GetY(),  car.GetOrientationRadians(), deltaTime);
        end
        
        function duration = GetDuration(self)
            duration = self.Timestamps(length(self.Timestamps));
        end
        
        function [x, y, angle] = GetAtTime(self, time)
            if length(self.Timestamps) == 1
                x = self.Locations(1, 1);
                y = self.Locations(1, 2);
                angle = self.Angles(1);
            else
                i = 1;
                while length(self.Timestamps) > i && self.Timestamps(i + 1) < time
                    i = i + 1;
                end
                t0 = self.Timestamps(i);
                t1 = self.Timestamps(i + 1);
                x0 = self.Locations(i,1);
                x1 = self.Locations(i + 1, 1);
                y0 = self.Locations(i, 2);
                y1 = self.Locations(i + 1, 2);
                a0 = self.Angles(i);
                a1 = self.Angles(i + 1);
                
                perc = (time - t0) / (t1 - t0);
                x = x0 + perc * (x1 - x0);
                y = y0 + perc * (y1 - y0);
                angle = a0 + perc * (a1 - a0);
            end
        end
    end
    
end

