clear;
clc;
intWM = sprand(150, 150, 0.07);
A=full(intWM);
AA=digraph(A);%有向グラフに変更
N = nnz(A);
C=clustering_coef_bd(A);
CC=mean(C)
lambda = charpath(A);
deg = degrees_dir(A);
[Lens,Lens_avg]=func_Path_Length(A);
plot(AA, 'LineWidth', 0.2, 'EdgeAlpha', 0.4, 'MarkerSize', 8, 'Layout', 'force');
[row,col,v] = find(A);
[m,n] = size(v);
V=normrnd(0,exp(-1.5),[m,n]);
B=zeros(150);
for t=1:1:m
    B(row(t),col(t))=V(t);
end
%normrnd(0,exp(-1.5),[150,150]);[m,n] = size(v)V=normrnd(0,exp(-1.5),[m,n]);