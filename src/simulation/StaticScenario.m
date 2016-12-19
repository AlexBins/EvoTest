classdef StaticScenario < Scenario
    %STATICSCENARIO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parkingSlot
    end

    methods
        function obj = StaticScenario(carX, carY, carAngle, varargin)
            obj = obj@Scenario(0.5, 1, [], []);
            
            carWidth = 1.125;
            carHeight = 0.75;
            if isempty(varargin)
                slotWidth = 2 * carWidth;
                slotDepth = 1;
            else
               slotWidth = varargin{1};
               slotDepth = varargin{2};
            end
            
            street = Street([-3 0; 3 0], [0 0], [0 0]);
            [slotLoc, slotDir] = street.GetLocation(0.5, 1, slotDepth / 2);
            slotDir = slotDir / sqrt(slotDir(1) ^ 2 + slotDir(2) ^ 2);
            
            
            obj.Car.SetLocation(carX, carY);
            obj.Car.SetOrientationAngle(carAngle);
            obj.CarStartInformation = [obj.Car.GetX(), obj.Car.GetY(), obj.Car.GetOrientationRadians()];
            
            obs1 = RectangularElement(slotLoc(1) - slotDir(1) * (slotWidth + carWidth) / 2, slotLoc(2) - slotDir(2) * (slotWidth + carWidth) / 2, carWidth, slotDepth, 0);
            obj.World.AddElement(obs1);
            
            obs2 = RectangularElement(slotLoc(1) + slotDir(1) * (slotWidth + carWidth) / 2, slotLoc(2) + slotDir(2) * (slotWidth + carWidth) / 2, carWidth, slotDepth, 0);
            obj.World.AddElement(obs2);
            
            obs3 = RectangularElement(0, 0, 6, 1, 0);
            obj.World.AddElement(obs3);
            obj.World.PlaceElement(obs3, 0.5, 1, slotDepth + 0.5);
            
            obj.parkingSlot = RectangularElement(slotLoc(1), slotLoc(2), slotWidth, slotDepth, 0);
        end
        
        function [minDist, collision] = RunParkingPilot(self)
            [minDist, collision] = self.RunParkingPilot@Scenario(...
                [self.parkingSlot.GetX(); self.parkingSlot.GetY()],...
                self.parkingSlot.GetOrientationRadians(),...
                self.parkingSlot.Width, self.parkingSlot.Height);
        end
        
        function DisplayScenario(self, time)
            self.parkingSlot.Draw('y');
            DisplayScenario@Scenario(self, time);
        end
    end
    
end

