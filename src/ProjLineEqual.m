function [ isEqual ] = ProjLineEqual( l1, l2 )
    isEqual = isequal(l1, l2) || isequal(l1, -l2);
end

