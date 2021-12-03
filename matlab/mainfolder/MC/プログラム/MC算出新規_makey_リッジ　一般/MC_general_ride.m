%% プログラミング MC 通常マッキーグラス リッジ　一般化
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
%% ネットワーク読み出し 正規分布の値,接続で変更　ループで変える1
load('randam_connect_4500.mat')
%% ループ　データ取得
for nnn=1:1:11 %nnnスペクトル半径の変更
for nn=1:1:10  %nn 一つのデータに対して10データ取得
%%  内部状態と学習更新式準備
X=zeros(resSize,AL);%全部の内部状態の箱、横時間、縦状態ベクトル
I=eye(resSize);%単位行列
M=zeros(resSize,SL);%学習用行列
T=zeros(SL,1);%教師データベクトル ここを変更
preout=zeros(PL+1,outSize);%予測ベクトル
preoutbase=zeros(PL+1,outSize);%一般化の予測
Xbase=zeros(resSize,PL+1);%一般化用の箱
%%  重み生成
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]の一様分布(by論文から）
% リザーバの重みの生成
intWM=A;
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*(0.4+0.1*nnn);% spectral radius 0.5から1.5まで0.1刻みで11変化 ループで変える2
AA=eigs(W,1,'largestabs'); 
%% 内部状態活性化 学習準備
%今回は201からスタート前の情報は0,X(:,a)=tanh(Win*E(a));%過渡取り除いて活性化201からスタートなので200番目作る
for t=a+1:1:a+SL%学習活性化
   X(:,t)=tanh(Win*E(t)+W*X(:,t-1));%内部状態活性化
   M(:,t-a)=[X(:,t)];%最初201の内部状態ベクトル
   T(t-a)=E(t+1);%出て欲しい出力は202
end
%% リアプノフ指数計算
riaSize=500;%リアプノフ指数のl=500
Xria=zeros(resSize,riaSize);%リアプノフ指数用のリザーバー正しい
xria=zeros(resSize,riaSize);%リアプノフ指数用のリザーバー摂動を与えられた
lamda=zeros(1,riaSize);
ria2=zeros(1,150);
for n=1:1:150    
%リアプノフ指数共通操作
Xria(:,1)=tanh(Win*E(a+1));%過渡取り除いて活性化201からスタートこれが1番目
x=Xria(:,1);%正しい内部状態内部状態ベクトル縦150
p=zeros(150,1);%ゼロ150ベクトル摂動用
r=randi(150,1);%150の中からランダムに数字一つ%一様分布で取得
p(r,1)=10^-12;%ランダムに選んだ番号に10^-12を代入　　%p(1,1)=10^-12;%選んだ番号に10^-12を代入今回は(1,1)
xp=x+p;%内部状態ベクトルに摂動を与える 摂動を与えられたベクトル
xria(:,1)=xp;
ganma=norm(x-xp);%ノルムγlの計算
ganma0=ganma;%初期のノルムγ0
for t=1:riaSize-1%学習活性化500回繰り返す
    Xria(:,t+1)=tanh(Win*E(a+(t+1))+W*Xria(:,t));%t+1とtバージョン
    x=Xria(:,t+1);%正しいベクトル
    xp=tanh(Win*E(a+(t+1))+W*xp);%摂動を与えられた内部状態ベクトル
    ganma=norm(x-xp);%次のノルムγlの計算
    xp=x+(ganma0/ganma)*(xp-x);%正規化
    xria(:,t+1)=xp;
    lamda(1,t)=log(ganma/ganma0);%自然対数
end
ria1=mean(lamda);%500の平均
ria2(1,n)=ria1;%N個のニューロンにランダムに摂動を入れて試す150
end
ria=mean(ria2);
%% 学習期間
ram=0.0000001;%リッジ回帰λram=0.00000001くらいがベスト
T=T';%横ベクトル
Woutbase=T*pinv(M);%一般化逆行列で学習
M=M';%リッジ回帰に必要
T=T';%リッジ回帰は縦ベクトル
Wout=pinv(M'*M+ram*I)*M'*T;
%% MC計算 今は予測と一緒だが別々にした方がわかりやすい
ybase=zeros(PL,100);%MCのためのy1一般化
y=zeros(PL,100);%MCのyリッジ
Tmc=zeros(SL,1);%MCの教師信号
MCk=zeros(1,100);%ショートターム
MCkbase=zeros(1,100);%一般化用
for k=1:1:100 %MCのkステップ
for t=a+1:1:a+SL%201:700
    Tmc(t-a)=E(t-k);%201番目を入力した時200番目を予測できるか
end
M=M';
Tmc=Tmc';%横ベクトル
WoutMcbase=Tmc*pinv(M);%一般化逆行列で学習
M=M';%リッジ回帰に必要
Tmc=Tmc';%リッジ回帰は縦ベクトル
WoutMc=pinv(M'*M+ram*I)*M'*Tmc;%MCリッジ回帰
for t=a+SL+1:1:AL %701から1200 フリーラン予測ではない
    X(:,t)=tanh(Win*E(t)+W*X(:,t-1));%予測と一緒の時はいらないかも
    outMc=WoutMc'*X(:,t);
    y((t-(a+SL)),k)=outMc;
    outMcbase=WoutMcbase*X(:,t);
    ybase((t-(a+SL)),k)=outMcbase;
end
MCcov=cov(E(a+SL+1-k:AL-k),y(:,k));%分子部分の共分散計算　Mccovは箱
MCcov=MCcov(1,2);%共分散は2×2の1,2に要素がある
MCcov=MCcov*MCcov;%共分散の2乗
MCk(1,k)=MCcov/(var(E(a+SL+1:AL))*var(y(:,k)));

MCcov=cov(E(a+SL+1-k:AL-k),ybase(:,k));%分子部分の共分散計算
MCcov=MCcov(1,2);%共分散は2×2の1,2に要素がある
MCcov=MCcov*MCcov;%共分散の2乗
MCkbase(1,k)=MCcov/(var(E(a+SL+1:AL))*var(ybase(:,k)));
end
MC=sum(MCk);
MCbase=sum(MCkbase);
%% データ保存
fileID = fopen('LErandam_makey_general.tex','a');
fprintf(fileID,'%f\n',ria);
fclose(fileID);
fileID = fopen('MCrandam_makey_general_ridge.tex','a');
fprintf(fileID,'%f\n',MC);
fclose(fileID);
fileID = fopen('MCrandam_makey_general_regression.tex','a');
fprintf(fileID,'%f\n',MCbase);
fclose(fileID);
%%
end
end