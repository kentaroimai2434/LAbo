%% matlab ������  ESN(mackyglass�\�������X�e�b�v)
clear;
clc;
%% ���n��ǂݎ��
fileID =fopen('makeyglasstimedate12000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
%% �l�b�g���[�N����
AL=12000;%�S�̒���
SL=5000;%�w�K����
PL=5000;%�\������
a=2000;%�ߓn�̒���
inSize=25; 
outSize=1;
resSize=1000;%�j���[�����̐�
p=0.01; % sparity
ram=0.1;
%%  �d�ݐ���
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z
Wback=(rand(resSize,outSize)*0.2)-0.1;
%% ���U�[�o�̏d�݂̐���
intWM = sprand(resSize, resSize, p);
intWM = spfun(@minusPoint5,intWM);
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.8;% spectral radius
A=eigs(W,1,'largestabs');
%%  ������ԂƊw�K�X�V������
X=zeros(resSize,AL);
I=eye(resSize);
M=[];
T=[];
preout=zeros(PL,outSize);
%% ������Ԋ�����
U=repelem(D(1:1:25),1);
X(:,25)=tanh(Win*U+Wback*D(24));
for t=25:1:1999
    U=repelem(D(t-23:1:t+1),1);
    X(:,t+1)=tanh(Win*U+W*X(:,t)+Wback*D(t));
end
for t=2000:1:6999
    U=repelem(D(t-23:1:t+1),1);
    X(:,t+1)=tanh(Win*U+W*X(:,t)+Wback*D(t));
end
%% �w�K����
for t=a+1:1:a+SL
   M=[M,X(:,t)];
   T=[T;D(t)];
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
%% �\��
for t=7001:1:12000
    U=repelem(D(t-24:1:t),1);
    X(:,t)=tanh(Win*U+W*X(:,t-1)+Wback*D(t-1));
    out=Wout'*X(:,t);
    preout((t-7000),1)=out;
end
D=D';
preout=preout';
%% �덷
err = immse(D(7001:1:12000),preout(1:1:5000));
rmse=sqrt(sum((D(7001:1:12000)-preout(1:1:5000)).^2)/5000);
%% �v���b�g
figure(1);
xlabel('t');
xlim([7001, 12000])
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
plot((7001:1:12000),D(7001:1:12000),'--');
hold on
plot((7001:1:12000),preout(1:1:5000),'-');
%%