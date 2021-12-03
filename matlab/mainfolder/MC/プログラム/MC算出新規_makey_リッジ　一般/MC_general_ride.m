%% �v���O���~���O MC �ʏ�}�b�L�[�O���X ���b�W�@��ʉ�
clear;
clc;
%% �f�[�^�쐬
fileID =fopen('makeyglasstimedate12000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:12000);%1��11��21�E�E�E10���݂Ńf�[�^���
E=E';
%% �l�b�g���[�N����
%�f�[�^�ݒ�
AL=1200;%�S�̒���
SL=500;%�w�K����
PL=500;%�\������
a=200;%�ߓn�̒���
%���U�[�o�@�T�C�Y�ݒ�@�j���[�����̐�
inSize=1; %���͑w
resSize=150;%���ԑw
outSize=1;%�o�͑w
%% �l�b�g���[�N�ǂݏo�� ���K���z�̒l,�ڑ��ŕύX�@���[�v�ŕς���1
load('randam_connect_4500.mat')
%% ���[�v�@�f�[�^�擾
for nnn=1:1:11 %nnn�X�y�N�g�����a�̕ύX
for nn=1:1:10  %nn ��̃f�[�^�ɑ΂���10�f�[�^�擾
%%  ������ԂƊw�K�X�V������
X=zeros(resSize,AL);%�S���̓�����Ԃ̔��A�����ԁA�c��ԃx�N�g��
I=eye(resSize);%�P�ʍs��
M=zeros(resSize,SL);%�w�K�p�s��
T=zeros(SL,1);%���t�f�[�^�x�N�g�� ������ύX
preout=zeros(PL+1,outSize);%�\���x�N�g��
preoutbase=zeros(PL+1,outSize);%��ʉ��̗\��
Xbase=zeros(resSize,PL+1);%��ʉ��p�̔�
%%  �d�ݐ���
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z(by�_������j
% ���U�[�o�̏d�݂̐���
intWM=A;
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*(0.4+0.1*nnn);% spectral radius 0.5����1.5�܂�0.1���݂�11�ω� ���[�v�ŕς���2
AA=eigs(W,1,'largestabs'); 
%% ������Ԋ����� �w�K����
%�����201����X�^�[�g�O�̏���0,X(:,a)=tanh(Win*E(a));%�ߓn��菜���Ċ�����201����X�^�[�g�Ȃ̂�200�Ԗڍ��
for t=a+1:1:a+SL%�w�K������
   X(:,t)=tanh(Win*E(t)+W*X(:,t-1));%������Ԋ�����
   M(:,t-a)=[X(:,t)];%�ŏ�201�̓�����ԃx�N�g��
   T(t-a)=E(t+1);%�o�ė~�����o�͂�202
end
%% ���A�v�m�t�w���v�Z
riaSize=500;%���A�v�m�t�w����l=500
Xria=zeros(resSize,riaSize);%���A�v�m�t�w���p�̃��U�[�o�[������
xria=zeros(resSize,riaSize);%���A�v�m�t�w���p�̃��U�[�o�[�ۓ���^����ꂽ
lamda=zeros(1,riaSize);
ria2=zeros(1,150);
for n=1:1:150    
%���A�v�m�t�w�����ʑ���
Xria(:,1)=tanh(Win*E(a+1));%�ߓn��菜���Ċ�����201����X�^�[�g���ꂪ1�Ԗ�
x=Xria(:,1);%������������ԓ�����ԃx�N�g���c150
p=zeros(150,1);%�[��150�x�N�g���ۓ��p
r=randi(150,1);%150�̒����烉���_���ɐ������%��l���z�Ŏ擾
p(r,1)=10^-12;%�����_���ɑI�񂾔ԍ���10^-12�����@�@%p(1,1)=10^-12;%�I�񂾔ԍ���10^-12���������(1,1)
xp=x+p;%������ԃx�N�g���ɐۓ���^���� �ۓ���^����ꂽ�x�N�g��
xria(:,1)=xp;
ganma=norm(x-xp);%�m������l�̌v�Z
ganma0=ganma;%�����̃m������0
for t=1:riaSize-1%�w�K������500��J��Ԃ�
    Xria(:,t+1)=tanh(Win*E(a+(t+1))+W*Xria(:,t));%t+1��t�o�[�W����
    x=Xria(:,t+1);%�������x�N�g��
    xp=tanh(Win*E(a+(t+1))+W*xp);%�ۓ���^����ꂽ������ԃx�N�g��
    ganma=norm(x-xp);%���̃m������l�̌v�Z
    xp=x+(ganma0/ganma)*(xp-x);%���K��
    xria(:,t+1)=xp;
    lamda(1,t)=log(ganma/ganma0);%���R�ΐ�
end
ria1=mean(lamda);%500�̕���
ria2(1,n)=ria1;%N�̃j���[�����Ƀ����_���ɐۓ������Ď���150
end
ria=mean(ria2);
%% �w�K����
ram=0.0000001;%���b�W��A��ram=0.00000001���炢���x�X�g
T=T';%���x�N�g��
Woutbase=T*pinv(M);%��ʉ��t�s��Ŋw�K
M=M';%���b�W��A�ɕK�v
T=T';%���b�W��A�͏c�x�N�g��
Wout=pinv(M'*M+ram*I)*M'*T;
%% MC�v�Z ���͗\���ƈꏏ�����ʁX�ɂ��������킩��₷��
ybase=zeros(PL,100);%MC�̂��߂�y1��ʉ�
y=zeros(PL,100);%MC��y���b�W
Tmc=zeros(SL,1);%MC�̋��t�M��
MCk=zeros(1,100);%�V���[�g�^�[��
MCkbase=zeros(1,100);%��ʉ��p
for k=1:1:100 %MC��k�X�e�b�v
for t=a+1:1:a+SL%201:700
    Tmc(t-a)=E(t-k);%201�Ԗڂ���͂�����200�Ԗڂ�\���ł��邩
end
M=M';
Tmc=Tmc';%���x�N�g��
WoutMcbase=Tmc*pinv(M);%��ʉ��t�s��Ŋw�K
M=M';%���b�W��A�ɕK�v
Tmc=Tmc';%���b�W��A�͏c�x�N�g��
WoutMc=pinv(M'*M+ram*I)*M'*Tmc;%MC���b�W��A
for t=a+SL+1:1:AL %701����1200 �t���[�����\���ł͂Ȃ�
    X(:,t)=tanh(Win*E(t)+W*X(:,t-1));%�\���ƈꏏ�̎��͂���Ȃ�����
    outMc=WoutMc'*X(:,t);
    y((t-(a+SL)),k)=outMc;
    outMcbase=WoutMcbase*X(:,t);
    ybase((t-(a+SL)),k)=outMcbase;
end
MCcov=cov(E(a+SL+1-k:AL-k),y(:,k));%���q�����̋����U�v�Z�@Mccov�͔�
MCcov=MCcov(1,2);%�����U��2�~2��1,2�ɗv�f������
MCcov=MCcov*MCcov;%�����U��2��
MCk(1,k)=MCcov/(var(E(a+SL+1:AL))*var(y(:,k)));

MCcov=cov(E(a+SL+1-k:AL-k),ybase(:,k));%���q�����̋����U�v�Z
MCcov=MCcov(1,2);%�����U��2�~2��1,2�ɗv�f������
MCcov=MCcov*MCcov;%�����U��2��
MCkbase(1,k)=MCcov/(var(E(a+SL+1:AL))*var(ybase(:,k)));
end
MC=sum(MCk);
MCbase=sum(MCkbase);
%% �f�[�^�ۑ�
fileID = fopen('LErandam_makey_general.tex','a');
fprintf(fileID,'%f\n',ria);
fclose(fileID);
fileID = fopen('MCrandam_makey_general_ridge.tex','a');
fprintf(fileID,'%f\n',MC);
fclose(fileID);
fileID = fopen('MCrandam_makey_general_regression.tex','a');
fprintf(fileID,'%f\n',MCbase);
fclose(fileID);
%%
end
end