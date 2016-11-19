function [ isEqual ] = ProjLineEqual( l1, l2 )
    l1 = l1 / norm(l1);
    l2 = l2 / norm(l2);
    isEqual = isequal(l1, l2) || isequal(l1, -l2);
end

