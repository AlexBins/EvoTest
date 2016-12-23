% TODO Replace with implementation in GeometricUtility.CreateTranslation
function [ m ] = CreateTranslation( x, y )
    m = [1, 0, x; 0, 1, y; 0, 0, 1];
end