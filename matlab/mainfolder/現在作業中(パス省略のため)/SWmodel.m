clear;
clc;
Z=func_NW_network(150,10,0.02);
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
load('WSorigin 2.mat')
[row,col,v] = find(Z);
[m,n] = size(v);
V=normrnd(0,exp(-1.3),[m,n]);

A=zeros(150);
for t=1:1:m
    A(row(t),col(t))=V(t);
end
%%
%save('WSorigin.mat','Z')
save('WSconect.mat','A');%隣接行列保存
%save('CCCC.mat','CC');
%save('LLLL.mat','Lens_avg')
%save('deg3.mat','deg')

%histogram(Dds);