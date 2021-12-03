%% matlab 初期化  ESN(mackyglassMC算出)安達先生に言われたように中で回す
clear;
clc;
%% 時系列読み取り
fileID =fopen('mackeytimeserise2.tex','r');
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
ram=0.000001;%リッジ回帰λ
Z=zeros(150,150);%ランダムに接続する場所
for z=1:1:3000% 20%だけ接続
    rr=randi(150,1);%150の数からランダムに一つ
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
%%  重み生成
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]の一様分布(by論文から）
%% リザーバの重みの生成
intWM= normrnd(0,exp(-1.5),[resSize,resSize]) ;%全結合正規分布[-1.5 -0.5]まで標準偏差変える
intWM=intWM.*Z;
maxval = max(abs(eigs(intWM,1)));%σ=e^(-1.2から-0.9)までσ0.02増やす
W = intWM/maxval;%つまり-1.2+0.02=-1.18
W=W*0.98;% spectral radius(伊藤さんの論文より)
A=eigs(W,1,'largestabs');
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
%% プロット
figure(1);
plot((1:1:1200),E(1:1:1200),'--');
set(gca,'xlim',[0, 1200]);
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((701:1:1200),preout(2:1:501),'-');

%%
%%MC1
for t=a+1:1:a+SL%201:700
  
   T(t-200)=E(t-1);%出て欲しい出力は1001
end
Woutk1=pinv(M)*T;
y1=zeros(PL,outSize);%MCのためのy1
for t=701:1:1200
    X(:,t)=tanh(Win*E(t-1)+W*X(:,t-1));
    out1=Woutk1'*X(:,t);
    y1((t-700),1)=out1;
end
MCcov=cov(E(699:1198),y1);
MCcov=MCcov(1,2);
MCcov=MCcov*MCcov;
MC1=MCcov/(var(E(700:1199))*var(y1));

%{
%%MC1
XX=zeros(resSize,AL);%リザーバの重みだけ使って活性化
OX=zeros(resSize,AL);%k前の入力を入れて活性化
MM=zeros(resSize,SL);%学習用行列
OX(:,199)=tanh(Win*E(198));%k=1なので199を使う
for t=200:1:699%学習活性化
    OX(:,t)=tanh(Win*E(t-1)+W*OX(:,t-1));%200番目は入力入れて活性化k=1
    XX(:,t+1)=tanh(W*OX(:,t));%201番目をリザーバだけで作る
end
for t=a+1:1:a+SL%201:700
   MM(:,t-200)=[XX(:,t)];
end
MM=MM';
Woutk1=pinv(MM'*MM+ram*I)*MM'*T;
y1=zeros(PL,outSize);%MCのためのy1
for t=701:1:1200
    OX(:,t-1)=tanh(Win*E(t-2)+W*OX(:,t-2));%ワンステップ内部
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk1'*XX(:,t);
    y1((t-700),1)=out1;
end
MC1=cov(E(699:1198),y1)/(var(E(700:1199))*var(y1));
MC1=MC1(1,2);
%%MC2
XX=zeros(resSize,AL);%リザーバの重みだけ使って活性化
OX=zeros(resSize,AL);%k前の入力を入れて活性化
MM=zeros(resSize,SL);%学習用行列
OX(:,198)=tanh(Win*E(197));%k=2なので198を使う
for t=200:1:699%学習活性化
    OX(:,t-1)=tanh(Win*E(t-2)+W*OX(:,t-2));%199番目は入力入れて活性化k=2
    OX(:,t)=tanh(W*OX(:,t-1));
    XX(:,t+1)=tanh(W*OX(:,t));%201番目をリザーバだけで作る
end
for t=a+1:1:a+SL%201:700
   MM(:,t-200)=[XX(:,t)];
end
MM=MM';
Woutk2=pinv(MM'*MM+ram*I)*MM'*T;
y2=zeros(PL,outSize);%MCのためのy2
for t=701:1:1200
    OX(:,t-2)=tanh(Win*E(t-3)+W*OX(:,t-3));%ワンステップ内部
    OX(:,t-1)=tanh(W*OX(:,t-2));
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk2'*XX(:,t);
    y2((t-700),1)=out1;
end
MC2=cov(E(698:1197),y2)/(var(E(700:1199))*var(y2));
MC2=MC2(1,2);
%%MC3
XX=zeros(resSize,AL);%リザーバの重みだけ使って活性化
OX=zeros(resSize,AL);%k前の入力を入れて活性化
MM=zeros(resSize,SL);%学習用行列
OX(:,197)=tanh(Win*E(196));%k=2なので198を使う
for t=200:1:699%学習活性化
    OX(:,t-2)=tanh(Win*E(t-3)+W*OX(:,t-3));%199番目は入力入れて活性化k=2
    OX(:,t-1)=tanh(W*OX(:,t-2));
    OX(:,t)=tanh(W*OX(:,t-1));
    XX(:,t+1)=tanh(W*OX(:,t));%201番目をリザーバだけで作る
end
for t=a+1:1:a+SL%201:700
   MM(:,t-200)=[XX(:,t)];
end
MM=MM';
Woutk3=pinv(MM'*MM+ram*I)*MM'*T;
y3=zeros(PL,outSize);%MCのためのy2
for t=701:1:1200
    OX(:,t-3)=tanh(Win*E(t-4)+W*OX(:,t-4));%ワンステップ内部
    OX(:,t-2)=tanh(W*OX(:,t-3));
    OX(:,t-1)=tanh(W*OX(:,t-2));
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk3'*XX(:,t);
    y3((t-700),1)=out1;
end
MC3=cov(E(697:1196),y3)/(var(E(700:1199))*var(y3));
MC3=MC3(1,2);
%%MC4
XX=zeros(resSize,AL);%リザーバの重みだけ使って活性化
OX=zeros(resSize,AL);%k前の入力を入れて活性化
MM=zeros(resSize,SL);%学習用行列
OX(:,196)=tanh(Win*E(195));%k=2なので198を使う
for t=200:1:699%学習活性化
    OX(:,t-3)=tanh(Win*E(t-4)+W*OX(:,t-4));%199番目は入力入れて活性化k=2
    OX(:,t-2)=tanh(W*OX(:,t-3));
    OX(:,t-1)=tanh(W*OX(:,t-2));
    OX(:,t)=tanh(W*OX(:,t-1));
    XX(:,t+1)=tanh(W*OX(:,t));%201番目をリザーバだけで作る
end
for t=a+1:1:a+SL%201:700
   MM(:,t-200)=[XX(:,t)];
end
MM=MM';
Woutk4=pinv(MM'*MM+ram*I)*MM'*T;
y4=zeros(PL,outSize);%MCのためのy2
for t=701:1:1200
    OX(:,t-4)=tanh(Win*E(t-5)+W*OX(:,t-5));%ワンステップ内部
    OX(:,t-3)=tanh(W*OX(:,t-4));
    OX(:,t-2)=tanh(W*OX(:,t-3));
    OX(:,t-1)=tanh(W*OX(:,t-2));
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk4'*XX(:,t);
    y4((t-700),1)=out1;
end
MC4=cov(E(696:1195),y4)/(var(E(700:1199))*var(y4));
MC4=MC4(1,2);
%%MC5
XX=zeros(resSize,AL);%リザーバの重みだけ使って活性化
OX=zeros(resSize,AL);%k前の入力を入れて活性化
MM=zeros(resSize,SL);%学習用行列
OX(:,195)=tanh(Win*E(194));%k=2なので198を使う
for t=200:1:699%学習活性化
    OX(:,t-4)=tanh(Win*E(t-5)+W*OX(:,t-5));%199番目は入力入れて活性化k=2
    OX(:,t-3)=tanh(W*OX(:,t-4));
    OX(:,t-2)=tanh(W*OX(:,t-3));
    OX(:,t-1)=tanh(W*OX(:,t-2));
    OX(:,t)=tanh(W*OX(:,t-1));
    XX(:,t+1)=tanh(W*OX(:,t));%201番目をリザーバだけで作る
end
for t=a+1:1:a+SL%201:700
   MM(:,t-200)=[XX(:,t)];
end
MM=MM';
Woutk5=pinv(MM'*MM+ram*I)*MM'*T;
y5=zeros(PL,outSize);%MCのためのy2
for t=701:1:1200
    OX(:,t-5)=tanh(Win*E(t-6)+W*OX(:,t-6));%ワンステップ内部
    OX(:,t-4)=tanh(W*OX(:,t-5));
    OX(:,t-3)=tanh(W*OX(:,t-4));
    OX(:,t-2)=tanh(W*OX(:,t-3));
    OX(:,t-1)=tanh(W*OX(:,t-2));
    XX(:,t)=tanh(W*OX(:,t-1));
    out1=Woutk5'*XX(:,t);
    y5((t-700),1)=out1;
end
MC5=cov(E(695:1194),y5)/(var(E(700:1199))*var(y5));
MC5=MC5(1,2);
%}