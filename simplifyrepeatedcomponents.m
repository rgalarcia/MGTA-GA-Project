function [intercoord,realoccurence,totaloccurence] = simplifyrepeatedcomponents(intervec)

intervec = round (1000*intervec);
[intercoord, i, j] = unique(intervec,'rows');
totaloccurence = zeros(size(intercoord,1),1);
realoccurence = zeros(size(intercoord,1),1);
for k = 1:size(j,1)
    totaloccurence(j(k))=totaloccurence(j(k))+1;
end

for k = 1:size(intercoord,1)
    if totaloccurence(k) ==1
        realoccurence(k) = 1;
    else 
        r = roots([1 -1 -2*totaloccurence(k)]);
        if r(1)>0 
            realoccurence(k) = r(1);
        else
            realoccurence(k) = r(2);
        end
    end
end
intercoord = intercoord/1000;