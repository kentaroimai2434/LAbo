%% 2019/10/23 �\���v���O�����V�K�@�m�C�Y�\���@���b�W�@��ʉ��t�s��
clear;
clc;
%% �f�[�^�쐬
for o=1:10
%�m�C�Y���菀��
fileID =fopen('makeyglass_added_uniform_[-0.05 0.05]1200plot600.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
Test=D;%Test���m�C�Y����̃}�b�L�[�O���X�f�[�^
Test=Test';
% �\��
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
%% ���񎎂��@�l�b�g���[�N�쐬�v���O������쐬(�{���Ȃ�Œ�)
%{
Z=zeros(150,150);%�����_���ɐڑ�����ꏊ
N = nnz(Z);
while N<=4499
rr=randi(150,1);%150�̐����烉���_���Ɉ��
rrr=randi(150,1);
    Z(rr,rrr)=1;
N = nnz(Z);
end
[row,col,v] = find(Z);
[m,n] = size(v);
V=normrnd(0,exp(-1.0),[m,n]);%-0.5,1.5�܂�0.1���݂�11�ω�
A=zeros(150);
for t=1:1:m
    A(row(t),col(t))=V(t);
end
%}
load('BAconect_new_noise.mat')%�ڑ��ǂݍ���
%%  �d�ݐ���
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z(by�_������j
% ���U�[�o�̏d�݂̐���
intWM=A;
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius(�ɓ�����̘_�����)%0.5����1.5�܂�0.1���݂�11�ω�
AA=eigs(W,1,'largestabs');
%%  ������ԂƊw�K�X�V������
X=zeros(resSize,AL);%�S���̓�����Ԃ̔��A�����ԁA�c��ԃx�N�g��
I=eye(resSize);%�P�ʍs��
M=zeros(resSize,SL);%�w�K�p�s��
T=zeros(SL,1);%���t�f�[�^�x�N�g�� ������ύX
preout=zeros(PL+1,outSize);%�\���x�N�g��
preoutbase=zeros(PL+1,outSize);%��ʉ��̗\��
Xbase=zeros(resSize,PL+1);%��ʉ��p�̔�
%% ������Ԋ����� �w�K����
%�����201����X�^�[�g�O�̏���0,X(:,a)=tanh(Win*E(a));%�ߓn��菜���Ċ�����201����X�^�[�g�Ȃ̂�200�Ԗڍ��
for t=a+1:1:a+SL%�w�K������
   X(:,t)=tanh(Win*Test(t)+W*X(:,t-1));%������Ԋ�����
   M(:,t-a)=[X(:,t)];%�ŏ�201�̓�����ԃx�N�g��
   T(t-a)=Test(t+1);%�o�ė~�����o�͂�202
end
%% �w�K����
ram=0.0000001;%���b�W��A��ram=0.00000001���炢���x�X�g
T=T';%���x�N�g��
Woutbase=T*pinv(M);%��ʉ��t�s��Ŋw�K
M=M';%���b�W��A�ɕK�v
T=T';%���b�W��A�͏c�x�N�g��
Wout=pinv(M'*M+ram*I)*M'*T;
%% �\��
preout(1)=Test(a+SL+1);
preoutbase(1)=Test(a+SL+1);
Xbase(:,1)=X(:,a+SL);
for t=a+SL+1:1:AL %����701����1200�܂ŗ\��
    X(:,t)=tanh(Win*preout(t-(a+SL))+W*X(:,t-1));%�t���[�����̂��߂�preout����͂�
    out=Wout'*X(:,t);%701�Ԗڏo��
    preout((t-(a+SL-1)),1)=out;
    Xbase(:,t-(a+SL-1))=tanh(Win*preoutbase(t-(a+SL))+W*Xbase(:,t-(a+SL)));
    out=Woutbase*Xbase(:,t-(a+SL-1));
    preoutbase((t-(a+SL-1)),1)=out;
end
preout=preout';
preoutbase=preoutbase';
%% �덷
rmse=sqrt(sum((Test(a+SL+1:1:a+SL+PL)-preout(2:1:PL+1)).^2)/500);
rmsebase=sqrt(sum((Test(a+SL+1:1:a+SL+PL)-preoutbase(2:1:PL+1)).^2)/500);
R(o,1)=rmse;
RR(o,1)=rmsebase;

%% �v���b�g
START=701;
END=1200;
%{
figure(1);
plot((START:END),Test(START:END),'-');
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time series (tau=%d)', tau));
%}
figure(o);
plot((START:END),Test(START:END),'-');
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time series (tau=%d)', tau));
hold on
plot((START:END),preout(2:1:501),'-');
legend('�ڕW�l','�\���l')
figure(o+100);
plot((START:END),Test(START:END),'-');
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time series (tau=%d)', tau));
hold on
plot((START:END),preoutbase(2:1:501),'-');
legend('�ڕW�l','�\���l')
end