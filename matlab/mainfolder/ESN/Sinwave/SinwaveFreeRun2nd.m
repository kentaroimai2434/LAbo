%% matlab 初期化  ESN(sin波,フリーラン予測,遅れ時間1,1入力)
clear;
clc;
%% データ生成
for n=1:350;
 d(n)=1/2*sin(n/4);
end
%% ネットワーク初期
AL=50;%全体長さ
SL=200;%学習長さ
PL=50;%予測長さ
a=100;%過渡の長さ
inSize=1; 
outSize=1;
resSize=20;%ニューロンの数
p=0.2; % sparity
ram=0.001;%リッジ回帰λ
%%  重み生成
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]の一様分布
%% リザーバの重みの生成
intWM = sprand(resSize, resSize, p);
intWM = spfun(@Point1tominus1,intWM);%2%繋いだ重みを[-0.1,0.1]にしている
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.98;% spectral radius
A=eigs(W,1,'largestabs');
%%  内部状態と学習更新式準備
X=zeros(resSize,AL);
I=eye(resSize);
M=zeros(resSize,SL);
T=zeros(SL,1);
preout=zeros(PL+1,outSize);
V=(rand(resSize,1)*0.0016)-0.0008;
%% 内部状態活性化
X(:,100)=tanh(Win*d(99));%過渡取り除いて活性化101からスタートなので100番目作る
for t=100:1:299%学習活性化
   X(:,t+1)=tanh(Win*d(t)+W*X(:,t)+V*1);
end
%% 学習期間
for t=a+1:1:a+SL%101:300
   M(:,t-100)=[X(:,t)];%最初101の内部状態ベクトル
   T(t-100)=d(t);%出て欲しい出力は101
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1)=d(300);
%% 予測
for t=301:1:350
    X(:,t)=tanh(Win*preout(t-300)+W*X(:,t-1)+V*1);
    out=Wout'*X(:,t);
    preout((t-299),1)=out;
end
preout=preout';
%% 誤差
rmse=sqrt(sum((d(301:1:350)-preout(2:1:51)).^2)/50);
%% プロット
figure(1);
plot((301:350),d(301:350),'--');
set(gca,'xlim',[300, 350]);
xlabel('t');
ylabel('x(t)');
title(sprintf('Sine wave'));
hold on
plot((301:350),preout(2:51),'-');
legend('目標値','予測値')
%%