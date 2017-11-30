%Function which returns the intersection of a segment with a concave polygon
%
%Input:
%   s: struct with the segment: s.A and s.B
%   p: polygon in the form: [x1,y1; x2,y2; x3,y3; x4,y4...] where every
%   side of the polygon is from a point to the next one and the last side
%   is from the last point to the first one.
%
%Return:
%   inters: struct with the segment: s.A and s.B defined by the intersection of s and p
%           +
%   n: number of intersection points:
%           if the segment AB has 2 intersection points  with polygon n = 2
%           if the segment AB has 1 intersection point  with polygon n = 1
%           if the segment AB is all included within polygon n = 0
%           if the segment AB is all outside of the polygon n = -1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Validation examples:
% Example 1:
%   s=struct('A',[2,3],'B',[4,2])
%   p=[-3,0; 0,3; 3,0; 0,-1];
%   inters=intersectSegmentConvPolygon(s,p)
%   inters = 
%    A: []
%    B: []
%    n: -1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example 2:
%   p=[-3,0; 0,3; 3,0; 0,-1];
%   s=struct('A',[0,0],'B',[4,2]);
%   inters=intersectSegmentConvPolygon(s,p)
%   inters = 
%    A: [2 1]
%    B: [0 0]
%    n: 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example 3:
%   p=[-3,0; 0,3; 3,0; 0,-1];
%   s=struct('A',[0,0],'B',[0,1]);
%   inters=intersectSegmentConvPolygon(s,p)
%   inters = 
%    A: [0 0]
%    B: [0 1]
%    n: 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example 4:
%   p=[-3,0; 0,3; 3,0; 0,-1];
%   s=struct('A',[-2,3],'B',[4,2]);
%   inters=intersectSegmentConvPolygon(s,p)
%   inters = 
%    A: [-0.2857 2.7143]
%    B: [0.4000 2.6000]
%    n: 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function inters = intersectSegmentConvPolygon(s, p)
    %TODO
    in1 = inpolygon(s.A(1), s.A(2), p(:,1), p(:,2));
    in2 = inpolygon(s.B(1), s.B(2), p(:,1), p(:,2));
    if in1 == 1 & in2 == 1
        int = [s.A; s.B];
        n = 0;
        inters = struct('A', s.A, 'B', s.B, 'n', n);
    else
        pointaux = zeros(size(p,1)-1,2);
        k=1;
        for i=1:size(p,1)-1
            s1 = struct('A',p(i,:), 'B', p(i+1,:));
            auxint=intersectSegments(s1,s);
            if(size(auxint,1)~=0)
              pointaux(k,:) = auxint;
              k=k+1;
            end
        end    
        point=pointaux(1:k-1,:);
        
        s1 = struct('A',p(i+1,:), 'B', p(1,:));
        
        inter = [point; intersectSegments(s1,s)];
        
        n = size(inter,1);
        if n == 0
            n = -1;
            inters = struct('A', [], 'B', [], 'n', n);
        elseif n == 1
            if in1 == 1
                inters = struct('A', inter(1,:), 'B', s.A, 'n', n);
            elseif in2 == 1
                inters = struct('A', inter(1,:), 'B', s.B, 'n', n);   
            end
        elseif n == 2
            inters = struct('A', inter(1,:), 'B', inter(2,:), 'n', n);
        end
    end    
end