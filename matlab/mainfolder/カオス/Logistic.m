clear;
clc;
%% ロジスティック写像
a = 4;%出生率;
t=2000;
x=zeros(1,t);%要素入れる行ベクトル
x(1) = 0.1;%初期値
%% 更新
for n=1:t
    x(n+1) = a * x(n) * (1-x(n));
end
%% プロット
clf;%figureのクリア
figure(1)%時系列
plot(1:t,x(1:t),'-')
xlabel('t')
ylabel('x(t)')
%title(strcat('a=',num2str(a)))
xlim([1 100])
ylim([0 1])

figure(2)
plot(x(1:t-1),x(2:t),'.')
xlabel('x(t)')
ylabel('x(t+1)')

figure(3)
plot3(x(1:t-2),x(2:t-1),x(3:t),'.')
xlabel('x(t)')
ylabel('x(t+1)')
zlabel('x(t+2)')

figure(4)
plot(x(1:t-2),x(3:t),'.')
xlabel('x(t)')
ylabel('x(t+2)')
z=-0.05+(0.05+0.05)*rand(100,1);

figure(5)
plot(1:100,z,'-')
xlabel('t')
ylabel('x(t)')
figure(6)
plot(z(1:99),z(2:100),'.')
xlabel('x(t)')
ylabel('x(t+1)')
%
y=zeros(1,100);
y(1) = 0.1+1.0*10^-8;

for n=1:99
    y(n+1) = a * y(n) * (1-y(n));
end
hold on
figure(7); 
plot(1:t,x(1:t),'-')
xlim([1 50])
hold on
plot(1:50,y(1:50),'r--')
xlabel('t')
ylabel('x(t)')
title(strcat('a=',num2str(a)))
ylim([0 1])
legend('x(1) = 0.1','x(1) = 0.1+10^-8')
%}