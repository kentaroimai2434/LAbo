%% �v���O���~���O �ʏ�}�b�L�[�O���X ���A�v�m�t�w������
clear;
clc;
%% �f�[�^�쐬
%{
fileID =fopen('makeyglasstimedate30000plot.tex','r'); %��t=0.1
formatspac='%f';
D=fscanf(fileID,formatspac);                          
fclose(fileID);
tau=17;
%E=D;               %�m�C�Y�̎�
E=D(1:10:30000);                                      %1��11��21�E�E�E10���݂Ńf�[�^���
E_time=E';                                            %���n��f�[�^�s�x�N�g��
%}
%�f�[�^�ݒ�
AL=3000;                                              %�S�̒���
SL=1500;                                               %�w�K����Study
PL=1300;                                               %�\������
a=200;                                                %�ߓn�̒���

aa = 3.9;%�o����;
t=3000;
x=zeros(1,t);%�v�f�����s�x�N�g��
x(1) = 0.1;%�����l
%% �X�V
for n=1:t-1
    x(n+1) = aa * x(n) * (1-x(n));
end
E=x;
%% �l�b�g���[�N����
%���U�[�o �T�C�Y�ݒ�@�j���[�����̐�
inSize=1;                                             %���̓j���[������K
resSize=1;                                          %���U�[�o�j���[������N
outSize=1;                                            %�o�̓j���[������L

%�d�ݏ����쐬
Win=zeros(resSize,inSize);      %���͏d�ݍs�� N�~K����
W=zeros(resSize,resSize);    %���ԑw�d�ݍs�� N�~N���� �e���f���ɒ�������
Wout=zeros(outSize,resSize);    %�o�͑w�d�ݍs�� L�~N���� �w�K����
Win=1;
W=1;
%%  ������ԂƊw�K�X�V������

X=zeros(resSize,AL);            %�S���̓�����Ԃ̔��A�����ԁA�c��ԃx�N�g��
I=eye(resSize);                 %�P�ʍs��
M=zeros(resSize,SL);            %�w�K�p�s���œ]�n����
T=zeros(SL,outSize);            %���t�f�[�^�s��N�~L�����@�\���p
preout=zeros(PL,outSize);       %�\���s��
preoutbase=zeros(PL,outSize);   %��ʉ��̗\��
Xbase=zeros(resSize,PL+1);      %��ʉ��p�̔�



%% ������Ԋ����� �w�K����

%�����201����X�^�[�g�O�̏���0,
%X(:,a)=tanh(Win*E(a));%�ߓn��菜���Ċ�����201����X�^�[�g�Ȃ̂�200�Ԗڍ��ꍇ������

for t=a+1:1:AL%�w�K������
   X(:,t)=tanh(E(1,t));            %������Ԋ�����                          
end
%% ���A�v�m�t�w���v�Z
riaSize=500;                                    %���A�v�m�t�w����l=500
Xria_true=zeros(resSize,riaSize);               %���A�v�m�t�w���p�̃��U�[�o�[��������
Xria_putu=zeros(resSize,riaSize);               %���A�v�m�t�w���p�̃��U�[�o�[�ۓ���^����ꂽ
lamda=zeros(1,riaSize);                         %�Ɏ��[�p�s�x�N�g��
ria=zeros(1,resSize);                           %�j���[�������ŕ��ώ��
Xria_true(:,:)=X(:,2501:3000);             %��������ԍs�����

%���A�v�m�t�w�����ʑ���
%�w�K���Ԃ̃��A�v�m�t�w���l����
%(�t���[�����\���Ȃ�\�����Ԃ̃��A�v�m�t�w���l���Ă��ǂ�����)
%Xria_true(:,1)=tanh(Win*E(a+1));                %�ߓn��菜���Ċ�����201����X�^�[�g���ꂪ1�Ԗ�
%r=randi(150,1);                                 %150�̒����烉���_���ɐ������%��l���z�Ŏ擾


x=Xria_true(:,1);                                %������������ԃx�N�g���c150                                %�[��150�x�N�g���ۓ��p
p=10^-8;                                   %n�Ԗڂ̃j���[������10^-12�����@�@

xp=x+p;                                          %������ԃx�N�g���ɐۓ���^���� �ۓ���^����ꂽ�x�N�g��
Xria_putu(:,1)=xp;                               %�ۓ��x�N�g�������[
ganma=norm(x-xp);                                %�m������l�̌v�Z
ganma0=ganma;                                    %�����̃m������0=10^-12

for t=1:riaSize-1      %���A�v�m�t�w���̈ړ�
    x=Xria_true(:,t+1);                         %�������x�N�g��
    xp=tanh(Win*E(2500+(t+1))+xp);            %�ۓ���^����ꂽ������ԃx�N�g�����K���������̂Ōv�Z�Ȃ̂�xp
    ganma=norm(x-xp);                           %���̃m������l�̌v�Z
    Xria_putu(:,t+1)=xp;
    xp=x+(ganma0/ganma)*(xp-x);                 %���K��
    lamda(1,t)=log(ganma/ganma0);               %���R�ΐ�
end
lya_mean=mean(lamda);                            %500�̕���
                         %N�̃j���[�����ɐۓ������Ď���150

