clc;
clear;
x(1) = 0.9;
figure(1); 
for a = 0:0.001:4
    for t=1:99
        x(t+1) = a * x(t) * (1-x(t));
    end
    plot(a*ones(1,10),x(91:100),'b.','MarkerSize',0.5);
    hold on
end
title('•ªŠò}')
xlabel('a')
ylabel('x(t)')
