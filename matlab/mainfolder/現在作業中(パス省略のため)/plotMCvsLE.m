%% LEvsMC �\��
clear;
clc;
%% �f�[�^�ǂݍ���

fileID =fopen('LErandam_makey_noise_1200_[-0.25,0.25]SW.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MCrandam_makey_noise_ridge_1200_[-0.25,0.25]SW.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MCrandam_makey_noise_regression_1200_[-0.25,0.25]SW.tex','r');
formatspac='%f';
MCbase=fscanf(fileID,formatspac);
fclose(fileID);

%% �v���b�g
figure(1);%���b�W
plot(LE,MC,'+b');
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%{
figure(2);%��ʉ�
plot(LE,MCbase,'+b');
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%%
%}
% �����Ƀv���b�g�p

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
%}