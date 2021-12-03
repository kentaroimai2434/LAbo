%% matlab 初期化  ESN(mackyglassMC算出)
%{
メモ:論文から入力は1つ
出力に入力は入れない
N=150
Win[-0.1,0.1]
1200
200:500:500
学習でリザーバーだけで回しその結果を学習
%}
clear;
clc;
%% 時系列読み取り
%for o=1:1:10 %波形を出す回数
fileID =fopen('makeyglasstimedate12000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:12000);%1→11→21・・・10刻みでデータ取る
u=E;%1200個データ
%% ネットワーク初期
AL=1200;%全体長さ
SL=500;%学習長さ
PL=500;%予測長さ
a=200;%過渡の長さ
inSize=1; 
outSize=1;
resSize=150;%ニューロンの数
%p=0.02; % sparity
ram=0.000001;%リッジ回帰λ
Z=zeros(150,150);%ランダムに接続する場所150?150=22500
for z=1:1:4500% 20%だけ接続=4500
    rr=randi(150,1);%150の数からランダムに一つ
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
N = nnz(Z);
%%  重み生成
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]の一様分布(by論文から）
%% リザーバの重みの生成

intWM= normrnd(0,exp(-1.5),[resSize,resSize]) ;%全結合正規分布[-1.5 -0.5]まで標準偏差変える
intWM=intWM.*Z;
maxval = max(abs(eigs(intWM,1)));%σ=e^(-1.2から-0.9)までσ0.02増やす
W = intWM/maxval;%つまり-1.2+0.02=-1.18
W=W*0.98;% spectral radius(伊藤さんの論文より)
%W=intWM;
A=eigs(W,1,'largestabs');
%{
intWM = sprand(resSize, resSize, p);
intWM = spfun(@Point1tominus1,intWM);%2%繋いだ重みを[-0.1,0.1]にしている
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius(伊藤さんの論文より)
A=eigs(W,1,'largestabs');
%}
%%  内部状態と学習更新式準備
X=zeros(resSize,AL);%全部の内部状態の箱、横時間、縦状態ベクトル
I=eye(resSize);%単位行列
M=zeros(resSize,SL);%学習用行列
T=zeros(SL,1);%教師データベクトル
preout=zeros(PL+1,outSize);%予測ベクトル
XX=zeros(resSize,AL);%リザーバの重みだけ使って活性化
OX=zeros(resSize,AL);%k前の入力を入れて活性化
MM=zeros(resSize,SL);%学習用行列
%% 内部状態活性化

X(:,200)=tanh(Win*E(199));%過渡取り除いて活性化201からスタートなので200番目作る
OX(:,199)=tanh(Win*E(198));%k=1なので199を使う
%{
for t=2:1:199%過渡
    X(:,t+1)=tanh(Win*E(t)+W*X(:,t));
end
%}
x=X(:,200);%内部状態ベクトル縦150
p=zeros(150,1);%ゼロ150ベクトル
r=randi(150,1);%150の中からランダムに数字一つ
p(r,1)=10^-12;%ランダムに選んだ番号に10^-12を代入
xp=x+p;%内部状態ベクトルに摂動を与える
ganma=norm(xp-x);%ノルムγlの計算
ganma0=ganma;%初期のノルムγ0
for t=200:1:699%学習活性化
   X(:,t+1)=tanh(Win*E(t)+W*X(:,t));%内部状態活性化
   x=X(:,t+1);%次の内部状態ベクトル
    xp=tanh(Win*E(t)+W*xp);%摂動を与えられな内部状態ベクトル
    ganma=norm(xp-x);%次のノルムγlの計算
    xp=x+(ganma0/ganma)*(xp-x);%正規化
    OX(:,t)=tanh(Win*E(t-1)+W*OX(:,t-1));%200番目は入力入れて活性化k=1
    XX(:,t+1)=tanh(W*OX(:,t));%201番目をリザーバだけで作る
end
%% 学習期間
for t=a+1:1:a+SL%201:700
   M(:,t-200)=[X(:,t)];%最初101の内部状態ベクトル
   T(t-200)=E(t);%出て欲しい出力は1001
   MM(:,t-200)=[XX(:,t)];
end
M=M';
MM=MM';
Wout=pinv(M'*M+ram*I)*M'*T;
Woutk1=pinv(MM'*MM+ram*I)*MM'*T;
%Wout=pinv(M)*T;
preout(1)=E(700);
y1=zeros(PL,outSize);%MCのためのy1
%% 予測
for t=701:1:1200
    X(:,t)=tanh(Win*preout(t-700)+W*X(:,t-1));%フリーランのためにpreoutを入力に
    out=Wout'*X(:,t);%701番目出力
    preout((t-699),1)=out;
    OX(:,t-1)=tanh(Win*E(t-2)+W*OX(:,t-2));%ワンステップ内部
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk1'*XX(:,t);
    y1((t-700),1)=out1;
end
D=D';
E=E';
preout=preout';
ria=log(ganma/ganma0)
MC1=cov(E(699:1198),y1)/(var(E(700:1199))*var(y1));
MC1=MC1(1,2);
%% 誤差
%err = immse(D(10001:1:30000),preout(51:1:20050));
rmse=sqrt(sum((E(701:1:1200)-preout(2:1:501)).^2)/500)
%R(o,1)=rmse;
%% プロット

figure(1);
plot((1:1:1200),E(1:1:1200),'--');
set(gca,'xlim',[0, 1200]);
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((701:1:1200),preout(2:1:501),'-');
%{
legend('cos(x)','cos(2x)')
%figure(o+10);
plot((1001:1:2000),E(1001:1:2000),'--');
set(gca,'xlim',[1000, 2000]);
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((1001:1:2000),preout(51:1:1050),'-');
%legend('cos(x)','cos(2x)')
%}
%end
%%