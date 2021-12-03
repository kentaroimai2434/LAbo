%% matlab 初期化  ESN(mackyglassMC算出)改良
clear;
clc;
%% 時系列読み取り
for nnn=1:1:11
for nn=1:1:10
%{
fileID =fopen('makeyglasstimedate12000plot.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac);
fclose(fileID);
tau=17;
E=D(1:10:12000);%1→11→21・・・10刻みでデータ取る
    %}
uniformdate=(rand(1,7000)*0.1)-0.05;%(a,b)の一様分布　rand*(b-a)+a
E=uniformdate;
%% ネットワーク初期
AL=7000;%全体長さ
SL=1000;%学習長さ
PL=5000;%予測長さ
a=1000;%過渡の長さ
inSize=1; 
outSize=1;
resSize=150;%ニューロンの数
ram=0.000001;%リッジ回帰λ
%{
Z=zeros(150,150);%ランダムに接続する場所
for z=1:1:3000% 20%だけ接続
    rr=randi(150,1);%150の数からランダムに一つ
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
%}

load('randam_origin_4500.mat')
N = nnz(A);

%%  重み生成
Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]の一様分布(by論文から）
%% リザーバの重みの生成
%intWM= normrnd(0,exp(-1.5),[resSize,resSize]) ;%全結合正規分布[-1.5 -0.5]まで標準偏差変える
intWM=A;
maxval = max(abs(eigs(intWM,1)));%σ=e^(-1.2から-0.9)までσ0.02増やす
W = intWM/maxval;%つまり-1.2+0.02=-1.18
W=W*(0.4+0.1*nnn);% spectral radius(伊藤さんの論文より)
%W=intWM;
AA=eigs(W,1,'largestabs');
%%  内部状態と学習更新式準備
X=zeros(resSize,AL);%全部の内部状態の箱、横時間、縦状態ベクトル
I=eye(resSize);%単位行列
M=zeros(resSize,SL);%学習用行列
T=zeros(SL,1);%教師データベクトル
preout=zeros(PL+1,outSize);%予測ベクトル
%% 内部状態活性化
X(:,a)=tanh(Win*E(a-1));%過渡取り除いて活性化201からスタートなので200番目作る
for t=a:1:a+SL-1%学習活性化
   X(:,t+1)=tanh(Win*E(t)+W*X(:,t));%内部状態活性化
end
%% リアプノフ指数計算
ria2=zeros(150,1);
for n=1:1:150
X(:,a)=tanh(Win*E(a-1));%過渡取り除いて活性化201からスタートなので200番目作る
x=X(:,a);%内部状態ベクトル縦150
p=zeros(150,1);%ゼロ150ベクトル
r=randi(150,1);%150の中からランダムに数字一つ
p(r,1)=10^-12;%ランダムに選んだ番号に10^-12を代入
%p(1,1)=10^-12;%選んだ番号に10^-12を代入今回は(1,1)
xp=x+p;%内部状態ベクトルに摂動を与える
ganma=norm(x-xp);%ノルムγlの計算
ganma0=ganma;%初期のノルムγ0
lamda=zeros(500,1);
for t=a:1:a+SL-1%学習活性化間違えてた
   x=X(:,t+1);%次の内部状態ベクトル
    xp=tanh(Win*E(t)+W*xp);%摂動を与えられた内部状態ベクトル
    ganma=norm(x-xp);%次のノルムγlの計算
    xp=x+(ganma0/ganma)*(xp-x);%正規化
    lamda(t-(a-1),1)=log(ganma/ganma0);
end
ria1=mean(lamda);
ria2(n,1)=ria1;
end
ria=mean(ria2);
%% 学習期間
for t=a+1:1:a+SL%201:700
   M(:,t-a)=[X(:,t)];%最初201の内部状態ベクトル
   T(t-a)=E(t);%出て欲しい出力は1001
end
M=M';
Wout=pinv(M'*M+ram*I)*M'*T;
preout(1)=E(a+SL);
%% 予測
%{
for t=a+SL+1:1:a+SL+PL
    X(:,t)=tanh(Win*preout(t-(a+SL))+W*X(:,t-1));%フリーランのためにpreoutを入力に
    out=Wout'*X(:,t);%701番目出力
    preout((t-(a+SL-1)),1)=out;
end
%D=D';
E=E';
preout=preout';
%ria=log(ganma/ganma0)
%}
%% 誤差
rmse=sqrt(sum((E(a+SL+1:1:a+SL+PL)-preout(2:1:PL+1)).^2)/5000);

%%MC計算
y=zeros(PL,100);%MCのためのy1
MCk=zeros(1,100);
for k=1:1:100
for t=a+1:1:a+SL%201:700
  
   T(t-a)=E(t-1-k);%出て欲しい出力は1001
end
Woutk1=pinv(M)*T;
%y=zeros(PL,100);%MCのためのy1
for t=a+SL+1:1:a+SL+PL
    X(:,t)=tanh(Win*E(t-1)+W*X(:,t-1));
    out1=Woutk1'*X(:,t);
    y((t-(a+SL)),k)=out1;
end
MCcov=cov(E(a+SL-k:a+SL+PL-1-k),y(:,k));
MCcov=MCcov(1,2);
MCcov=MCcov*MCcov;
MCk(1,k)=MCcov/(var(E(a+SL:a+SL+PL-1))*var(y(:,k)));
end
MC=sum(MCk);
%% プロット

%{
figure(nn);
plot((1:1:1200),E(1:1:1200),'--');
set(gca,'xlim',[0, 1200]);
xlabel('t');
ylabel('x(t)');
title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((701:1:1200),preout(2:1:501),'-');

%}
fileID = fopen('LE(-0.05,0.05)test.tex','a');
fprintf(fileID,'%f\n',ria);
fclose(fileID);
fileID = fopen('MC(-0.05,0.05)test.tex','a');
fprintf(fileID,'%f\n',MC);
fclose(fileID);

end
end