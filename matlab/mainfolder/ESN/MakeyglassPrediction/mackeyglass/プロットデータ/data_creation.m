%% �m�C�Y�t���}�b�L�[�O���X�쐬
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

T=zeros(1,1200);%�����_���ɐڑ�����ꏊ
N = nnz(T);
while N<=149
rr=randi(1200,1);%1200�̐����烉���_���Ɉ��
T(1,rr)=1;
N = nnz(T);
end
[row,col,v] = find(T);
[m,n] = size(v);
V=(rand(1,1200)*0.5)-0.25;
A=zeros(1,1200);
for t=1:1:n
    A(row(t),col(t))=V(t);
end
NN = nnz(A);
TT=E+A;

%uniformdate=(rand(1,1200)*0.5)-0.25;%(a,b)�̈�l���z�@rand*(b-a)+a
%TT=E+uniformdate; %test�f�[�^�}�b�L�[�O���X�Ɉ�l���z�̃m�C�Y����
%% �v���b�g
START=700;
END=1200;
figure(1);
plot((START:END),E(START:END),'-');%
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time series (tau=%d)', tau));
figure(2)
plot((START:END),TT(START:END),'-');
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time series with added uniform [-0.5 0.5] (tau=%d)', tau));
%% �t�@�C���ۑ�
fileID = fopen('makeyglass_added_uniform_[-0.25 0.25]1200plot150.tex','w');
fprintf(fileID,'%f\n',TT);
fclose(fileID);
%%
