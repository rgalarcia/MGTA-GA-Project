%Function which return the perpendicular distance between a point and a
%line
%
%Input:
%   [x,y]: point coordinates
%   l: struct with the segment defining the first line : l.A and l.B
%
%Return:
%   dist: The perperdicular distance between the point [x,y] and the line l
%
%Example of use:
%   l=struct('A',[-4,0],'B',[0,3])
%   p=[0,5]
%   d=distancePointLine(p,l)
%   d --> 1.6

function d = distancePointLine(p,l)
    %TODO
    vectAB = l.B - l.A;
    for i = 1:size(p,1)
        vectAP = p(i,:) - l.A;
        vectBP = p(i,:) - l.B;
        if norm(vectAP)<norm(vectBP)
            areaparal = det([vectAB;vectAP]);
            d(i) = abs(areaparal)/(max(norm(vectAB),norm(vectAP)));
        else
            areaparal = det([vectAB;vectBP]);
            d(i) = abs(areaparal)/(max(norm(vectAB),norm(vectBP)));
        end    
    end
end