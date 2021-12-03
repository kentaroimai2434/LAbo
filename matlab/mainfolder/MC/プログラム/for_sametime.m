%% �v���O���~���O MC �ʏ�}�b�L�[�O���X ���b�W�@��ʉ��@minimum �����ɉ񂷗p
clear;
clc;
%% �f�[�^�쐬
fileID =fopen('makeyglasstimedate30000plot.tex','r'); %��t=0.1
formatspac='%f';
D=fscanf(fileID,formatspac);                          
fclose(fileID);
tau=17;
%E=D;               %�m�C�Y�̎�
E=D(1:10:30000);                                      %1��11��21�E�E�E10���݂Ńf�[�^���
E_time=E';                                            %���n��f�[�^�s�x�N�g��
%�f�[�^�ݒ�
AL=3000;                                              %�S�̒���
SL=1500;                                               %�w�K����Study
PL=1300;                                               %�\������
a=200;                                                %�ߓn�̒���
%% �l�b�g���[�N����
%���U�[�o �T�C�Y�ݒ�@�j���[�����̐�
inSize=1;                                             %���̓j���[������K
resSize=150;                                          %���U�[�o�j���[������N
outSize=1;                                            %�o�̓j���[������L

%�d�ݏ����쐬
Win=zeros(resSize,inSize);      %���͏d�ݍs�� N�~K����
W=zeros(resSize,resSize);    %���ԑw�d�ݍs�� N�~N���� �e���f���ɒ�������
Wout=zeros(outSize,resSize);    %�o�͑w�d�ݍs�� L�~N���� �w�K����
%% ���[�v�|�C���g
%for nv=1:1:300          %
%for nr=1:1:1000         %61�Ԃ܂�v�͈ꏏ
%%  ������ԂƊw�K�X�V������

X=zeros(resSize,AL);            %�S���̓�����Ԃ̔��A�����ԁA�c��ԃx�N�g��
I=eye(resSize);                 %�P�ʍs��
M=zeros(resSize,SL);            %�w�K�p�s���œ]�n����
T=zeros(SL,outSize);            %���t�f�[�^�s��N�~L�����@�\���p
preout=zeros(PL,outSize);       %�\���s��
preoutbase=zeros(PL,outSize);   %��ʉ��̗\��
Xbase=zeros(resSize,PL+1);      %��ʉ��p�̔�


%�e�p�����[�^
r=1.01;             %���U�[�o�̌Œ肳�ꂽ��Βlr
%b=0.5;                     %���U�[�o�̌Œ肳�ꂽ�o�b�N�R�l�N�N�V������Βlb
%v=0.01*nv;            %���͂̏d��v
%% �d�ݍ쐬
%{
%���͏d�ݍ쐬
Win(:,:)=v;
for t=1:resSize
    i=randi(2);
    if i==1
        Win(t,1)=Win(t,1);
    else
        Win(t,1)=-Win(t,1);
    end
end
%}

Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]�̈�l���z(by�_������j
%Win=normrnd(0,exp(-1.5),[1,150]);
%Win=Win';
%% ESN DLR,DLRB,SCR�́@�d��

%���ꂼ��̃p�^�[����I��

%{
N=150;
Z=zeros(N,N);%�����_���ɐڑ�����ꏊ
NN = nnz(Z);
while NN<=N*N*0.5
rr=randi(N,1);%150�̐����烉���_���Ɉ��
rrr=randi(N,1);
    Z(rr,rrr)=1;
NN = nnz(Z);
end
[row,col,v] = find(Z);
[m,n] = size(v);
aa=0.4+0.1*nv;
VV=(rand([m,n])*(aa+aa))-aa;%��l���z
A=zeros(N);
for t=1:1:m
    A(row(t),col(t))=VV(t);
end
intWM=A;
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.4+W*0.1*nr;%������0.3
%}

%{
for i=1:N-1 %DLR
    W(i+1,i)=r;
end
%}

%{
for i=1:N-1 %DLRB
    W(i+1,i)=r;
    W(i,i+1)=b;
end
%}

%
for i=1:resSize-1 %SCR  (���K������r�{�̕������[�v���Ȃ��čςށj
    W(i+1,i)=r;
end
    W(1,resSize)=r;
%}

%% ������Ԋ����� �w�K����

%�����201����X�^�[�g�O�̏���0,
%X(:,a)=tanh(Win*E(a));%�ߓn��菜���Ċ�����201����X�^�[�g�Ȃ̂�200�Ԗڍ��ꍇ������

for t=a+1:1:a+SL%�w�K������
   X(:,t)=tanh(Win*E(t)+W*X(:,t-1));            %������Ԋ�����                          
end
M=X(:,a+1:a+SL);                                %�ŏ�201�̓�����ԃx�N�g��
M=M';                                           %�t�s��p�ɓ]�u
T(1:SL,:)=E(a+2:a+1+SL,:);                      %1step�悪���t�@�o�ė~�����o�͂�202
%% �w�K���ԁ@�\���p
Wout=pinv(M)*T;                                 %��ʉ��t�s��Ŋw�K
ramda=0.0000001;                                %���b�W��A��ram=0.00000001���炢���x�X�g
Woutride=pinv(M'*M+ramda*I)*M'*T;               %���b�W��A
%% �\��
%1�X�e�b�v�\��

for t=a+SL+1:AL                                      %�o��
  X(:,t)=tanh(Win*E(t)+W*X(:,t-1));
  preoutbase(t-a-SL,1)=Wout'*X(:,t);
end
rmse=sqrt(sum((E(a+SL+2:AL)-preoutbase(1:PL-1)).^2)/499);
%%�덷



%% ���A�v�m�t�w���v�Z
riaSize=500;                                    %���A�v�m�t�w����l=500
Xria_true=zeros(resSize,riaSize);               %���A�v�m�t�w���p�̃��U�[�o�[��������
Xria_putu=zeros(resSize,riaSize);               %���A�v�m�t�w���p�̃��U�[�o�[�ۓ���^����ꂽ
lamda=zeros(1,riaSize);                         %�Ɏ��[�p�s�x�N�g��
ria=zeros(1,resSize);                           %�j���[�������ŕ��ώ��
Xria_true(:,:)=X(:,2501:3000);             %��������ԍs�����

for n=1:1:150    %�j���[�������J��Ԃ�
%���A�v�m�t�w�����ʑ���
%�w�K���Ԃ̃��A�v�m�t�w���l����
%(�t���[�����\���Ȃ�\�����Ԃ̃��A�v�m�t�w���l���Ă��ǂ�����)
%Xria_true(:,1)=tanh(Win*E(a+1));                %�ߓn��菜���Ċ�����201����X�^�[�g���ꂪ1�Ԗ�
%r=randi(150,1);                                 %150�̒����烉���_���ɐ������%��l���z�Ŏ擾


x=Xria_true(:,1);                                %������������ԃx�N�g���c150
p=zeros(150,1);                                  %�[��150�x�N�g���ۓ��p
p(n,1)=10^-8;                                   %n�Ԗڂ̃j���[������10^-12�����@�@

xp=x+p;                                          %������ԃx�N�g���ɐۓ���^���� �ۓ���^����ꂽ�x�N�g��
Xria_putu(:,1)=xp;                               %�ۓ��x�N�g�������[
ganma=norm(x-xp);                                %�m������l�̌v�Z
ganma0=ganma;                                    %�����̃m������0=10^-12

for t=1:riaSize-1      %���A�v�m�t�w���̈ړ�
    x=Xria_true(:,t+1);                         %�������x�N�g��
    xp=tanh(Win*E(2500+(t+1))+W*xp);            %�ۓ���^����ꂽ������ԃx�N�g�����K���������̂Ōv�Z�Ȃ̂�xp
    ganma=norm(x-xp);                           %���̃m������l�̌v�Z
    Xria_putu(:,t+1)=xp;
    xp=x+(ganma0/ganma)*(xp-x);                 %���K��
    lamda(1,t)=log(ganma/ganma0);               %���R�ΐ�
end
lya_mean=mean(lamda);                            %500�̕���
lya_num(1,n)=lya_mean;                              %N�̃j���[�����ɐۓ������Ď���150
end
lya=mean(lya_num);                              %�P�T�O�̕���

%% MC�v�Z 
MC_step=100;                                    %�Ȃ�X�e�b�v�܂Ōv�Z���邩
ybase=zeros(PL,MC_step);                        %MC�̂��߂�y1��ʉ�
yride=zeros(PL,MC_step);                        %MC��y���b�W500�~100
Tmc=zeros(SL,outSize);                          %MC�̋��t�M��
MCk_ride=zeros(1,MC_step);                      %�V���[�g�^�[���p�s�x�N�g��
MCkbase=zeros(1,MC_step);                       %��ʉ��p

for k=1:1:MC_step           %MC��k�X�e�b�v
%{
for t=a+1:1:a+SL            %�w�K�̎��n��201:700
    Tmc(t-a)=E(t-k);
end
 %}
Tmc=E(a+1-k:a+SL-k);                            %k=1�̎�201�Ԗڂ���͂�����200�Ԗڂ�\���ł��邩���
%�w�K
WoutMcbase=pinv(M)*Tmc;                         %��ʉ��t�s��Ŋw�K
WoutMc_ride=pinv(M'*M+ramda*I)*M'*Tmc;          %MC���b�W��A

for t=a+SL+1:1:AL %701����1200 �t���[�����\���ł͂Ȃ�
    %X(:,t)=tanh(Win*E(t)+W*X(:,t-1));           %�\���̊�����
    
    outMcbase=WoutMcbase'*X(:,t);                %k�X�e�b�v�O�o�͈��
    outMc_ride=WoutMc_ride'*X(:,t);             %k�X�e�b�v�O�o�̓��b�W
    
    ybase((t-(a+SL)),k)=outMcbase;              %500�̗\�����x�N�g����k�X�e�b�v�O���x�N�g��
    yride((t-(a+SL)),k)=outMc_ride;
end
%���q�����̋����U�v�Z�@Mccov�͔�
MCcov=cov(E(a+SL+1-k:AL-k),ybase(:,k));         %%u(t-k)������ 
MCcov=MCcov(1,2);                               %�����U��2�~2��1,2�ɗv�f������
MCcov=MCcov*MCcov;                              %�����U��2��

MCkbase(1,k)=MCcov/(var(E(a+SL+1:AL))*var(ybase(:,k))); %MC�v�Z

MCcov=cov(E(a+SL+1-k:AL-k),yride(:,k));            
MCcov=MCcov(1,2);                               %�����U��2�~2��1,2�ɗv�f������
MCcov=MCcov*MCcov;                              %�����U��2��

MCk_ride(1,k)=MCcov/(var(E(a+SL+1:AL))*var(yride(:,k))); %MC�v�Z
end

MCbase=sum(MCkbase);                            %�t�s��MC
MC_ride=sum(MCk_ride);                          %���b�WMC
%% �f�[�^�ۑ�
fileID = fopen('LEmakey_1200_SCR_v[0.01:0.01:10.0]_in[0.00001]_test_ex1.tex','a');
fprintf(fileID,'%f\n',lya);
fclose(fileID);
fileID = fopen('MCmakey_1200_ridge_SCR_v[0.01:0.01:10.0]_in[0.00001]_test_ex1.tex','a');
fprintf(fileID,'%f\n',MC_ride);
fclose(fileID);
fileID = fopen('MCmakey_1200_regression_SCR_v[0.01:0.01:10.0]_in[0.00001]_test_ex1.tex','a');
fprintf(fileID,'%f\n',MCbase);
fclose(fileID);
fileID = fopen('MCmakey_1200_RMSE_SCR_v[0.01:0.01:10.0]_in[-0.00001]_test_ex1.tex','a');
fprintf(fileID,'%f\n',rmse);
fclose(fileID);
%%
%end
%end 