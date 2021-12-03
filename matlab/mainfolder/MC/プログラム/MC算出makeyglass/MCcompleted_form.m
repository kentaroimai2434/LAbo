%% matlab ������  ESN(mackyglassMC�Z�o)
clear;
clc;
%% ���n��ǂݎ��
%for n=1:1:20
fileID =fopen('makeyglasstimedate12000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:12000);%1��11��21�E�E�E10���݂Ńf�[�^���
%% �l�b�g���[�N����
AL=1200;%�S�̒���
SL=500;%�w�K����
PL=500;%�\������
a=200;%�ߓn�̒���
inSize=1; 
outSize=1;
resSize=150;%�j���[�����̐�
ram=0.0000001;%���b�W��A��ram=0.00000001���炢���x�X�g


Z=zeros(150,150);%�����_���ɐڑ�����ꏊ
for z=1:1:3000% 20%�����ڑ�
    rr=randi(150,1);%150�̐����烉���_���Ɉ��
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
%}
A=Z;
%load('scallmat.mat')
N = nnz(Z)
%%  �d�ݐ���
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z(by�_������j
%% ���U�[�o�̏d�݂̐���
intWM= normrnd(0,exp(-1.5),[resSize,resSize]) ;%�S�������K���z[-1.5 -0.5]�܂ŕW���΍��ς���
intWM=intWM.*A;
maxval = max(abs(eigs(intWM,1)));%��=e^(-1.2����-0.9)�܂Ń�0.02���₷
W = intWM/maxval;%�܂�-1.2+0.02=-1.18
W=W*0.98;% spectral radius(�ɓ�����̘_�����)
%W=intWM;
AA=eigs(W,1,'largestabs');
%%  ������ԂƊw�K�X�V������
X=zeros(resSize,AL);%�S���̓�����Ԃ̔��A�����ԁA�c��ԃx�N�g��
I=eye(resSize);%�P�ʍs��
M=zeros(resSize,SL);%�w�K�p�s��
T=zeros(SL,1);%���t�f�[�^�x�N�g��
preout=zeros(PL+1,outSize);%�\���x�N�g��
%% ������Ԋ�����
X(:,200)=tanh(Win*E(199));%�ߓn��菜���Ċ�����201����X�^�[�g�Ȃ̂�200�Ԗڍ��
x=X(:,200);%������ԃx�N�g���c150
p=zeros(150,1);%�[��150�x�N�g��
r=randi(150,1);%150�̒����烉���_���ɐ������
p(1,1)=10^-12;%�����_���ɑI�񂾔ԍ���10^-12����
xp=x+p;%������ԃx�N�g���ɐۓ���^����
ganma=norm(xp-x);%�m������l�̌v�Z
ganma0=ganma;%�����̃m������0
for t=200:1:699%�w�K������
   X(:,t+1)=tanh(Win*E(t)+W*X(:,t));%������Ԋ�����
   x=X(:,t+1);%���̓�����ԃx�N�g��
    xp=tanh(Win*E(t)+W*xp);%�ۓ���^�����ȓ�����ԃx�N�g��
    ganma=norm(xp-x);%���̃m������l�̌v�Z
    xp=x+(ganma0/ganma)*(xp-x);%���K��
end
%% �w�K����
for t=a+1:1:a+SL%201:700
   M(:,t-200)=[X(:,t)];%�ŏ�101�̓�����ԃx�N�g��
   T(t-200)=E(t);%�o�ė~�����o�͂�1001
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1)=E(700);
%% �\��
for t=701:1:1200
    X(:,t)=tanh(Win*preout(t-700)+W*X(:,t-1));%�t���[�����̂��߂�preout����͂�
    out=Wout'*X(:,t);%701�Ԗڏo��
    preout((t-699),1)=out;
end
D=D';
E=E';
preout=preout';
ria=log(ganma/ganma0)
%% �덷
rmse=sqrt(sum((E(701:1:1200)-preout(2:1:501)).^2)/500)

%%MC�v�Z
y=zeros(PL,100);%MC�̂��߂�y1
MCk=zeros(1,100);
for k=1:1:100
for t=a+1:1:a+SL%201:700
  
   T(t-200)=E(t-k);%�o�ė~�����o�͂�1001
end
Woutk1=pinv(M)*T;
y=zeros(PL,100);%MC�̂��߂�y1
for t=701:1:1200
    X(:,t)=tanh(Win*E(t-1)+W*X(:,t-1));
    out1=Woutk1'*X(:,t);
    y((t-700),k)=out1;
end
MCcov=cov(E(700-k:1199-k),y(:,k));
MCcov=MCcov(1,2);
MCcov=MCcov*MCcov;
MCk(1,k)=MCcov/(var(E(700:1199))*var(y(:,k)));
end
MC=sum(MCk)
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
fileID = fopen('LE13.tex','a');
fprintf(fileID,'%f\n',ria);
fclose(fileID);
fileID = fopen('MC13.tex','a');
fprintf(fileID,'%f\n',MC);
fclose(fileID);
%}
%end