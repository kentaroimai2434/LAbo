%% matlab ������  ESN(�����X�e�b�v�\���H�t���[�����H)
clear;
clc;
%% �l�b�g���[�N�T�C�Y
inSize=1; 
outSize=1;
resSize=20;
%% �f�[�^����
for n=1:300;
 d(n)=1/2*sin(n/4);
end
d=d';
%% �d�ݐ���
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z
Wback=(rand(resSize,outSize)*0.2)-0.1;
%% ���U�[�o�̏d�݂̐���(����)
Wres=(rand(resSize)*0.2)-0.1;
A=eigs(Wres,1,'largestreal');
s=0;
while A>=1
    Wres=(rand(resSize)*0.2)-0.1;
    A=eigs(Wres,1,'largestreal');%�ő�ŗL�l���Z�o
    s=s+1
    if s>50
        break
    end
end
%% ������ԂƊw�K�X�V������
X=zeros(300,20);
M=zeros(200,20);
T=zeros(200,1);
%% ������ԍX�V
X(1,:)=(tanh(Win*d(1)))';
for t=1:1:300
    X(t+1,:)=(tanh(Wres*(X(t,:))'+Wback*d(t)))';
end
%% �w�K
for t=1:1:200
       M(t,:)=X(100+t,:);
       T(t)=d(100+t)';
   end
Wout=pinv(M)*T;
%% �\��
preout=zeros(50,1);
for t=301:1:350
    X(t,:)=(tanh(Wres*(X(t-1,:))'+Wback*d(t-1)))';
    out=X(t,:)*Wout;
    preout(t-300)=out;
    d=[d ;out]; 
end
preout=preout';
d=d';
rmse=sqrt(sum((d(301:1:350)-preout(1:1:50)).^2)/50);
%% �v���b�g
figure(1);
plot(301:1:350,preout,'r-')
hold on
plot(301:1:350,d(301:1:350),'b--')
rmse=sqrt(sum((d(301:1:350)-preout(1:1:50)).^2)/50);
%%