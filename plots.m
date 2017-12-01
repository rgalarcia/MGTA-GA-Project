function plots (valuesAlpha,valuesObj1,valuesObj2)
    figure(1)
    semilogy(valuesAlpha, valuesObj1, 'ro-');
    hold on;
    semilogy(valuesAlpha, valuesObj2, 'bo-');
    title('Obj1 & Obj2 vs Value of alpha'); xlabel('Value of \alpha'); ylabel('Value of the function');
    legend('Obj1','Obj2')
    hold off;

    figure(2)
    loglog(valuesObj1,valuesObj2,'bx');
    title('Obj1 vs Obj2 '); xlabel('Obj1'); ylabel('Obj2');
    for i = 1:length(valuesAlpha)
        text(valuesObj1(i),valuesObj2(i),{valuesAlpha(i)});
    end
    
    figure(3)
    loglog([valuesObj1(0.05*i+1),valuesObj1(0.8*i+1)],[valuesObj2(0.05*i+1),valuesObj2(0.8*i+1)],'r')
    hold on;
    loglog(valuesObj1,valuesObj2,'bx');
    title('Obj1 vs Obj2 '); xlabel('Obj1'); ylabel('Obj2');
    text(valuesObj1(0.8*i+1),valuesObj2(0.8*i+1),{valuesAlpha(0.8*i+1)});
    text(valuesObj1(0.05*i+1),valuesObj2(0.05*i+1),{valuesAlpha(0.05*i+1)});
end