classdef World < handle
    %WORLD Contains all elements in the current scenario
    %   'Issues with inheritance prohibits usage of only one element array
    %   so far. Needs to be investigated
    
    properties
        CElements
        RElements
        Car
        Street
    end
    
    methods
        function AddElement(self, element)
            if isa(element, 'RectangularElement')
               self.RElements(length(self.RElements) + 1) = element; 
            else
                self.CElements(length(self.CElements) + 1) = element;
            end
                
        end
        function obj = World(carx, cary, carangle)
            obj.RElements = RectangularElement.empty;
            obj.CElements = CircularElement.empty;
            obj.Car = Car(carx, cary, carangle);
        end
        
        function Display(self)
            figure(1);
            hold on;
            
            self.Street.Draw();
            
            for i = 1:length(self.RElements)
                self.RElements(i).Draw();
            end
            for i = 1:length(self.CElements)
                self.CElements(i).Draw();
            end
            
            self.Car.Draw();
            
            % axis equal
            axis([-4 4 -3 5]);
        end
        
        function PlaceElement(self, element, streetProgress, side, distance)
            % PLACEELEMENT  Adds an element next to the street
            %   element: The element to be added
            %   streetProgress: The place where to add the element (0 at
            %   the beginning of the street, 1 at the end. must be between
            %   0 and 1)
            %   side: The side of the street to add the element to (0 left,
            %   1 right)
            %   distance: The distance from the street
            [location, direction] = self.Street.GetLocation(streetProgress, side, distance);
            element.SetLocation(location(1), location(2));
            
            angle = atan(direction(2) / direction(1));
            element.SetOrientationAngle(angle);
        end
    end
    
end

