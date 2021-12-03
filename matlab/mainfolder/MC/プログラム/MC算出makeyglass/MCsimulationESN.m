%% matlab ������  ESN(mackyglassMC�Z�o)
%{
����:�_��������͂�1��
�o�͂ɓ��͓͂���Ȃ�
N=150
Win[-0.1,0.1]
1200
200:500:500
�w�K�Ń��U�[�o�[�����ŉ񂵂��̌��ʂ��w�K
%}
clear;
clc;
%% ���n��ǂݎ��
%for o=1:1:10 %�g�`���o����
fileID =fopen('makeyglasstimedate12000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:12000);%1��11��21�E�E�E10���݂Ńf�[�^���
u=E;%1200�f�[�^
%% �l�b�g���[�N����
AL=1200;%�S�̒���
SL=500;%�w�K����
PL=500;%�\������
a=200;%�ߓn�̒���
inSize=1; 
outSize=1;
resSize=150;%�j���[�����̐�
%p=0.02; % sparity
ram=0.000001;%���b�W��A��
Z=zeros(150,150);%�����_���ɐڑ�����ꏊ150?150=22500
for z=1:1:4500% 20%�����ڑ�=4500
    rr=randi(150,1);%150�̐����烉���_���Ɉ��
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
N = nnz(Z);
%%  �d�ݐ���
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z(by�_������j
%% ���U�[�o�̏d�݂̐���

intWM= normrnd(0,exp(-1.5),[resSize,resSize]) ;%�S�������K���z[-1.5 -0.5]�܂ŕW���΍��ς���
intWM=intWM.*Z;
maxval = max(abs(eigs(intWM,1)));%��=e^(-1.2����-0.9)�܂Ń�0.02���₷
W = intWM/maxval;%�܂�-1.2+0.02=-1.18
W=W*0.98;% spectral radius(�ɓ�����̘_�����)
%W=intWM;
A=eigs(W,1,'largestabs');
%{
intWM = sprand(resSize, resSize, p);
intWM = spfun(@Point1tominus1,intWM);%2%�q�����d�݂�[-0.1,0.1]�ɂ��Ă���
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius(�ɓ�����̘_�����)
A=eigs(W,1,'largestabs');
%}
%%  ������ԂƊw�K�X�V������
X=zeros(resSize,AL);%�S���̓�����Ԃ̔��A�����ԁA�c��ԃx�N�g��
I=eye(resSize);%�P�ʍs��
M=zeros(resSize,SL);%�w�K�p�s��
T=zeros(SL,1);%���t�f�[�^�x�N�g��
preout=zeros(PL+1,outSize);%�\���x�N�g��
XX=zeros(resSize,AL);%���U�[�o�̏d�݂����g���Ċ�����
OX=zeros(resSize,AL);%k�O�̓��͂����Ċ�����
MM=zeros(resSize,SL);%�w�K�p�s��
%% ������Ԋ�����

X(:,200)=tanh(Win*E(199));%�ߓn��菜���Ċ�����201����X�^�[�g�Ȃ̂�200�Ԗڍ��
OX(:,199)=tanh(Win*E(198));%k=1�Ȃ̂�199���g��
%{
for t=2:1:199%�ߓn
    X(:,t+1)=tanh(Win*E(t)+W*X(:,t));
end
%}
x=X(:,200);%������ԃx�N�g���c150
p=zeros(150,1);%�[��150�x�N�g��
r=randi(150,1);%150�̒����烉���_���ɐ������
p(r,1)=10^-12;%�����_���ɑI�񂾔ԍ���10^-12����
xp=x+p;%������ԃx�N�g���ɐۓ���^����
ganma=norm(xp-x);%�m������l�̌v�Z
ganma0=ganma;%�����̃m������0
for t=200:1:699%�w�K������
   X(:,t+1)=tanh(Win*E(t)+W*X(:,t));%������Ԋ�����
   x=X(:,t+1);%���̓�����ԃx�N�g��
    xp=tanh(Win*E(t)+W*xp);%�ۓ���^�����ȓ�����ԃx�N�g��
    ganma=norm(xp-x);%���̃m������l�̌v�Z
    xp=x+(ganma0/ganma)*(xp-x);%���K��
    OX(:,t)=tanh(Win*E(t-1)+W*OX(:,t-1));%200�Ԗڂ͓��͓���Ċ�����k=1
    XX(:,t+1)=tanh(W*OX(:,t));%201�Ԗڂ����U�[�o�����ō��
end
%% �w�K����
for t=a+1:1:a+SL%201:700
   M(:,t-200)=[X(:,t)];%�ŏ�101�̓�����ԃx�N�g��
   T(t-200)=E(t);%�o�ė~�����o�͂�1001
   MM(:,t-200)=[XX(:,t)];
end
M=M';
MM=MM';
Wout=pinv(M'*M+ram*I)*M'*T;
Woutk1=pinv(MM'*MM+ram*I)*MM'*T;
%Wout=pinv(M)*T;
preout(1)=E(700);
y1=zeros(PL,outSize);%MC�̂��߂�y1
%% �\��
for t=701:1:1200
    X(:,t)=tanh(Win*preout(t-700)+W*X(:,t-1));%�t���[�����̂��߂�preout����͂�
    out=Wout'*X(:,t);%701�Ԗڏo��
    preout((t-699),1)=out;
    OX(:,t-1)=tanh(Win*E(t-2)+W*OX(:,t-2));%�����X�e�b�v����
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk1'*XX(:,t);
    y1((t-700),1)=out1;
end
D=D';
E=E';
preout=preout';
ria=log(ganma/ganma0)
MC1=cov(E(699:1198),y1)/(var(E(700:1199))*var(y1));
MC1=MC1(1,2);
%% �덷
%err = immse(D(10001:1:30000),preout(51:1:20050));
rmse=sqrt(sum((E(701:1:1200)-preout(2:1:501)).^2)/500)
%R(o,1)=rmse;
%% �v���b�g

figure(1);
plot((1:1:1200),E(1:1:1200),'--');
set(gca,'xlim',[0, 1200]);
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((701:1:1200),preout(2:1:501),'-');
%{
legend('cos(x)','cos(2x)')
%figure(o+10);
plot((1001:1:2000),E(1001:1:2000),'--');
set(gca,'xlim',[1000, 2000]);
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((1001:1:2000),preout(51:1:1050),'-');
%legend('cos(x)','cos(2x)')
%}
%end
%%