clear;
clc;
Z=zeros(150,150);%ランダムに接続する場所
for z=1:1:1500% 5%だけ接続
    rr=randi(150,1);%150の数からランダムに一つ
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
ZZ=digraph(Z);%有向グラフに変更
%{
    N = nnz(Z);
C=clustering_coef_bd(Z);
CC=mean(C)
[Lens,Lens_avg]=func_Path_Length(Z);
lambda = charpath(Z);
deg = degrees_dir(Z);
%}
%%
load('randamorigin(sta).mat')
[row,col,v] = find(Z);
[m,n] = size(v);
V=normrnd(0,exp(-0.5),[m,n]);

A=zeros(150);
for t=1:1:m
    A(row(t),col(t))=V(t);
end
%%
figure(1)
plot(ZZ, 'LineWidth', 0.2, 'EdgeAlpha', 0.4, 'MarkerSize', 8, 'Layout', 'force');
figure(2)
%histogram(deg)
%%
save('randamorigin(sta).mat','Z')
save('randamconect(sta).mat','A');%隣接行列保存
%save('C.mat','CC');
%save('L.mat','Lens_avg')
%save('deg.mat','deg')
