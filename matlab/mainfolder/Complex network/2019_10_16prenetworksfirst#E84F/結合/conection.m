clear;
clc;
Z=zeros(150,150);%�����_���ɐڑ�����ꏊ
for z=1:1:4500% 20%�����ڑ�
    rr=randi(150,1);%150�̐����烉���_���Ɉ��
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
%save('CONEX.mat','Z');