%Function which return the lenght of a segment defined by the
%segment s
%
%Input:
%   s: struct with the segment: s.A and S.B
%
%Return:
%   length: The lenght of the segement s
%           as the distance between s.A and s.B
%
%Example of use:
%   s=struct('A',[2,3],'B',[4,2])
%   l=segmentLength(s)
%   l --> 2.2361

function length = segmentLength(s)
    %TODO
    vectAB = s.B - s.A;
    length = norm (vectAB);    
end