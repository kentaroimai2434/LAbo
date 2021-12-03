clc;
clear;
close all;
warning off;
addpath 'func\'
rng(1);

%�����������
%Num--���������Per--���Ӹ��ʣ�avg_length--�ߵ�ƽ������
Num          = 100;
Per          = 0.036;
avg_length   = 100;
[matrix,x,y] = func_Random_network(Num,Per,avg_length);

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

%������Ӧ��ָ��
[Cc,Cc_avg]          = func_Cluster_Coeff(matrix);
disp(['����ϵ��Ϊ��',num2str(Cc_avg)]);
[Dds,Dds_avg,M,P_Dds]= func_Degree_Distribution(matrix);
disp(['ƽ����Ϊ��',num2str(Dds_avg)]);   
[Lens,Lens_avg]      = func_Path_Length(matrix);   
disp(['ƽ��·������Ϊ��',num2str(Lens_avg)]); 



figure;  
subplot(211);
bar([1:Num],Dds);  
xlabel('�ڵ���');
ylabel('�ڵ�Ķ�');
subplot(212);
bar([0:M],P_Dds,'r');
xlabel('�ڵ�Ķ�');
ylabel('�ڵ�ȵĸ���');
 
 
 









