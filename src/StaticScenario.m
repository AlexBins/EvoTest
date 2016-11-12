classdef StaticScenario < Scenario
    %STATICSCENARIO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parkingSlot
    end
    
    methods
        function obj = StaticScenario(carX, carY, carAngle)
            obj = obj@Scenario(0.5, 1, [], []);
            
            carWidth = 1.125;
            carHeight = 0.75;
            slotWidth = 1.5 * carWidth;
            slotDepth = 1;
            
            street = Street([-3 0; 3 0], [0 0], [0 0]);
            [slotLoc, slotDir] = street.GetLocation(0.5, 1, 1 / 2);
            slotDir = slotDir / sqrt(slotDir(1) ^ 2 + slotDir(2) ^ 2);
            
            
            obj.Car.SetLocation(carX, carY);
            obj.Car.SetOrientationAngle(carAngle);
            obj.CarStartInformation = [obj.Car.GetX(), obj.Car.GetY(), obj.Car.GetOrientationRadians()];
            
            obs1 = RectangularElement(slotLoc(1) - slotDir(1) * (slotWidth + carWidth) / 2, slotLoc(2) - slotDir(2) * (slotWidth + carWidth) / 2, carWidth, carHeight, 0);
            obj.World.AddElement(obs1);
            
            obs2 = RectangularElement(slotLoc(1) + slotDir(1) * (slotWidth + carWidth) / 2, slotLoc(2) + slotDir(2) * (slotWidth + carWidth) / 2, carWidth, carHeight, 0);
            obj.World.AddElement(obs2);
            
            obs3 = RectangularElement(0, 0, 6, 6, 0);
            obj.World.AddElement(obs3);
            obj.World.PlaceElement(obs3, 0.5, 1, slotDepth + 3);
            
            obj.parkingSlot = RectangularElement(slotLoc(1), slotLoc(2), slotWidth, slotDepth, 0);
        end
        
        function DisplayScenario(self, time)
            self.parkingSlot.Draw('y');
            DisplayScenario@Scenario(self, time);
        end
    end
    
end

