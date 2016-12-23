% TODO Replace with GeometricUtility.turn2DVec
function [ v ] = turn2DVec( vec, rad )
    mat = [cos(rad) -sin(rad); sin(rad) cos(rad)];
    v = mat * vec;
end

