classdef NeighbourhoodDescription < handle
    
    properties
        % adjacency matrix
        neighbour_matrix
    end
    
    methods
        function instance = NeighbourhoodDescription(n_elements)
            % Creates a neighbourhood description instance
            instance.neighbour_matrix = zeros(n_elements);
        end
        
        function addNeighbourhoodRelations(self, idx_self, list_idx_targets)
            % adds a neighbourhood relation between idx_self and all in
            % list_idx_targets
            
            % adj. matrix is symmetric. add it on (i,j) and (j,i)
            self.neighbour_matrix(idx_self, list_idx_targets) = 1;
            self.neighbour_matrix(list_idx_targets, idx_self) = 1;
        end
        
        function idx_neighbours = getNeighbours(self, idx_self)
            % gets all neighbours for a given idx_self
            
            % Get the vector of neighbour relations
            tmp = self.neighbour_matrix(idx_self, :);
            % Find all non-zero elements and return their indexes
            idx_neighbours = find(tmp);
        end
        
        function result = isNeighbour(self, idx_self, idx_target)
            % checks if two elements are neighbours
            
            % convention: self <-> self is never a neighbour
            if idx_self == idx_target
                result = 0;
            else
                result = self.neighbour_matrix(idx_self, idx_target) == 1;
            end
        end
        
        function addNeighbourClass(self, list_idx_neighbours)
            % Makes all elements in list_idx_neighbours neighbours
            for i_self = 1:length(list_idx_neighbours)
                idx_self = list_idx_neighbours(i_self);
                self.addNeighbourhoodRelations(idx_self, list_idx_neighbours(i_self + 1 : end));
            end
        end
    end
    
end

