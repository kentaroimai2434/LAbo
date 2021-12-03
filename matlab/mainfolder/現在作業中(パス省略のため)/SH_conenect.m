clear;
clc;
Z=func_WSscalefree_network(150,15,0.02);
ZZ=digraph(Z);%有向グラフに変更
%{
N = nnz(Z);
C=clustering_coef_bd(Z);
CC=mean(C)
[Lens,Lens_avg]=func_Path_Length(Z);
lambda = charpath(Z);
deg = degrees_dir(Z);
plot(ZZ, 'LineWidth', 0.2, 'EdgeAlpha', 0.4, 'MarkerSize', 8, 'Layout', 'force');
[Dds,Dds_avg,M,P_Dds]=func_Degree_Distribution(Z);
%}
%%
load('SHorigin_new_noise.mat')
[row,col,v] = find(Z);
[m,n] = size(v);
V=normrnd(0,exp(-1.5),[m,n]);

A=zeros(150);
for t=1:1:m
    A(row(t),col(t))=V(t);
end
%%
%save('SHorigin_new_noise.mat','Z')
save('SHconect_new_noise.mat','A');%隣接行列保存
%save('CC.mat','CC');
%save('LL.mat','Lens_avg')
%save('deg1.mat','deg')

%histogram(Dds);