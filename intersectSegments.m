%Function which does the intersection of two segments.
%
%The function returns a point which is a vector with position [x,y]
%If there is not intersection returns -1
%
%Input:
%   s1: struct with the first segment  : s1.A and s1.B
%   s2: struct with the second segment : s2.C and s2.D
%
%Return:
%   intersect: The vector containg the interesction point [x,y]
%              If there is not intersection will return -1.
%
%Example of use:
%   s1 = struct('A',[1,4],'B',[4,1])
%   s2 = struct('A',[4,1],'B',[4,0])
%   p=intersectSegments(s1,s2)
%   p --> [3,2]

function point = intersectSegments(s1,s2)
    %TODO
    epsilon = 1e-9;
    vectAB = s1.B - s1.A;
    vectAC = s2.A - s1.A;
    vectCD = s2.B - s2.A;
    d = vectAB(1)*vectCD(2)-vectCD(1)*vectAB(2);
    if d == 0
        %disp('The segments are parallel so they do not intersect')
        point = [];
    else
        l1 = (vectAC(1)*vectCD(2)-vectCD(1)*vectAC(2))/d;
        l2 = (vectAC(1)*vectAB(2)-vectAB(1)*vectAC(2))/d;
        if l1 <= 1+epsilon && l2 <= 1+epsilon && l1>=0-epsilon && l2>=0-epsilon
            point = s1.A + l1 * vectAB;
        else 
        %disp('The segments do not intersect')
            point = [];
        end
    end      
end
    