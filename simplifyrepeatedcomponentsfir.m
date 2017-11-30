function [intercoord,realoccurence,totaloccurence] = simplifyrepeatedcomponentsfir(intervec)

intervec = round (1000*intervec);
[intercoord, i, j] = unique(intervec,'rows');
totaloccurence = zeros(size(intercoord,1),1);
realoccurence = zeros(size(intercoord,1),1);
for k = 1:size(j,1)
    totaloccurence(j(k))=totaloccurence(j(k))+1;
end

for k = 1:size(intercoord,1)
    if totaloccurence(k) ==1 || totaloccurence(k) ==2
        realoccurence(k) = 1;
    elseif totaloccurence(k) ==4
        realoccurence(k) = 2;
    elseif totaloccurence(k) ==6
        realoccurence(k) = 3;       
    end
end
intercoord = intercoord/1000;