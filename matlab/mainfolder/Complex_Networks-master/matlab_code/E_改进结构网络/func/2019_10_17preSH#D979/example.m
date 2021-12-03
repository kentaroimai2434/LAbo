clc;
clear;
close all;
warning off;
addpath 'func\'

%�����_���l�b�g���[�N�쐬
%Num--���_���CPer--�ڑ��m���Cavg_length--�ӂ̕��ϒ�
Num          = 150;
K            = 2;
Per          = 0.01;
[matrix,x,y] = func_WSscalefree_network(Num,K,Per);

figure;
plot(x,y,'r.','Markersize',18);
hold on;
for i=1:Num 
    for j=i+1:Num
        if matrix(i,j)~=0
           plot([x(i),x(j)],[y(i),y(j)],'b--','linewidth',1);
           hold on;
        end
    end
end
hold off

%�Ή�����w�W���v�Z����
[Cc,Cc_avg]          = func_Cluster_Coeff(matrix);
disp(['�N���X�^�����O�W���F',num2str(Cc_avg)]);
[Dds,Dds_avg,M,P_Dds]= func_Degree_Distribution(matrix);
disp(['���ώ����F',num2str(Dds_avg)]);   
[Lens,Lens_avg]      = func_Path_Length(matrix);   
disp(['���όo�H���F',num2str(Lens_avg)]); 

figure;  
subplot(211);
bar([1:Num],Dds);  
xlabel('�m�[�h�ԍ�');
ylabel('�m�[�h����');
subplot(212);
bar([0:M],P_Dds,'r');
xlabel('�m�[�h����');
ylabel('�m�[�h�����̊m��');
 
 
