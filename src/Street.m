classdef Street < handle
    %STREET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Points
        DirectionIn
        DirectionOut
        
        private_data
        private_normals
        
        Length
    end
    
    methods
        
        function [location, direction] = GetLocation(self, streetProgress, side, distance)
            start = [ 0 0 ];
            dir = [ 0 0 ];
            perc = streetProgress;
            normal = [ 0 0 0 ];
            for i = 2:length(self.Points)
                start = self.Points(:,i-1);
                dir = self.Points(:,i) - self.Points(:,i-1);
                len = sqrt(dot(dir, dir));
                p = len / self.Length;
                if p >= perc
                    normal = self.private_normals(:,i-1);
                    break
                else
                    perc = perc - p;
                end
            end
            loc = start + dir / norm(dir) * perc * self.Length;
            mod = 1;
            if side ~= 1
                mod = -1;
            end
            
            direction = dir;
            
            offset = normal * (distance + 1);
            location = [loc; 1] + mod * offset;
        end
        
        function obj = Street(xyTuple, dirIn, dirOut)
            for i = 1:length(xyTuple)
                obj.Points(:,i) = xyTuple(i,:);
            end
            obj.DirectionIn = dirIn;
            obj.DirectionOut = dirOut;
            
            obj.private_data = zeros(3,length(obj.Points),3);
            
            Calc(obj);
        end
        
        function Calc(self)
            self.Length = 0;
            for i = 2:length(self.Points)
                vec = self.Points(:,i) - self.Points(:,i-1);
                self.Length = self.Length + sqrt(dot(vec, vec));
            end
            
            self.private_data(1,:,2) = self.Points(1,:);
            self.private_data(2,:,2) = self.Points(2,:);
            
            len = length(self.Points);
            p = zeros(3, len);
            normals = zeros(3, len - 1);
            p(:,1) = [self.Points(1, 1) self.Points(2, 1) 1];
            for i = 2:length(self.Points)
                p(:, i) = [self.Points(1,i) self.Points(2,i) 1];
                normals(:, i-1) = cross(p(:, i) - p(:, i-1), [0 0 1]);
                normals(:,i-1) = normals(:,i-1) / norm(normals(:,i-1));
            end
            
            self.private_normals = normals;
            
            lines = zeros(3,len - 1, 2);
            for i = 1:len-1
                lines(:,i,1) = cross(p(:,i) + normals(:,i), p(:,i+1) + normals(:,i));
                lines(:,i,2) = cross(p(:,i) - normals(:,i), p(:,i+1) - normals(:,i));
            end
            
            edges = zeros(3,len,2);
            edges(:,1,1) = p(:,1) + normals(:,1);
            edges(:,1,2) = p(:,1) - normals(:,1);
            edges(:,len,1) = p(:,len) + normals(:,len - 1);
            edges(:,len,2) = p(:,len) - normals(:,len - 1);
            for i = 2:len - 1
                edges(:,i,1) = cross(lines(:,i-1,1), lines(:,i,1));
                edges(:,i,1) = edges(:,i,1) / edges(3,i,1);
                edges(:,i,2) = cross(lines(:,i-1,2), lines(:,i,2));
                edges(:,i,2) = edges(:,i,2) / edges(3,i,2);
            end
            
            self.private_data(:,:,1) = edges(:,:,1);
            self.private_data(:,:,3) = edges(:,:,2);
        end
        
        % Currently only horizontal is supported
        function Draw(self)
            
            plot(self.private_data(1,:,1), self.private_data(2,:,1), 'k');
            plot(self.private_data(1,:,2), self.private_data(2,:,2), 'k-.');
            plot(self.private_data(1,:,3), self.private_data(2,:,3), 'k');
        end
    end
    
end

