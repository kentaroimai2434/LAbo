%% matlab 初期化  ESN(mackyglassMC算出)
clear;
clc;
%% 時系列読み取り
%for n=1:1:20
fileID =fopen('makeyglasstimedate12000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:12000);%1→11→21・・・10刻みでデータ取る
%% ネットワーク初期
AL=1200;%全体長さ
SL=500;%学習長さ
PL=500;%予測長さ
a=200;%過渡の長さ
inSize=1; 
outSize=1;
resSize=150;%ニューロンの数
ram=0.0000001;%リッジ回帰λram=0.00000001くらいがベスト


Z=zeros(150,150);%ランダムに接続する場所
for z=1:1:3000% 20%だけ接続
    rr=randi(150,1);%150の数からランダムに一つ
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
%}
A=Z;
%load('scallmat.mat')
N = nnz(Z)
%%  重み生成
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]の一様分布(by論文から）
%% リザーバの重みの生成
intWM= normrnd(0,exp(-1.5),[resSize,resSize]) ;%全結合正規分布[-1.5 -0.5]まで標準偏差変える
intWM=intWM.*A;
maxval = max(abs(eigs(intWM,1)));%σ=e^(-1.2から-0.9)までσ0.02増やす
W = intWM/maxval;%つまり-1.2+0.02=-1.18
W=W*0.98;% spectral radius(伊藤さんの論文より)
%W=intWM;
AA=eigs(W,1,'largestabs');
%%  内部状態と学習更新式準備
X=zeros(resSize,AL);%全部の内部状態の箱、横時間、縦状態ベクトル
I=eye(resSize);%単位行列
M=zeros(resSize,SL);%学習用行列
T=zeros(SL,1);%教師データベクトル
preout=zeros(PL+1,outSize);%予測ベクトル
%% 内部状態活性化
X(:,200)=tanh(Win*E(199));%過渡取り除いて活性化201からスタートなので200番目作る
x=X(:,200);%内部状態ベクトル縦150
p=zeros(150,1);%ゼロ150ベクトル
r=randi(150,1);%150の中からランダムに数字一つ
p(1,1)=10^-12;%ランダムに選んだ番号に10^-12を代入
xp=x+p;%内部状態ベクトルに摂動を与える
ganma=norm(xp-x);%ノルムγlの計算
ganma0=ganma;%初期のノルムγ0
for t=200:1:699%学習活性化
   X(:,t+1)=tanh(Win*E(t)+W*X(:,t));%内部状態活性化
   x=X(:,t+1);%次の内部状態ベクトル
    xp=tanh(Win*E(t)+W*xp);%摂動を与えられな内部状態ベクトル
    ganma=norm(xp-x);%次のノルムγlの計算
    xp=x+(ganma0/ganma)*(xp-x);%正規化
end
%% 学習期間
for t=a+1:1:a+SL%201:700
   M(:,t-200)=[X(:,t)];%最初101の内部状態ベクトル
   T(t-200)=E(t);%出て欲しい出力は1001
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1)=E(700);
%% 予測
for t=701:1:1200
    X(:,t)=tanh(Win*preout(t-700)+W*X(:,t-1));%フリーランのためにpreoutを入力に
    out=Wout'*X(:,t);%701番目出力
    preout((t-699),1)=out;
end
D=D';
E=E';
preout=preout';
ria=log(ganma/ganma0)
%% 誤差
rmse=sqrt(sum((E(701:1:1200)-preout(2:1:501)).^2)/500)

%%MC計算
y=zeros(PL,100);%MCのためのy1
MCk=zeros(1,100);
for k=1:1:100
for t=a+1:1:a+SL%201:700
  
   T(t-200)=E(t-k);%出て欲しい出力は1001
end
Woutk1=pinv(M)*T;
y=zeros(PL,100);%MCのためのy1
for t=701:1:1200
    X(:,t)=tanh(Win*E(t-1)+W*X(:,t-1));
    out1=Woutk1'*X(:,t);
    y((t-700),k)=out1;
end
MCcov=cov(E(700-k:1199-k),y(:,k));
MCcov=MCcov(1,2);
MCcov=MCcov*MCcov;
MCk(1,k)=MCcov/(var(E(700:1199))*var(y(:,k)));
end
MC=sum(MCk)
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
fileID = fopen('LE13.tex','a');
fprintf(fileID,'%f\n',ria);
fclose(fileID);
fileID = fopen('MC13.tex','a');
fprintf(fileID,'%f\n',MC);
fclose(fileID);
%}
%end