function tinv = getInvTraject(t)
% reverse the order of columns in the matrix to get the reverse of a given
% trajectory
tinv = [t(:,3), t(:,2), t(:, 1)];
end