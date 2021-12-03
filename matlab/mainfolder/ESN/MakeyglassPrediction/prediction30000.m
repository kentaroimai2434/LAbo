%% matlab 初期化  ESN(mackyglass予測フリーラン伊藤さんと比較)
clear;
clc;
%% 時系列読み取り
for o=1:1:10 %波形を出す回数
fileID =fopen('makeyglasstimedate30000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
%% ネットワーク初期
AL=30000;%全体長さ
SL=9000;%学習長さ
PL=20000;%予測長さ
a=1000;%過渡の長さ
inSize=50; 
outSize=1;
resSize=1000;%ニューロンの数
p=0.02; % sparity
ram=0.1;%リッジ回帰λ
%%  重み生成
Win=(rand(resSize,inSize)*2)-1;%[-1,1]の一様分布(大きめで取るby伊藤さん）
%% リザーバの重みの生成
intWM = sprand(resSize, resSize, p);
intWM = spfun(@Point1tominus1,intWM);%1%繋いだ重みを[-0.1,0.1]にしている
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius
A=eigs(W,1,'largestabs');
%%  内部状態と学習更新式準備
X=zeros(resSize,AL);
I=eye(resSize+50);%入力を出力に入れるので+50
M=zeros(resSize+50,SL);
T=zeros(SL,1);
preout=zeros(PL+50,outSize);
%% 内部状態活性化
U=repelem(D(1:1:50),1);
X(:,51)=tanh(Win*U);
for t=51:1:999%過渡
    U=repelem(D(t-49:1:t),1);%x(t+1)はu(t)で活性化
    X(:,t+1)=tanh(Win*U+W*X(:,t));
end
for t=1000:1:9999%学習活性化
   U=repelem(D(t-49:1:t),1);
   X(:,t+1)=tanh(Win*U+W*X(:,t));
end
%% 学習期間
for t=a+1:1:a+SL%1001:10000
   U=repelem(D(t-50:1:t-1),1);%最初951から1000までの正しい値
   M(:,t-1000)=[X(:,t);U];%最初1001の内部状態ベクトル
   T(t-1000)=D(t);%出て欲しい出力は1001
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1:1:50)=(D(9951:1:10000));
%% 予測
for t=10001:1:30000
    U=repelem(preout(t-10000:1:t-9951),1);
    X(:,t)=tanh(Win*U+W*X(:,t-1));
    out=Wout'*[X(:,t);U];
    preout((t-9950),1)=out;
end
D=D';
preout=preout';
%% 誤差
err = immse(D(10001:1:30000),preout(51:1:20050));
rmse=sqrt(sum((D(10001:1:30000)-preout(51:1:20050)).^2)/20000);
R(o,1)=rmse;
%% プロット
figure(o);
xlabel('t');
xlim([10001, 30000])
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
plot((10001:1:30000),D(10001:1:30000),'--');
hold on
plot((10001:1:30000),preout(51:1:20050),'-');
end
%%