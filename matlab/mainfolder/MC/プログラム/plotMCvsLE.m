%% LEvsMC 表示
clear;
clc;
%% データ読み込み
fileID =fopen('LEmakey_1200_SCR_v[0.01:0.01:10.0]_in[-0.01,0.01]_test12.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MCmakey_1200_regression_SCR_v[0.01:0.01:10.0]_in[-0.01,0.01]_test12.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('LEmakey_1200_SCR_v[0.01:0.01:10.0]_in[-1,1]_test13.tex','r');
formatspac='%f';
LE1=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MCmakey_1200_regression_SCR_v[0.01:0.01:10.0]_in[-1,1]_test13.tex','r');
formatspac='%f';
MC1=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('LEmakey_1200_SCR_v[0.01:0.01:10.0]_in[-0.1,0.1]_test12.tex','r');
formatspac='%f';
LE2=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MCmakey_1200_regression_SCR_v[0.01:0.01:10.0]_in[-0.1,0.1]_test12.tex','r');
formatspac='%f';
MC2=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('LEmakey_1200_SCR_v[0.01:0.01:10.0]_in[-0.001,0.001]_test11.tex','r');
formatspac='%f';
LE3=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MCmakey_1200_regression_SCR_v[0.01:0.01:10.0]_in[-0.001,0.001]_test11.tex','r');
formatspac='%f';
MC3=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('LEmakey_1200_SCR_v[0.01:0.01:10.0]_in[-0.00001,0.00001]_test13.tex','r');
formatspac='%f';
LE4=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MCmakey_1200_regression_SCR_v[0.01:0.01:10.0]_in[-0.00001,0.00001]_test13.tex','r');
formatspac='%f';
MC4=fscanf(fileID,formatspac);
fclose(fileID);
%%
%{
fileID =fopen('r[0.01:0.05:3.01].tex','r');
formatspac='%f';
r=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('v[0.01:0.05:3.01].tex','r');
formatspac='%f';
v=fscanf(fileID,formatspac);
fclose(fileID);

%
fileID =fopen('MCmakey_1200_RMSE_SCR_test7.tex','r');
formatspac='%f';
RMSE=fscanf(fileID,formatspac);
fclose(fileID);
%}
%{
fileID =fopen('MCmakey_general_regression_DLR','r');
formatspac='%f';
MCbase=fscanf(fileID,formatspac);
fclose(fileID);
%}
%% 範囲書き出し

%{
for nv=1:1:61          %
for nr=1:1:61          %61番までvは一緒
r=-0.04+0.05*nr;             %リザーバの固定された絶対値r
v=-0.04+0.05*nv;
fileID = fopen('r[0.01:0.05:3.01].tex','a');
fprintf(fileID,'%f\n',r);
fclose(fileID);
fileID = fopen('v[0.01:0.05:3.01].tex','a');
fprintf(fileID,'%f\n',v);
fclose(fileID);
end
end
%}


%% プロット
figure(1);%リッジ
plot(LE1,MC1,'sb');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%
hold on
figure(1)
plot(LE2,MC2,'dr');
%}
%{
hold on
figure(1)
plot(LE,MC,'dr');
%}
%
hold on
figure(1)
plot(LE3(1:1000),MC3(1:1000),'^g');
%}
%{
hold on
figure(1)
plot(LE3(1001:2000),MC3(1001:2000),'^g');
%
%}
hold on
figure(1)
plot(LE4,MC4,'vk');
%}
hold on
figure(1)
legend('1','0.1','0.001','0.00001');
grid on

figure(4);%リッジ
plot(LE1,MC1,'sb');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%
hold on
figure(4)
plot(LE2,MC2,'dr');
%}
%
hold on
figure(4)
plot(LE,MC,'^k');
%}
%{
hold on
figure(4)
%plot(LE3(1:1000),MC3(1:1000),'+r');
%}
%{
hold on
figure(1)
plot(LE3(1001:2000),MC3(1001:2000),'^g');
%
%}
%{
hold on
figure(4)
%plot(LE4,MC4,'*k');
%}
hold on
figure(4)
legend('1','0.1','0.01');
grid on

figure(7);%リッジ
%plot(LE1,MC1,'sb');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%{
hold on
figure(4)
plot(LE2,MC2,'dr');
%}
%{
hold on
figure(7)
plot(LE,MC,'^k');
%}
%
hold on
figure(7)
plot(LE3(1:1000),MC3(1:1000),'vb');
%}
%
hold on
figure(7)
plot(LE3(1001:2000),MC3(1001:2000),'+r');
%
%}
%
hold on
figure(7)
plot(LE4,MC4,'*k');
%}
hold on
figure(7)
legend('0.001','0.0001','0.00001');
grid on





figure(5);%リッジ
plot(0.01:0.01:10,MC1,'sb');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('r');
ylabel('MC');
%
hold on
figure(5)
plot(0.01:0.01:10,MC2,'dr');
%}
%
hold on
figure(5)
plot(0.01:0.01:10,MC,'^k');
%}
%{
hold on
figure(5)
plot(0.01:0.01:10,MC3(1:1000),'+r');
%}
%{
hold on
figure(1)
plot(LE3(1001:2000),MC3(1001:2000),'^g');
%
%}
%{
hold on
figure(5)
plot(0.01:0.01:10,MC4,'*k');
%}
hold on
figure(5)
legend('1','0.1','0.01');
grid on


figure(8);%リッジ
%plot(0.01:0.01:10,MC1,'sb');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('r');
ylabel('MC');
%{
hold on
figure(5)
plot(0.01:0.01:10,MC2,'dr');
%}
%{
hold on
figure(5)
plot(0.01:0.01:10,MC,'^k');
%}
%
hold on
figure(8)
plot(0.01:0.01:10,MC3(1:1000),'vb');
%}
%
hold on
figure(8)
plot(0.01:0.01:10,MC3(1001:2000),'+r');
%
%}
%
hold on
figure(8)
plot(0.01:0.01:10,MC4,'*k');
%}
hold on
figure(8)
legend('0.001','0.0001','0.00001');
grid on



figure(2);%一般化
plot(0.01:0.01:10,MC1,'sb');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%
hold on
figure(2)
plot(0.01:0.01:10,MC2,'dr');
%}
%{
hold on
figure(2)
plot(0.01:0.01:10,MC,'dr');
%}
%
hold on
figure(2)
plot(0.01:0.01:10,MC3(1:1000),'^g');
%}
%{
hold on
figure(2)
plot(0.01:0.01:10,MC3(1001:2000),'^k');
%}
%
hold on
figure(2)
plot(0.01:0.01:10,MC4,'vk');
%}
hold on
figure(2)
legend('1','0.1','0.001','0.00001');
grid on
%plot(0.01:0.01:10,MC,'+b');
%set(gca,'xlim',[-1,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('r');
ylabel('MC');
%}
figure(3);%一般化
plot(0.01:0.01:10,LE1,'sb');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
hold on
figure(3)
plot(0.01:0.01:10,LE2,'dr');
hold on
figure(3)
plot(0.01:0.01:10,LE,'^k');
hold on
figure(3)
plot(0.01:0.01:10,LE3(1:1000),'vg');
hold on
figure(3)
plot(0.01:0.01:10,LE3(1001:2000),'+c');
hold on
figure(3)
plot(0.01:0.01:10,LE4,'*m');
hold on
figure(3)
legend('1','0.1','0.01','0.001','0.0001','0.00001');
%plot(0.01:0.01:10,MC,'+b');
%set(gca,'xlim',[-1,0.4]);
%set(gca,'ylim',[0,100]);
%plot(0.01:0.01:10,LE,'+b');
%set(gca,'xlim',[-1,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('r');
ylabel('LE');

figure(6);%一般化
plot(0.01:0.01:10,LE1,'sb');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%{
hold on
figure(3)
plot(0.01:0.01:10,LE2,'dr');
hold on
figure(3)
plot(0.01:0.01:10,LE,'^k');
hold on
figure(3)
plot(0.01:0.01:10,LE3(1:1000),'vg');
hold on
figure(3)
plot(0.01:0.01:10,LE3(1001:2000),'+c');
%}
hold on
figure(6)
plot(0.01:0.01:10,LE4,'dr');
hold on
figure(6)
legend('1','0.00001');
%plot(0.01:0.01:10,MC,'+b');
%set(gca,'xlim',[-1,0.4]);
%set(gca,'ylim',[0,100]);
%plot(0.01:0.01:10,LE,'+b');
%set(gca,'xlim',[-1,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('r');
ylabel('LE');
grid on
%}
%% プロット　v,r
%{
figure(2);
plot3(0.01:0.01:10,LE,MC,'.b');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('r');
ylabel('LE');
zlabel('MC');

figure(3);
plot3(r,v,LE,'.b');
%set(gca,'xlim',[-2,0.4]);
%set(gca,'ylim',[0,100]);
xlabel('r');
ylabel('v');
zlabel('LE');
%}
%%

% 同時にプロット用

%{
fileID =fopen('LESH.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCSH.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
hold on
figure(1);
plot(LE,MC,'+r');
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
fileID =fopen('LEBA.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCBA.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
hold on
figure(1);
plot(LE,MC,'+k');
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
fileID =fopen('LEWS.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCWS.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
hold on
figure(1);
plot(LE,MC,'+y');
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%}