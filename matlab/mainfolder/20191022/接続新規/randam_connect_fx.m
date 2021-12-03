%% ランダム接続　(グラフ理論ではない)
clear;
clc;
%% Zは接続場所のみ　4500接続
Z=zeros(150,150);%ランダムに接続する場所
N = nnz(Z);
while N<=4499
rr=randi(150,1);%150の数からランダムに一つ
rrr=randi(150,1);
    Z(rr,rrr)=1;
N = nnz(Z);
end
%% 読み込みor保存
%save('randam_origin_4500.mat','Z')%接続保存
load('randam_origin_4500.mat') %オリジナルの接続読み込み
%% 接続場所に正規分布で値付加
[row,col,v] = find(Z);
[m,n] = size(v);
V=normrnd(0,exp(-0.5),[m,n]);%-0.5,1.5まで0.1刻みで11変化
A=zeros(150);
for t=1:1:m
    A(row(t),col(t))=V(t);
end
%% 重み付き保存
save('randam_connect_4500.mat','A');%隣接行列保存
%%
