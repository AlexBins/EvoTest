classdef Car < RectangularElement
    %CAR The car of the current scenario
    %   Detailed explanation goes here
    
    properties
        Velocity
    end
    
    methods
        function obj = Car(x, y, angle)
            obj = obj@RectangularElement(x, y, 1.125, 0.75, angle);
            obj.Velocity = [ 0; 0; 0 ];
        end
        
        function Draw(self)
            self.Draw@RectangularElement();
        end
    end
    
end

