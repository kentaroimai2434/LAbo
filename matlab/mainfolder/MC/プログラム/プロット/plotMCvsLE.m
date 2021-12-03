%% LEvsMC �\��
clear;
clc;
%% �f�[�^�ǂݍ���
fileID =fopen('LEmakey_general_DLR.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MCmakey_general_ridge_DLR.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MCmakey_general_regression_DLR','r');
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

figure(2);%��ʉ�
plot(LE,MCbase,'+b');
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%%

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