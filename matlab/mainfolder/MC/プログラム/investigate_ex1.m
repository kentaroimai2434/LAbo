%% プログラミング 通常マッキーグラス リアプノフ指数検証
clear;
clc;
%% データ作成
%{
fileID =fopen('makeyglasstimedate30000plot.tex','r'); %Δt=0.1
formatspac='%f';
D=fscanf(fileID,formatspac);                          
fclose(fileID);
tau=17;
%E=D;               %ノイズの時
E=D(1:10:30000);                                      %1→11→21・・・10刻みでデータ取る
E_time=E';                                            %時系列データ行ベクトル
%}
%データ設定
AL=3000;                                              %全体長さ
SL=1500;                                               %学習長さStudy
PL=1300;                                               %予測長さ
a=200;                                                %過渡の長さ

aa = 3.9;%出生率;
t=3000;
x=zeros(1,t);%要素入れる行ベクトル
x(1) = 0.1;%初期値
%% 更新
for n=1:t-1
    x(n+1) = aa * x(n) * (1-x(n));
end
E=x;
%% ネットワーク初期
%リザーバ サイズ設定　ニューロンの数
inSize=1;                                             %入力ニューロン数K
resSize=1;                                          %リザーバニューロン数N
outSize=1;                                            %出力ニューロン数L

%重み初期作成
Win=zeros(resSize,inSize);      %入力重み行列 N×K次元
W=zeros(resSize,resSize);    %中間層重み行列 N×N次元 各モデルに調整する
Wout=zeros(outSize,resSize);    %出力層重み行列 L×N次元 学習する
Win=1;
W=1;
%%  内部状態と学習更新式準備

X=zeros(resSize,AL);            %全部の内部状態の箱、横時間、縦状態ベクトル
I=eye(resSize);                 %単位行列
M=zeros(resSize,SL);            %学習用行列後で転地する
T=zeros(SL,outSize);            %教師データ行列N×L次元　予測用
preout=zeros(PL,outSize);       %予測行列
preoutbase=zeros(PL,outSize);   %一般化の予測
Xbase=zeros(resSize,PL+1);      %一般化用の箱



%% 内部状態活性化 学習準備

%今回は201からスタート前の情報は0,
%X(:,a)=tanh(Win*E(a));%過渡取り除いて活性化201からスタートなので200番目作る場合もある

for t=a+1:1:AL%学習活性化
   X(:,t)=tanh(E(1,t));            %内部状態活性化                          
end
%% リアプノフ指数計算
riaSize=500;                                    %リアプノフ指数のl=500
Xria_true=zeros(resSize,riaSize);               %リアプノフ指数用のリザーバー箱正しい
Xria_putu=zeros(resSize,riaSize);               %リアプノフ指数用のリザーバー摂動を与えられた
lamda=zeros(1,riaSize);                         %λ収納用行ベクトル
ria=zeros(1,resSize);                           %ニューロン数で平均取る
Xria_true(:,:)=X(:,2501:3000);             %正しい状態行列を代入

%リアプノフ指数共通操作
%学習期間のリアプノフ指数考える
%(フリーラン予測なら予測期間のリアプノフ指数考えても良いかも)
%Xria_true(:,1)=tanh(Win*E(a+1));                %過渡取り除いて活性化201からスタートこれが1番目
%r=randi(150,1);                                 %150の中からランダムに数字一つ%一様分布で取得


x=Xria_true(:,1);                                %正しい内部状態ベクトル縦150                                %ゼロ150ベクトル摂動用
p=10^-8;                                   %n番目のニューロンに10^-12を代入　　

xp=x+p;                                          %内部状態ベクトルに摂動を与える 摂動を与えられたベクトル
Xria_putu(:,1)=xp;                               %摂動ベクトルを収納
ganma=norm(x-xp);                                %ノルムγlの計算
ganma0=ganma;                                    %初期のノルムγ0=10^-12

for t=1:riaSize-1      %リアプノフ指数の移動
    x=Xria_true(:,t+1);                         %正しいベクトル
    xp=tanh(Win*E(2500+(t+1))+xp);            %摂動を与えられた内部状態ベクトル正規化したもので計算なのでxp
    ganma=norm(x-xp);                           %次のノルムγlの計算
    Xria_putu(:,t+1)=xp;
    xp=x+(ganma0/ganma)*(xp-x);                 %正規化
    lamda(1,t)=log(ganma/ganma0);               %自然対数
end
lya_mean=mean(lamda);                            %500の平均
                         %N個のニューロンに摂動を入れて試す150

