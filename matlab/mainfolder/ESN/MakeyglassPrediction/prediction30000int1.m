%% matlab ������  ESN(mackyglass�t���[�����\��)
clear;
clc;
%% ���n��ǂݎ��
fileID =fopen('makeyglasstimedate30000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
%% �l�b�g���[�N����
inSize=1; 
outSize=1;
resSize=1000;%�j���[�����̐�
p=0.01; % sparity
ram=1;%���b�W��A�W��
%%  �d�ݐ���
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z
Wback=(rand(resSize,outSize)*0.2)-0.1;
%% ���U�[�o�̏d�݂̐���
intWM = sprand(resSize, resSize, p);
intWM = spfun(@minusPoint5,intWM);
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.9;% spectral radius
A=eigs(W,1,'largestabs');
%%  ������ԂƊw�K�X�V������
X=zeros(12001,resSize);
Y=zeros(12001,1);
I=eye(resSize);
M=zeros(5000,resSize);
T=zeros(5000,1);
%% ������Ԋ�����
X(1,:)=tanh(Win'*D(1)+Wback'*D(1));
for t=1:1:6999
    X(t+1,:)=tanh(Win'*D(t+1)+(W*X(t,:)')'+Wback'*D(t+1));
end
%% �w�K����
for t=1:1:5000
   M(t,:)=X(2000+t,:);
       T(t)=D(2000+t)';
end
Wout=pinv(M'*M+ram*I)*M'*T;
preout=zeros(5001,1);
preout(1,1)=D(7000,1);
for t=7001:1:12000
    X(t,:)=tanh(Win'*preout((t-7000),1)+(W*X(t-1,:)')'+Wback'*preout((t-7000),1));
    out=X(t,:)*Wout;
    preout((t-6999),1)=out;
    
end
D=D';
preout=preout';
rmse=sqrt(sum((D(7001:1:12000)-preout(2:1:5001)).^2)/5000);
figure(1);
xlabel('t');
xlim([7001, 12000])
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
plot((7001:1:12000),D(7001:1:12000),'r-');
hold on
plot((7001:1:12000),preout(2:1:5001),'b--');

