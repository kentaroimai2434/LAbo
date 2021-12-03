%% ノイズ付加マッキーグラス作成
clear;
clc;
%% データ作成
fileID =fopen('makeyglasstimedate12000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:12000);%1→11→21・・・10刻みでデータ取る
E=E';

T=zeros(1,1200);%ランダムに接続する場所
N = nnz(T);
while N<=149
rr=randi(1200,1);%1200の数からランダムに一つ
T(1,rr)=1;
N = nnz(T);
end
[row,col,v] = find(T);
[m,n] = size(v);
V=(rand(1,1200)*0.5)-0.25;
A=zeros(1,1200);
for t=1:1:n
    A(row(t),col(t))=V(t);
end
NN = nnz(A);
TT=E+A;

%uniformdate=(rand(1,1200)*0.5)-0.25;%(a,b)の一様分布　rand*(b-a)+a
%TT=E+uniformdate; %testデータマッキーグラスに一様分布のノイズ負荷
%% プロット
START=700;
END=1200;
figure(1);
plot((START:END),E(START:END),'-');%
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time series (tau=%d)', tau));
figure(2)
plot((START:END),TT(START:END),'-');
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time series with added uniform [-0.5 0.5] (tau=%d)', tau));
%% ファイル保存
fileID = fopen('makeyglass_added_uniform_[-0.25 0.25]1200plot150.tex','w');
fprintf(fileID,'%f\n',TT);
fclose(fileID);
%%
