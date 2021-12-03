%% matlab ������  ESN(mackyglass�\���t���[�����ɓ�����Ɣ�r)
clear;
clc;
%% ���n��ǂݎ��
for o=1:1:10 %�g�`���o����
fileID =fopen('makeyglasstimedate20000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:20000);
%% �l�b�g���[�N����
AL=2000;%�S�̒���
SL=900;%�w�K����
PL=1000;%�\������
a=100;%�ߓn�̒���
inSize=50; 
outSize=1;
resSize=1000;%�j���[�����̐�
p=0.02; % sparity
ram=0.0001;%���b�W��A��
%%  �d�ݐ���
Win=(rand(resSize,inSize)*2)-1;%[-1,1]�̈�l���z(�傫�߂Ŏ��by�ɓ�����j
%% ���U�[�o�̏d�݂̐���
intWM = sprand(resSize, resSize, p);
intWM = spfun(@Point1tominus1,intWM);%2%�q�����d�݂�[-0.1,0.1]�ɂ��Ă���
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius(�ɓ�����̘_�����)
A=eigs(W,1,'largestabs');
%%  ������ԂƊw�K�X�V������
X=zeros(resSize,AL);
I=eye(resSize+50);%���͂��o�͂ɓ����̂�+50
M=zeros(resSize+50,SL);
T=zeros(SL,1);
preout=zeros(PL+50,outSize);
%% ������Ԋ�����
U=repelem(E(1:1:50),1);
X(:,50)=tanh(Win*U);
for t=50:1:99%�ߓn
    U=repelem(E(t-49:1:t),1);%x(t+1)��u(t)�Ŋ�����
    X(:,t+1)=tanh(Win*U+W*X(:,t));
end
for t=100:1:999%�w�K������
  U=repelem(E(t-49:1:t),1);
   X(:,t+1)=tanh(Win*U+W*X(:,t));
end
%% �w�K����
for t=a+1:1:a+SL%101:1000
   U=repelem(E(t-50:1:t-1),1);%�ŏ�951����1000�܂ł̐������l
   M(:,t-100)=[X(:,t);U];%�ŏ�1001�̓�����ԃx�N�g��
   T(t-100)=E(t);%�o�ė~�����o�͂�1001
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1:1:50)=(E(951:1:1000));
%% �\��
for t=1001:1:2000
    U=repelem(preout(t-1000:1:t-951),1);
    X(:,t)=tanh(Win*U+W*X(:,t-1));
    out=Wout'*[X(:,t);U];
    preout((t-950),1)=out;
end
D=D';
preout=preout';
%% �덷
%err = immse(D(10001:1:30000),preout(51:1:20050));
%rmse=sqrt(sum((D(10001:10:20000)-preout(51:1:2051)).^2)/1000);
%R(o,1)=rmse;
%% �v���b�g
figure(o);
xlabel('t');
xlim([10001, 30000])
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
plot((10001:1:20000),D(10001:1:20000),'--');
hold on
plot((10001:10:20000),preout(51:1:1050),'-');
end
%%