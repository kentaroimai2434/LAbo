%% matlab 初期化  ESN(mackyglass予測フリーラン伊藤さんと比較)
clear;
clc;
%% 時系列読み取り
for o=1:1:10 %波形を出す回数
fileID =fopen('makeyglasstimedate20000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:20000);
%% ネットワーク初期
AL=2000;%全体長さ
SL=900;%学習長さ
PL=1000;%予測長さ
a=100;%過渡の長さ
inSize=50; 
outSize=1;
resSize=1000;%ニューロンの数
p=0.02; % sparity
ram=0.0001;%リッジ回帰λ
%%  重み生成
Win=(rand(resSize,inSize)*2)-1;%[-1,1]の一様分布(大きめで取るby伊藤さん）
%% リザーバの重みの生成
intWM = sprand(resSize, resSize, p);
intWM = spfun(@Point1tominus1,intWM);%2%繋いだ重みを[-0.1,0.1]にしている
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius(伊藤さんの論文より)
A=eigs(W,1,'largestabs');
%%  内部状態と学習更新式準備
X=zeros(resSize,AL);
I=eye(resSize+50);%入力を出力に入れるので+50
M=zeros(resSize+50,SL);
T=zeros(SL,1);
preout=zeros(PL+50,outSize);
%% 内部状態活性化
U=repelem(E(1:1:50),1);
X(:,50)=tanh(Win*U);
for t=50:1:99%過渡
    U=repelem(E(t-49:1:t),1);%x(t+1)はu(t)で活性化
    X(:,t+1)=tanh(Win*U+W*X(:,t));
end
for t=100:1:999%学習活性化
  U=repelem(E(t-49:1:t),1);
   X(:,t+1)=tanh(Win*U+W*X(:,t));
end
%% 学習期間
for t=a+1:1:a+SL%101:1000
   U=repelem(E(t-50:1:t-1),1);%最初951から1000までの正しい値
   M(:,t-100)=[X(:,t);U];%最初1001の内部状態ベクトル
   T(t-100)=E(t);%出て欲しい出力は1001
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1:1:50)=(E(951:1:1000));
%% 予測
for t=1001:1:2000
    U=repelem(preout(t-1000:1:t-951),1);
    X(:,t)=tanh(Win*U+W*X(:,t-1));
    out=Wout'*[X(:,t);U];
    preout((t-950),1)=out;
end
D=D';
preout=preout';
%% 誤差
%err = immse(D(10001:1:30000),preout(51:1:20050));
%rmse=sqrt(sum((D(10001:10:20000)-preout(51:1:2051)).^2)/1000);
%R(o,1)=rmse;
%% プロット
figure(o);
xlabel('t');
xlim([10001, 30000])
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
plot((10001:1:20000),D(10001:1:20000),'--');
hold on
plot((10001:10:20000),preout(51:1:1050),'-');
end
%%