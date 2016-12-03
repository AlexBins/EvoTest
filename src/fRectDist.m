function [coll, dist] = fRectDist(A, B)
    % For efficiency precalculate the B directions beforehand
    DIRSB = zeros(2, 4);
    DIRSB(:, 1) = B(:, 1) - B(:, 2);
    DIRSB(:, 2) = B(:, 2) - B(:, 3);
    DIRSB(:, 3) = -DIRSB(:, 1);
    DIRSB(:, 4) = -DIRSB(:, 2);
    
    for i = 1:4
        i1 = i + 1;
        DIRA = A(:, i1) - A(:, i);
        for j = 1:4
            M = [DIRA, DIRSB(:, j)];
            if det(M) < 10^-5 % parallel lines
                dotp = dot(B(:, j) - A(:, i), DIRA);
                if ...
                        (B(2, j) - A(2, i)) *...
                        (A(1, i1) - A(1, i)) -...
                        (B(1, j) - A(1, i)) *...
                        (A(2, i1) - A(2, i)) == 0 && ...
                        ... This was the 3rd component of the cross product between the extended (B - A) and (A+1, A) vectors.
                        ... If this component is zero, A, B and A+1 are linear dependent (are on the same line)
                        dotp > 0 &&... If this dot product is larger than zero, B and A+1 are on the same side of A
                        dotp <= dot(DIRA, DIRA) % If this condition is fulfilled, then B is not farther away from A than A+1
                    % This is because dotp is B-A * A+1 - A. IFF |B-A| is
                    % less or equal to |A+1-A| (which is what tells us,
                    % there is a collision) then we can conclude:
                    % |B-A| = dot(B-A, B-A) <= dot(B-A, A+1-A) <=
                    % dot(A+1-A, A+1-A) = |A+1-A|
                    % Thus B is on the line segment between A and A+1 =>
                    % collision
                    coll = 1;
                    dist = 0;
                    return;
                end
            else
                v = M \ (B(:, j) - A(:, i));

                if 0 <= v(1) && v(1) <= 1 && 0 <= v(2) && v(2) <= 1
                    coll = 1;
                    dist = 0;
                    return;
                end
            end
        end
    end
    
    coll = false;
    distances = zeros(16, 1);
    for i = 1:4
        for j = 1:4
            distances((i - 1) * 4 + j) = sum((A(:,i) - B(:, j)) .^ 2);
        end
    end
    
    dist = sqrt(min(distances));
end