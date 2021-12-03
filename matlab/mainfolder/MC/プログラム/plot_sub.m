%% LEvsMC sub表示
clear;
clc;
%% データ読み込み
fileID =fopen('LEmakey_1200_SCR_test7.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MCmakey_1200_regression_SCR_test7.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('r[0.01:0.05:3.01].tex','r');
formatspac='%f';
r=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('v[0.01:0.05:3.01].tex','r');
formatspac='%f';
v=fscanf(fileID,formatspac);
fclose(fileID);
%% プロット
figure(1);%リッジ
plot(LE,MC,'+b');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
grid on
figure(2);%一般化
plot3(v,r,MC,'+b');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('v');
ylabel('r');
zlabel('MC');
grid on
figure(3);%一般化
plot3(v,r,LE,'+b');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('v');
ylabel('r');
zlabel('LE');
grid on
figure(4);%リッジ
%plot(LE(1:930),MC(1:930),'+b');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
legend('[0.01,1.00]');
grid on
hold on
figure(4);%リッジ
plot(LE(1:1220),MC(1:1220),'+b');
hold on
figure(4);%リッジ
plot(LE(1221:2440),MC(1221:2440),'+r');
hold on
figure(4);%リッジ
plot(LE(2441:3721),MC(2441:3721),'+k');

figure(5);%一般化
plot3(v(1:1220),r(1:1220),MC(1:1220),'+b');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('v');
ylabel('r');
zlabel('MC');
legend('[0.01,1.00]');
lgd.FontSize = 22;
grid on
hold on
figure(5);%一般化
plot3(v(1221:2440),r(1221:2440),MC(1221:2440),'+r');
hold on
figure(5);%一般化
plot3(v(2441:3721),r(2441:3721),MC(2441:3721),'+k');


figure(6);%一般化
plot3(v(1:1220),r(1:1220),LE(1:1220),'+b');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('v');
ylabel('r');
zlabel('LE');
legend('[0.01,1.00]');
grid on
hold on
figure(6);%一般化
plot3(v(1221:2440),r(1221:2440),LE(1221:2440),'+r');
hold on
figure(6);%一般化
plot3(v(2441:3721),r(2441:3721),LE(2441:3721),'+k');