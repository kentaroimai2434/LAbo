clc;
clear;
b=0.3;     %�G�m���ʑ��p�����[�^
x(1)=0;
y(1)=0;
x(2)=0;
y(2)=0;
figure(1); 
for a = 0.3:0.01:1.5
    for t=3:1000
        y(t)=b-((a/b)*(y(t-1)^2))+b*y(t-2);
    end
    plot(a*ones(1,50),y(951:1000),'b.','MarkerSize',0.5);
    hold on
end
title('����},b=0.3')
xlabel('a,')
ylabel('y(t)')

a=0.42;    %�G�m���ʑ��p�����[�^
b=0.3;     %�G�m���ʑ��p�����[�^
L=10000;    %����
x(1)=0;
y(1)=0;
x(2)=1-a*(x(1)^2)+y(1);
y(2)=b*x(1);
z=0.05.*randn(1,L)+0.00000001;    %����
for i=3:L
    y(i)=b-((a/b)*(y(i-1)^2))+b*y(i-2)+z(1,i);  %�G�m�����n��X�V
end