classdef GeometricSequence < handle
    %GEOMETRICSEQUENCE Contains a sequence of PlanObjects
    %       supports generating a control matrix out of the PlanObject
    %       sequence
    
    properties (Access = private)
        Sequence
    end
    
    methods
        function obj = GeometricSequence()
            % GeometricSequence: Creates a new and empty instance
            obj.Sequence = PlanObject.empty;
        end
        
        function add(self, element)
            % add: Adds a new elemnt to the sequence
            % element: instance of a PlanObject subclass
            
            % Get the next index in the underlying array
            index = length(self.Sequence) + 1;
            % Check if element is an accepted class' instance
            if isa(element, 'PlanObject')
                self.Sequence(index) = element;
            else
                % this should not happen
            end
        end
        
        function element = getAt(self, index)
            % getAt: returns the index-th element in this sequence
            % index: the index in the underlying array
            element = self.Sequence(index);
        end
        
        function ctrlMatrix = getControlMatrix(self, velocity, axisDistance)
            % getControlMatrix: creates one control matric out of all the
            % geometric elements
            % velocity: the velocity with which the sequence should be
            % executed
            % axisDistance: the distance of the car's front and back axis
            
            % initialize the control matrix with zeros to increase
            % performance
            ctrlMatrix = zeros(length(self.Sequence), 3);
            
            % fill the matrix
            for i = 1:length(self.Sequence)
                ctrlMatrix(i,:) = self.getAt(i).CalculateControlSignal(velocity, axisDistance);
            end
        end
        
        function l = length(self)
            % length: returns the amount of stored geometric elements
            l = length(self.Sequence);
        end
    end
    
    methods (Static)
        function result = merge(gs1, gs2)
            % merge: merges 2 sequences
            
            % initialize a new empty sequence
            result = GeometricSequence();
            % add all elements of the first sequence
            for i = 1:gs1.length()
                result.add(gs1.getAt(i));
            end
            % add all elements of the second sequence
            for i = 1:gs2.length()
                result.add(gs2.getAt(i));
            end
        end
    end
end

