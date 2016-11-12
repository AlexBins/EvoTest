classdef PlanObject < matlab.mixin.Heterogeneous
    %PLANOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Abstract)
        ctrl_signal = CalculateControlSignal(self, velocity, axisDistance)
    end
    
end

