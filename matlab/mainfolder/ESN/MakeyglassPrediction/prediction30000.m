%% matlab ������  ESN(mackyglass�\���t���[�����ɓ�����Ɣ�r)
clear;
clc;
%% ���n��ǂݎ��
for o=1:1:10 %�g�`���o����
fileID =fopen('makeyglasstimedate30000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
%% �l�b�g���[�N����
AL=30000;%�S�̒���
SL=9000;%�w�K����
PL=20000;%�\������
a=1000;%�ߓn�̒���
inSize=50; 
outSize=1;
resSize=1000;%�j���[�����̐�
p=0.02; % sparity
ram=0.1;%���b�W��A��
%%  �d�ݐ���
Win=(rand(resSize,inSize)*2)-1;%[-1,1]�̈�l���z(�傫�߂Ŏ��by�ɓ�����j
%% ���U�[�o�̏d�݂̐���
intWM = sprand(resSize, resSize, p);
intWM = spfun(@Point1tominus1,intWM);%1%�q�����d�݂�[-0.1,0.1]�ɂ��Ă���
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius
A=eigs(W,1,'largestabs');
%%  ������ԂƊw�K�X�V������
X=zeros(resSize,AL);
I=eye(resSize+50);%���͂��o�͂ɓ����̂�+50
M=zeros(resSize+50,SL);
T=zeros(SL,1);
preout=zeros(PL+50,outSize);
%% ������Ԋ�����
U=repelem(D(1:1:50),1);
X(:,51)=tanh(Win*U);
for t=51:1:999%�ߓn
    U=repelem(D(t-49:1:t),1);%x(t+1)��u(t)�Ŋ�����
    X(:,t+1)=tanh(Win*U+W*X(:,t));
end
for t=1000:1:9999%�w�K������
   U=repelem(D(t-49:1:t),1);
   X(:,t+1)=tanh(Win*U+W*X(:,t));
end
%% �w�K����
for t=a+1:1:a+SL%1001:10000
   U=repelem(D(t-50:1:t-1),1);%�ŏ�951����1000�܂ł̐������l
   M(:,t-1000)=[X(:,t);U];%�ŏ�1001�̓�����ԃx�N�g��
   T(t-1000)=D(t);%�o�ė~�����o�͂�1001
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1:1:50)=(D(9951:1:10000));
%% �\��
for t=10001:1:30000
    U=repelem(preout(t-10000:1:t-9951),1);
    X(:,t)=tanh(Win*U+W*X(:,t-1));
    out=Wout'*[X(:,t);U];
    preout((t-9950),1)=out;
end
D=D';
preout=preout';
%% �덷
err = immse(D(10001:1:30000),preout(51:1:20050));
rmse=sqrt(sum((D(10001:1:30000)-preout(51:1:20050)).^2)/20000);
R(o,1)=rmse;
%% �v���b�g
figure(o);
xlabel('t');
xlim([10001, 30000])
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
plot((10001:1:30000),D(10001:1:30000),'--');
hold on
plot((10001:1:30000),preout(51:1:20050),'-');
end
%%