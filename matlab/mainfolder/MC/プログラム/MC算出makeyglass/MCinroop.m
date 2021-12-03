%% matlab ������  ESN(mackyglassMC�Z�o)���B�搶�Ɍ���ꂽ�悤�ɒ��ŉ�
clear;
clc;
%% ���n��ǂݎ��
fileID =fopen('mackeytimeserise2.tex','r');
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
ram=0.000001;%���b�W��A��
Z=zeros(150,150);%�����_���ɐڑ�����ꏊ
for z=1:1:3000% 20%�����ڑ�
    rr=randi(150,1);%150�̐����烉���_���Ɉ��
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
%%  �d�ݐ���
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z(by�_������j
%% ���U�[�o�̏d�݂̐���
intWM= normrnd(0,exp(-1.5),[resSize,resSize]) ;%�S�������K���z[-1.5 -0.5]�܂ŕW���΍��ς���
intWM=intWM.*Z;
maxval = max(abs(eigs(intWM,1)));%��=e^(-1.2����-0.9)�܂Ń�0.02���₷
W = intWM/maxval;%�܂�-1.2+0.02=-1.18
W=W*0.98;% spectral radius(�ɓ�����̘_�����)
A=eigs(W,1,'largestabs');
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
%% �v���b�g
figure(1);
plot((1:1:1200),E(1:1:1200),'--');
set(gca,'xlim',[0, 1200]);
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((701:1:1200),preout(2:1:501),'-');

%%
%%MC1
for t=a+1:1:a+SL%201:700
  
   T(t-200)=E(t-1);%�o�ė~�����o�͂�1001
end
Woutk1=pinv(M)*T;
y1=zeros(PL,outSize);%MC�̂��߂�y1
for t=701:1:1200
    X(:,t)=tanh(Win*E(t-1)+W*X(:,t-1));
    out1=Woutk1'*X(:,t);
    y1((t-700),1)=out1;
end
MCcov=cov(E(699:1198),y1);
MCcov=MCcov(1,2);
MCcov=MCcov*MCcov;
MC1=MCcov/(var(E(700:1199))*var(y1));

%{
%%MC1
XX=zeros(resSize,AL);%���U�[�o�̏d�݂����g���Ċ�����
OX=zeros(resSize,AL);%k�O�̓��͂����Ċ�����
MM=zeros(resSize,SL);%�w�K�p�s��
OX(:,199)=tanh(Win*E(198));%k=1�Ȃ̂�199���g��
for t=200:1:699%�w�K������
    OX(:,t)=tanh(Win*E(t-1)+W*OX(:,t-1));%200�Ԗڂ͓��͓���Ċ�����k=1
    XX(:,t+1)=tanh(W*OX(:,t));%201�Ԗڂ����U�[�o�����ō��
end
for t=a+1:1:a+SL%201:700
   MM(:,t-200)=[XX(:,t)];
end
MM=MM';
Woutk1=pinv(MM'*MM+ram*I)*MM'*T;
y1=zeros(PL,outSize);%MC�̂��߂�y1
for t=701:1:1200
    OX(:,t-1)=tanh(Win*E(t-2)+W*OX(:,t-2));%�����X�e�b�v����
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk1'*XX(:,t);
    y1((t-700),1)=out1;
end
MC1=cov(E(699:1198),y1)/(var(E(700:1199))*var(y1));
MC1=MC1(1,2);
%%MC2
XX=zeros(resSize,AL);%���U�[�o�̏d�݂����g���Ċ�����
OX=zeros(resSize,AL);%k�O�̓��͂����Ċ�����
MM=zeros(resSize,SL);%�w�K�p�s��
OX(:,198)=tanh(Win*E(197));%k=2�Ȃ̂�198���g��
for t=200:1:699%�w�K������
    OX(:,t-1)=tanh(Win*E(t-2)+W*OX(:,t-2));%199�Ԗڂ͓��͓���Ċ�����k=2
    OX(:,t)=tanh(W*OX(:,t-1));
    XX(:,t+1)=tanh(W*OX(:,t));%201�Ԗڂ����U�[�o�����ō��
end
for t=a+1:1:a+SL%201:700
   MM(:,t-200)=[XX(:,t)];
end
MM=MM';
Woutk2=pinv(MM'*MM+ram*I)*MM'*T;
y2=zeros(PL,outSize);%MC�̂��߂�y2
for t=701:1:1200
    OX(:,t-2)=tanh(Win*E(t-3)+W*OX(:,t-3));%�����X�e�b�v����
    OX(:,t-1)=tanh(W*OX(:,t-2));
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk2'*XX(:,t);
    y2((t-700),1)=out1;
end
MC2=cov(E(698:1197),y2)/(var(E(700:1199))*var(y2));
MC2=MC2(1,2);
%%MC3
XX=zeros(resSize,AL);%���U�[�o�̏d�݂����g���Ċ�����
OX=zeros(resSize,AL);%k�O�̓��͂����Ċ�����
MM=zeros(resSize,SL);%�w�K�p�s��
OX(:,197)=tanh(Win*E(196));%k=2�Ȃ̂�198���g��
for t=200:1:699%�w�K������
    OX(:,t-2)=tanh(Win*E(t-3)+W*OX(:,t-3));%199�Ԗڂ͓��͓���Ċ�����k=2
    OX(:,t-1)=tanh(W*OX(:,t-2));
    OX(:,t)=tanh(W*OX(:,t-1));
    XX(:,t+1)=tanh(W*OX(:,t));%201�Ԗڂ����U�[�o�����ō��
end
for t=a+1:1:a+SL%201:700
   MM(:,t-200)=[XX(:,t)];
end
MM=MM';
Woutk3=pinv(MM'*MM+ram*I)*MM'*T;
y3=zeros(PL,outSize);%MC�̂��߂�y2
for t=701:1:1200
    OX(:,t-3)=tanh(Win*E(t-4)+W*OX(:,t-4));%�����X�e�b�v����
    OX(:,t-2)=tanh(W*OX(:,t-3));
    OX(:,t-1)=tanh(W*OX(:,t-2));
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk3'*XX(:,t);
    y3((t-700),1)=out1;
end
MC3=cov(E(697:1196),y3)/(var(E(700:1199))*var(y3));
MC3=MC3(1,2);
%%MC4
XX=zeros(resSize,AL);%���U�[�o�̏d�݂����g���Ċ�����
OX=zeros(resSize,AL);%k�O�̓��͂����Ċ�����
MM=zeros(resSize,SL);%�w�K�p�s��
OX(:,196)=tanh(Win*E(195));%k=2�Ȃ̂�198���g��
for t=200:1:699%�w�K������
    OX(:,t-3)=tanh(Win*E(t-4)+W*OX(:,t-4));%199�Ԗڂ͓��͓���Ċ�����k=2
    OX(:,t-2)=tanh(W*OX(:,t-3));
    OX(:,t-1)=tanh(W*OX(:,t-2));
    OX(:,t)=tanh(W*OX(:,t-1));
    XX(:,t+1)=tanh(W*OX(:,t));%201�Ԗڂ����U�[�o�����ō��
end
for t=a+1:1:a+SL%201:700
   MM(:,t-200)=[XX(:,t)];
end
MM=MM';
Woutk4=pinv(MM'*MM+ram*I)*MM'*T;
y4=zeros(PL,outSize);%MC�̂��߂�y2
for t=701:1:1200
    OX(:,t-4)=tanh(Win*E(t-5)+W*OX(:,t-5));%�����X�e�b�v����
    OX(:,t-3)=tanh(W*OX(:,t-4));
    OX(:,t-2)=tanh(W*OX(:,t-3));
    OX(:,t-1)=tanh(W*OX(:,t-2));
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk4'*XX(:,t);
    y4((t-700),1)=out1;
end
MC4=cov(E(696:1195),y4)/(var(E(700:1199))*var(y4));
MC4=MC4(1,2);
%%MC5
XX=zeros(resSize,AL);%���U�[�o�̏d�݂����g���Ċ�����
OX=zeros(resSize,AL);%k�O�̓��͂����Ċ�����
MM=zeros(resSize,SL);%�w�K�p�s��
OX(:,195)=tanh(Win*E(194));%k=2�Ȃ̂�198���g��
for t=200:1:699%�w�K������
    OX(:,t-4)=tanh(Win*E(t-5)+W*OX(:,t-5));%199�Ԗڂ͓��͓���Ċ�����k=2
    OX(:,t-3)=tanh(W*OX(:,t-4));
    OX(:,t-2)=tanh(W*OX(:,t-3));
    OX(:,t-1)=tanh(W*OX(:,t-2));
    OX(:,t)=tanh(W*OX(:,t-1));
    XX(:,t+1)=tanh(W*OX(:,t));%201�Ԗڂ����U�[�o�����ō��
end
for t=a+1:1:a+SL%201:700
   MM(:,t-200)=[XX(:,t)];
end
MM=MM';
Woutk5=pinv(MM'*MM+ram*I)*MM'*T;
y5=zeros(PL,outSize);%MC�̂��߂�y2
for t=701:1:1200
    OX(:,t-5)=tanh(Win*E(t-6)+W*OX(:,t-6));%�����X�e�b�v����
    OX(:,t-4)=tanh(W*OX(:,t-5));
    OX(:,t-3)=tanh(W*OX(:,t-4));
    OX(:,t-2)=tanh(W*OX(:,t-3));
    OX(:,t-1)=tanh(W*OX(:,t-2));
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk5'*XX(:,t);
    y5((t-700),1)=out1;
end
MC5=cov(E(695:1194),y5)/(var(E(700:1199))*var(y5));
MC5=MC5(1,2);
%}