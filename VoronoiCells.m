function [V,newc] = VoronoiCells(vor)
[V,c] = voronoin(vor);
% take away cells with infinite points
for i = 1:size(vor,1)
    test = 0;
    for j = 1:size(c{i,:},2)
        if c{i,:}(j)==1
           test = 1;
        end   
    end
    if test ==0
        newc{i,:}=c{i,:};
%         plot([V(newc{i,:},1);V(newc{i,1},1)],[V(newc{i,:},2);V(newc{i,1},2)])
%         hold on
%         plot(vor(i,1),vor(i,2),'b.')
        %text(vor(i,1)+8,vor(i,2),'\i','HorizontalAlignment','left')
    end
end