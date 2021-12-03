%% プログラミング MC 通常マッキーグラス リッジ　一般化　minimum 同時に回す用
clear;
clc;
%% データ作成
fileID =fopen('makeyglasstimedate30000plot.tex','r'); %Δt=0.1
formatspac='%f';
D=fscanf(fileID,formatspac);                          
fclose(fileID);
tau=17;
%E=D;               %ノイズの時
E=D(1:10:30000);                                      %1→11→21・・・10刻みでデータ取る
E_time=E';                                            %時系列データ行ベクトル
%データ設定
AL=3000;                                              %全体長さ
SL=1500;                                               %学習長さStudy
PL=1300;                                               %予測長さ
a=200;                                                %過渡の長さ
%% ネットワーク初期
%リザーバ サイズ設定　ニューロンの数
inSize=1;                                             %入力ニューロン数K
resSize=150;                                          %リザーバニューロン数N
outSize=1;                                            %出力ニューロン数L

%重み初期作成
Win=zeros(resSize,inSize);      %入力重み行列 N×K次元
W=zeros(resSize,resSize);    %中間層重み行列 N×N次元 各モデルに調整する
Wout=zeros(outSize,resSize);    %出力層重み行列 L×N次元 学習する
%% ループポイント
%for nv=1:1:300          %
%for nr=1:1:1000         %61番までvは一緒
%%  内部状態と学習更新式準備

X=zeros(resSize,AL);            %全部の内部状態の箱、横時間、縦状態ベクトル
I=eye(resSize);                 %単位行列
M=zeros(resSize,SL);            %学習用行列後で転地する
T=zeros(SL,outSize);            %教師データ行列N×L次元　予測用
preout=zeros(PL,outSize);       %予測行列
preoutbase=zeros(PL,outSize);   %一般化の予測
Xbase=zeros(resSize,PL+1);      %一般化用の箱


%各パラメータ
r=1.01;             %リザーバの固定された絶対値r
%b=0.5;                     %リザーバの固定されたバックコネククション絶対値b
%v=0.01*nv;            %入力の重みv
%% 重み作成
%{
%入力重み作成
Win(:,:)=v;
for t=1:resSize
    i=randi(2);
    if i==1
        Win(t,1)=Win(t,1);
    else
        Win(t,1)=-Win(t,1);
    end
end
%}

Win=(rand(resSize,inSize)*0.2)-0.1;%[-0.1,0.1]の一様分布(by論文から）
%Win=normrnd(0,exp(-1.5),[1,150]);
%Win=Win';
%% ESN DLR,DLRB,SCRの　重み

%それぞれのパターンを選ぶ

%{
N=150;
Z=zeros(N,N);%ランダムに接続する場所
NN = nnz(Z);
while NN<=N*N*0.5
rr=randi(N,1);%150の数からランダムに一つ
rrr=randi(N,1);
    Z(rr,rrr)=1;
NN = nnz(Z);
end
[row,col,v] = find(Z);
[m,n] = size(v);
aa=0.4+0.1*nv;
VV=(rand([m,n])*(aa+aa))-aa;%一様分布
A=zeros(N);
for t=1:1:m
    A(row(t),col(t))=VV(t);
end
intWM=A;
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.4+W*0.1*nr;%α今回0.3
%}

%{
for i=1:N-1 %DLR
    W(i+1,i)=r;
end
%}

%{
for i=1:N-1 %DLRB
    W(i+1,i)=r;
    W(i,i+1)=b;
end
%}

%
for i=1:resSize-1 %SCR  (正規化してr倍の方がループ少なくて済む）
    W(i+1,i)=r;
end
    W(1,resSize)=r;
%}

%% 内部状態活性化 学習準備

%今回は201からスタート前の情報は0,
%X(:,a)=tanh(Win*E(a));%過渡取り除いて活性化201からスタートなので200番目作る場合もある

for t=a+1:1:a+SL%学習活性化
   X(:,t)=tanh(Win*E(t)+W*X(:,t-1));            %内部状態活性化                          
end
M=X(:,a+1:a+SL);                                %最初201の内部状態ベクトル
M=M';                                           %逆行列用に転置
T(1:SL,:)=E(a+2:a+1+SL,:);                      %1step先が教師　出て欲しい出力は202
%% 学習期間　予測用
Wout=pinv(M)*T;                                 %一般化逆行列で学習
ramda=0.0000001;                                %リッジ回帰λram=0.00000001くらいがベスト
Woutride=pinv(M'*M+ramda*I)*M'*T;               %リッジ回帰
%% 予測
%1ステップ予測

for t=a+SL+1:AL                                      %出力
  X(:,t)=tanh(Win*E(t)+W*X(:,t-1));
  preoutbase(t-a-SL,1)=Wout'*X(:,t);
end
rmse=sqrt(sum((E(a+SL+2:AL)-preoutbase(1:PL-1)).^2)/499);
%%誤差



%% リアプノフ指数計算
riaSize=500;                                    %リアプノフ指数のl=500
Xria_true=zeros(resSize,riaSize);               %リアプノフ指数用のリザーバー箱正しい
Xria_putu=zeros(resSize,riaSize);               %リアプノフ指数用のリザーバー摂動を与えられた
lamda=zeros(1,riaSize);                         %λ収納用行ベクトル
ria=zeros(1,resSize);                           %ニューロン数で平均取る
Xria_true(:,:)=X(:,2501:3000);             %正しい状態行列を代入

for n=1:1:150    %ニューロン数繰り返す
%リアプノフ指数共通操作
%学習期間のリアプノフ指数考える
%(フリーラン予測なら予測期間のリアプノフ指数考えても良いかも)
%Xria_true(:,1)=tanh(Win*E(a+1));                %過渡取り除いて活性化201からスタートこれが1番目
%r=randi(150,1);                                 %150の中からランダムに数字一つ%一様分布で取得


x=Xria_true(:,1);                                %正しい内部状態ベクトル縦150
p=zeros(150,1);                                  %ゼロ150ベクトル摂動用
p(n,1)=10^-8;                                   %n番目のニューロンに10^-12を代入　　

xp=x+p;                                          %内部状態ベクトルに摂動を与える 摂動を与えられたベクトル
Xria_putu(:,1)=xp;                               %摂動ベクトルを収納
ganma=norm(x-xp);                                %ノルムγlの計算
ganma0=ganma;                                    %初期のノルムγ0=10^-12

for t=1:riaSize-1      %リアプノフ指数の移動
    x=Xria_true(:,t+1);                         %正しいベクトル
    xp=tanh(Win*E(2500+(t+1))+W*xp);            %摂動を与えられた内部状態ベクトル正規化したもので計算なのでxp
    ganma=norm(x-xp);                           %次のノルムγlの計算
    Xria_putu(:,t+1)=xp;
    xp=x+(ganma0/ganma)*(xp-x);                 %正規化
    lamda(1,t)=log(ganma/ganma0);               %自然対数
end
lya_mean=mean(lamda);                            %500の平均
lya_num(1,n)=lya_mean;                              %N個のニューロンに摂動を入れて試す150
end
lya=mean(lya_num);                              %１５０の平均

%% MC計算 
MC_step=100;                                    %なんステップまで計算するか
ybase=zeros(PL,MC_step);                        %MCのためのy1一般化
yride=zeros(PL,MC_step);                        %MCのyリッジ500×100
Tmc=zeros(SL,outSize);                          %MCの教師信号
MCk_ride=zeros(1,MC_step);                      %ショートターム用行ベクトル
MCkbase=zeros(1,MC_step);                       %一般化用

for k=1:1:MC_step           %MCのkステップ
%{
for t=a+1:1:a+SL            %学習の時系列201:700
    Tmc(t-a)=E(t-k);
end
 %}
Tmc=E(a+1-k:a+SL-k);                            %k=1の時201番目を入力した時200番目を予測できるか代入
%学習
WoutMcbase=pinv(M)*Tmc;                         %一般化逆行列で学習
WoutMc_ride=pinv(M'*M+ramda*I)*M'*Tmc;          %MCリッジ回帰

for t=a+SL+1:1:AL %701から1200 フリーラン予測ではない
    %X(:,t)=tanh(Win*E(t)+W*X(:,t-1));           %予測の活性化
    
    outMcbase=WoutMcbase'*X(:,t);                %kステップ前出力一般
    outMc_ride=WoutMc_ride'*X(:,t);             %kステップ前出力リッジ
    
    ybase((t-(a+SL)),k)=outMcbase;              %500の予測を列ベクトルにkステップ前を列ベクトル
    yride((t-(a+SL)),k)=outMc_ride;
end
%分子部分の共分散計算　Mccovは箱
MCcov=cov(E(a+SL+1-k:AL-k),ybase(:,k));         %%u(t-k)が入力 
MCcov=MCcov(1,2);                               %共分散は2×2の1,2に要素がある
MCcov=MCcov*MCcov;                              %共分散の2乗

MCkbase(1,k)=MCcov/(var(E(a+SL+1:AL))*var(ybase(:,k))); %MC計算

MCcov=cov(E(a+SL+1-k:AL-k),yride(:,k));            
MCcov=MCcov(1,2);                               %共分散は2×2の1,2に要素がある
MCcov=MCcov*MCcov;                              %共分散の2乗

MCk_ride(1,k)=MCcov/(var(E(a+SL+1:AL))*var(yride(:,k))); %MC計算
end

MCbase=sum(MCkbase);                            %逆行列MC
MC_ride=sum(MCk_ride);                          %リッジMC
%% データ保存
fileID = fopen('LEmakey_1200_SCR_v[0.01:0.01:10.0]_in[0.00001]_test_ex1.tex','a');
fprintf(fileID,'%f\n',lya);
fclose(fileID);
fileID = fopen('MCmakey_1200_ridge_SCR_v[0.01:0.01:10.0]_in[0.00001]_test_ex1.tex','a');
fprintf(fileID,'%f\n',MC_ride);
fclose(fileID);
fileID = fopen('MCmakey_1200_regression_SCR_v[0.01:0.01:10.0]_in[0.00001]_test_ex1.tex','a');
fprintf(fileID,'%f\n',MCbase);
fclose(fileID);
fileID = fopen('MCmakey_1200_RMSE_SCR_v[0.01:0.01:10.0]_in[-0.00001]_test_ex1.tex','a');
fprintf(fileID,'%f\n',rmse);
fclose(fileID);
%%
%end
%end 