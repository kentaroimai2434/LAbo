clc;
clear;
close all;
warning off;
addpath 'func\'

%ランダムネットワーク作成
%Num--頂点数，Per--接続確率，avg_length--辺の平均長
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

%対応する指標を計算する
[Cc,Cc_avg]          = func_Cluster_Coeff(matrix);
disp(['クラスタリング係数：',num2str(Cc_avg)]);
[Dds,Dds_avg,M,P_Dds]= func_Degree_Distribution(matrix);
disp(['平均次数：',num2str(Dds_avg)]);   
[Lens,Lens_avg]      = func_Path_Length(matrix);   
disp(['平均経路長：',num2str(Lens_avg)]); 

figure;  
subplot(211);
bar([1:Num],Dds);  
xlabel('ノード番号');
ylabel('ノード割合');
subplot(212);
bar([0:M],P_Dds,'r');
xlabel('ノード割合');
ylabel('ノード次数の確率');
 
 
