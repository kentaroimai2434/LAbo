%% matlab ������  ESN(mackyglassMC�Z�o)����
clear;
clc;
%% ���n��ǂݎ��
for nnn=1:1:11
for nn=1:1:10
%{
fileID =fopen('makeyglasstimedate12000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:12000);%1��11��21�E�E�E10���݂Ńf�[�^���
    %}
uniformdate=(rand(1,7000)*0.1)-0.05;%(a,b)�̈�l���z�@rand*(b-a)+a
E=uniformdate;
%% �l�b�g���[�N����
AL=7000;%�S�̒���
SL=1000;%�w�K����
PL=5000;%�\������
a=1000;%�ߓn�̒���
inSize=1; 
outSize=1;
resSize=150;%�j���[�����̐�
ram=0.000001;%���b�W��A��
%{
Z=zeros(150,150);%�����_���ɐڑ�����ꏊ
for z=1:1:3000% 20%�����ڑ�
    rr=randi(150,1);%150�̐����烉���_���Ɉ��
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
%}

load('randam_origin_4500.mat')
N = nnz(A);

%%  �d�ݐ���
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z(by�_������j
%% ���U�[�o�̏d�݂̐���
%intWM= normrnd(0,exp(-1.5),[resSize,resSize]) ;%�S�������K���z[-1.5 -0.5]�܂ŕW���΍��ς���
intWM=A;
maxval = max(abs(eigs(intWM,1)));%��=e^(-1.2����-0.9)�܂Ń�0.02���₷
W = intWM/maxval;%�܂�-1.2+0.02=-1.18
W=W*(0.4+0.1*nnn);% spectral radius(�ɓ�����̘_�����)
%W=intWM;
AA=eigs(W,1,'largestabs');
%%  ������ԂƊw�K�X�V������
X=zeros(resSize,AL);%�S���̓�����Ԃ̔��A�����ԁA�c��ԃx�N�g��
I=eye(resSize);%�P�ʍs��
M=zeros(resSize,SL);%�w�K�p�s��
T=zeros(SL,1);%���t�f�[�^�x�N�g��
preout=zeros(PL+1,outSize);%�\���x�N�g��
%% ������Ԋ�����
X(:,a)=tanh(Win*E(a-1));%�ߓn��菜���Ċ�����201����X�^�[�g�Ȃ̂�200�Ԗڍ��
for t=a:1:a+SL-1%�w�K������
   X(:,t+1)=tanh(Win*E(t)+W*X(:,t));%������Ԋ�����
end
%% ���A�v�m�t�w���v�Z
ria2=zeros(150,1);
for n=1:1:150
X(:,a)=tanh(Win*E(a-1));%�ߓn��菜���Ċ�����201����X�^�[�g�Ȃ̂�200�Ԗڍ��
x=X(:,a);%������ԃx�N�g���c150
p=zeros(150,1);%�[��150�x�N�g��
r=randi(150,1);%150�̒����烉���_���ɐ������
p(r,1)=10^-12;%�����_���ɑI�񂾔ԍ���10^-12����
%p(1,1)=10^-12;%�I�񂾔ԍ���10^-12���������(1,1)
xp=x+p;%������ԃx�N�g���ɐۓ���^����
ganma=norm(x-xp);%�m������l�̌v�Z
ganma0=ganma;%�����̃m������0
lamda=zeros(500,1);
for t=a:1:a+SL-1%�w�K�������ԈႦ�Ă�
   x=X(:,t+1);%���̓�����ԃx�N�g��
    xp=tanh(Win*E(t)+W*xp);%�ۓ���^����ꂽ������ԃx�N�g��
    ganma=norm(x-xp);%���̃m������l�̌v�Z
    xp=x+(ganma0/ganma)*(xp-x);%���K��
    lamda(t-(a-1),1)=log(ganma/ganma0);
end
ria1=mean(lamda);
ria2(n,1)=ria1;
end
ria=mean(ria2);
%% �w�K����
for t=a+1:1:a+SL%201:700
   M(:,t-a)=[X(:,t)];%�ŏ�201�̓�����ԃx�N�g��
   T(t-a)=E(t);%�o�ė~�����o�͂�1001
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1)=E(a+SL);
%% �\��
%{
for t=a+SL+1:1:a+SL+PL
    X(:,t)=tanh(Win*preout(t-(a+SL))+W*X(:,t-1));%�t���[�����̂��߂�preout����͂�
    out=Wout'*X(:,t);%701�Ԗڏo��
    preout((t-(a+SL-1)),1)=out;
end
%D=D';
E=E';
preout=preout';
%ria=log(ganma/ganma0)
%}
%% �덷
rmse=sqrt(sum((E(a+SL+1:1:a+SL+PL)-preout(2:1:PL+1)).^2)/5000);

%%MC�v�Z
y=zeros(PL,100);%MC�̂��߂�y1
MCk=zeros(1,100);
for k=1:1:100
for t=a+1:1:a+SL%201:700
  
   T(t-a)=E(t-1-k);%�o�ė~�����o�͂�1001
end
Woutk1=pinv(M)*T;
%y=zeros(PL,100);%MC�̂��߂�y1
for t=a+SL+1:1:a+SL+PL
    X(:,t)=tanh(Win*E(t-1)+W*X(:,t-1));
    out1=Woutk1'*X(:,t);
    y((t-(a+SL)),k)=out1;
end
MCcov=cov(E(a+SL-k:a+SL+PL-1-k),y(:,k));
MCcov=MCcov(1,2);
MCcov=MCcov*MCcov;
MCk(1,k)=MCcov/(var(E(a+SL:a+SL+PL-1))*var(y(:,k)));
end
MC=sum(MCk);
%% �v���b�g

%{
figure(nn);
plot((1:1:1200),E(1:1:1200),'--');
set(gca,'xlim',[0, 1200]);
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((701:1:1200),preout(2:1:501),'-');

%}
fileID = fopen('LE(-0.05,0.05)test.tex','a');
fprintf(fileID,'%f\n',ria);
fclose(fileID);
fileID = fopen('MC(-0.05,0.05)test.tex','a');
fprintf(fileID,'%f\n',MC);
fclose(fileID);

end
end