%% matlab ������  ESN(mackyglass�\���t���[����)
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
inSize=50; 
outSize=1;
resSize=1000;%�j���[�����̐�
p=0.02; % sparity
ram=0.01;%���b�W��A��
%%  �d�ݐ���
Win=(rand(resSize,inSize)*1)-0.5;%[-0.1,0.1]�̈�l���z
%% ���U�[�o�̏d�݂̐���
intWM = sprand(resSize, resSize, p);
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius
A=eigs(W,1,'largestabs');
%%  ������ԂƊw�K�X�V������
X=zeros(resSize,AL);
I=eye(resSize);
M=zeros(resSize,SL);
T=zeros(SL,1);
preout=zeros(PL+50,outSize);
%% ������Ԋ�����
U=repelem(D(1:1:50),1);
X(:,51)=tanh(Win*U);
for t=51:1:1999
    U=repelem(D(t-49:1:t),1);
    X(:,t+1)=tanh(Win*U+W*X(:,t));
end
for t=2000:1:6999
   U=repelem(D(t-49:1:t),1);
   X(:,t+1)=tanh(Win*U+W*X(:,t));
end
%% �w�K����
for t=a+1:1:a+SL
   M(:,t-2000)=X(:,t);
   T(t-2000)=D(t);
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1:1:50)=(D(6951:1:7000));
%% �\��
for t=7001:1:12000
    U=repelem(preout(t-7000:1:t-6951),1);
    X(:,t)=tanh(Win*U+W*X(:,t-1));
    out=Wout'*X(:,t);
    preout((t-6950),1)=out;
end
D=D';
preout=preout';
%% �덷
err = immse(D(7001:1:12000),preout(1:1:5000));
rmse=sqrt(sum((D(7001:1:12000)-preout(51:1:5050)).^2)/5000);
%% �v���b�g
figure(1);
xlabel('t');
xlim([7001, 12000])
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
plot((7001:1:12000),D(7001:1:12000),'--');
hold on
plot((7001:1:12000),preout(51:1:5050),'-');
%%