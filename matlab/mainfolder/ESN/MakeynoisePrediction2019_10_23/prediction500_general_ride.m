%% 2019/10/23 予測プログラム新規　一般予測　リッジ　一般化逆行列
clear;
clc;
%% データ作成
for o=1:1:10 %波形を出す回数
%通常マッキーグラス
fileID =fopen('makeyglasstimedate12000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:12000);%1→11→21・・・10刻みでデータ取る
E=E';
% 予測
%% ネットワーク初期
%データ設定
AL=1200;%全体長さ
SL=500;%学習長さ
PL=500;%予測長さ
a=200;%過渡の長さ
%リザーバ　サイズ設定　ニューロンの数
inSize=1; %入力層
resSize=150;%中間層
outSize=1;%出力層
%% 今回試し　ネットワーク作成プログラム上作成(本来なら固定)
Z=zeros(150,150);%ランダムに接続する場所
for z=1:1:4500 % 20%だけ接続
    rr=randi(150,1);%150の数からランダムに一つ
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
N = nnz(Z);
[row,col,v] = find(Z);
[m,n] = size(v);
V=normrnd(0,exp(-1.0),[m,n]);%-0.5,1.5まで0.1刻みで11変化
A=zeros(150);
for t=1:1:m
    A(row(t),col(t))=V(t);
end
%%  重み生成
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]の一様分布(by論文から）
% リザーバの重みの生成
intWM=A;
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius(伊藤さんの論文より)%0.5から1.5まで0.1刻みで11変化
AA=eigs(W,1,'largestabs');
%%  内部状態と学習更新式準備
X=zeros(resSize,AL);%全部の内部状態の箱、横時間、縦状態ベクトル
I=eye(resSize);%単位行列
M=zeros(resSize,SL);%学習用行列
T=zeros(SL,1);%教師データベクトル ここを変更
preout=zeros(PL+1,outSize);%予測ベクトル
preoutbase=zeros(PL+1,outSize);%一般化の予測
Xbase=zeros(resSize,PL+1);%一般化用の箱
%% 内部状態活性化 学習準備
%今回は201からスタート前の情報は0,X(:,a)=tanh(Win*E(a));%過渡取り除いて活性化201からスタートなので200番目作る
for t=a+1:1:a+SL%学習活性化
   X(:,t)=tanh(Win*E(t)+W*X(:,t-1));%内部状態活性化
   M(:,t-a)=[X(:,t)];%最初201の内部状態ベクトル
   T(t-a)=E(t+1);%出て欲しい出力は202
end
%% 学習期間
ram=0.0000001;%リッジ回帰λram=0.00000001くらいがベスト
T=T';%横ベクトル
Woutbase=T*pinv(M);%一般化逆行列で学習
M=M';%リッジ回帰に必要
T=T';%リッジ回帰は縦ベクトル
Wout=pinv(M'*M+ram*I)*M'*T;
%% 予測
preout(1)=E(a+SL+1);
preoutbase(1)=E(a+SL+1);
Xbase(:,1)=X(:,a+SL);
for t=a+SL+1:1:AL %入力701から1200まで予測
    X(:,t)=tanh(Win*preout(t-(a+SL))+W*X(:,t-1));%フリーランのためにpreoutを入力に
    out=Wout'*X(:,t);%701番目出力
    preout((t-(a+SL-1)),1)=out;
    Xbase(:,t-(a+SL-1))=tanh(Win*preoutbase(t-(a+SL))+W*Xbase(:,t-(a+SL)));
    out=Woutbase*Xbase(:,t-(a+SL-1));
    preoutbase((t-(a+SL-1)),1)=out;
end
preout=preout';
preoutbase=preoutbase';
%% 誤差
rmse=sqrt(sum((E(a+SL+1:1:a+SL+PL)-preout(2:1:PL+1)).^2)/500);
rmsebase=sqrt(sum((E(a+SL+1:1:a+SL+PL)-preoutbase(2:1:PL+1)).^2)/500);
R(o,1)=rmse;
RR(o,1)=rmsebase;
end

%% プロット
START=700;
END=1200;
figure(1);
plot((START:END),E(START:END),'-');
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
figure(2);
plot((1:END),E(1:END),'-');
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((701:1:1200),preout(2:1:501),'-');
legend('目標値','予測値')
figure(3);
plot((START:END),E(START:END),'-');
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((701:1:1200),preoutbase(2:1:501),'-');
legend('目標値','予測値')