%% �����_���ڑ��@(�O���t���_�ł͂Ȃ�)
clear;
clc;
%% Z�͐ڑ��ꏊ�̂݁@4500�ڑ�
Z=zeros(150,150);%�����_���ɐڑ�����ꏊ
N = nnz(Z);
while N<=4499
rr=randi(150,1);%150�̐����烉���_���Ɉ��
rrr=randi(150,1);
    Z(rr,rrr)=1;
N = nnz(Z);
end
%% �ǂݍ���or�ۑ�
%save('randam_origin_4500.mat','Z')%�ڑ��ۑ�
load('randam_origin_4500.mat') %�I���W�i���̐ڑ��ǂݍ���
%% �ڑ��ꏊ�ɐ��K���z�Œl�t��
[row,col,v] = find(Z);
[m,n] = size(v);
V=normrnd(0,exp(-0.5),[m,n]);%-0.5,1.5�܂�0.1���݂�11�ω�
A=zeros(150);
for t=1:1:m
    A(row(t),col(t))=V(t);
end
%% �d�ݕt���ۑ�
save('randam_connect_4500.mat','A');%�אڍs��ۑ�
%%
