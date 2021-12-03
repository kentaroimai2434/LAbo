%% matlab ������  ESN(sin�g,�t���[�����\��,�x�ꎞ��1,1����)
clear;
clc;
%% �f�[�^����
for n=1:350;
 d(n)=1/2*sin(n/4);
end
%% �l�b�g���[�N����
AL=50;%�S�̒���
SL=200;%�w�K����
PL=50;%�\������
a=100;%�ߓn�̒���
inSize=1; 
outSize=1;
resSize=20;%�j���[�����̐�
p=0.2; % sparity
ram=0.001;%���b�W��A��
%%  �d�ݐ���
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z
%% ���U�[�o�̏d�݂̐���
intWM = sprand(resSize, resSize, p);
intWM = spfun(@Point1tominus1,intWM);%2%�q�����d�݂�[-0.1,0.1]�ɂ��Ă���
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius
A=eigs(W,1,'largestabs');
%%  ������ԂƊw�K�X�V������
X=zeros(resSize,AL);
I=eye(resSize);
M=zeros(resSize,SL);
T=zeros(SL,1);
preout=zeros(PL+1,outSize);
V=(rand(resSize,1)*0.0016)-0.0008;
%% ������Ԋ�����
X(:,100)=tanh(Win*d(99));%�ߓn��菜���Ċ�����101����X�^�[�g�Ȃ̂�100�Ԗڍ��
for t=100:1:299%�w�K������
   X(:,t+1)=tanh(Win*d(t)+W*X(:,t)+V*1);
end
%% �w�K����
for t=a+1:1:a+SL%101:300
   M(:,t-100)=[X(:,t)];%�ŏ�101�̓�����ԃx�N�g��
   T(t-100)=d(t);%�o�ė~�����o�͂�101
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1)=d(300);
%% �\��
for t=301:1:350
    X(:,t)=tanh(Win*preout(t-300)+W*X(:,t-1)+V*1);
    out=Wout'*X(:,t);
    preout((t-299),1)=out;
end
preout=preout';
%% �덷
rmse=sqrt(sum((d(301:1:350)-preout(2:1:51)).^2)/50);
%% �v���b�g
figure(1);
plot((301:350),d(301:350),'--');
set(gca,'xlim',[300, 350]);
xlabel('t');
ylabel('x(t)');
title(sprintf('Sine wave'));
hold on
plot((301:350),preout(2:51),'-');
legend('�ڕW�l','�\���l')
%%