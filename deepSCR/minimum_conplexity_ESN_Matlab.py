%% minimum complexity ESN 準備
clear;
clc;
%% データ読み取り
fileID =fopen('Henon_Map_time_series_ex12.tex','r');
formatspac='%f';
D=fscanf(fileID,formatspac); %ベクトル
fclose(fileID);
D=D';   %時系列にしている
L_trn=2000;
L_val=3000;
L_tst=3000;
L_v=200;
ALL=L_trn+L_val+L_tst+L_v;
%% ESN設定
%設定
K=1;            %入力ニューロン数
N=100;          %リザーバニューロン数
L=1;            %出力ニューロン数
%重み作成
V=zeros(N,K);   %入力重み行列 N×K次元
W=zeros(N,N);   %中間層重み行列 N×K次元 各モデルに調整する
U=zeros(L,N);   %出力層重み行列 L×N次元 学習する
%各パラメータ
r=0.95;         %リザーバの固定された絶対値r
b=0.05;          %リザーバの固定されたバックコネククション絶対値b
v=0.95;           %入力の重み
%% 状態更新準備
X=zeros(N,ALL);                       %内部状態保存用行列
H=zeros(N,L_trn);                     %学習用行列
DD=zeros(L_trn,L);                    %教師データベクトル 
Y=zeros(1,L_val);  
%% 入力重み
R=1;          %[-R,R]で乱数決定する
%V=(rand(N,K)*(R+R))-R;              %[-R,R]の一様分布入力重み(ESN)
%
V(:,:)=v;
for t=1:N
    i=randi(2);
    if i==1
        V(t,1)=V(t,1);
    else
        V(t,1)=-V(t,1);
    end
end
%}

%% ESN DLR,DLRB,SCRの　重み
%{
Z=zeros(N,N);%ランダムに接続する場所
NN = nnz(Z);
while NN<=N*N*0.5-1
rr=randi(N,1);%150の数からランダムに一つ
rrr=randi(N,1);
    Z(rr,rrr)=1;
NN = nnz(Z);
end
[row,col,v] = find(Z);
[m,n] = size(v);
aa=0.3;
VV=(rand([m,n])*(aa+aa))-aa;%一様分布
A=zeros(N);
for t=1:1:m
    A(row(t),col(t))=VV(t);
end
intWM=A;
maxval = max(abs(eigs(intWM,1)));
W = intWM/maxval;
W=W*0.3;%α今回0.3
%}

%{
for i=1:N-1 %DLR
    W(i+1,i)=r;
end
%}

%
for i=1:N-1 %DLRB
    W(i+1,i)=r;
    W(i,i+1)=b;
end
%}

%{
for i=1:N-1 %SCR
    W(i+1,i)=r;
end
    W(1,N)=r;
%}

%% 内部状態活性化 
%時系列過渡期をESNに入れない場合で試行
for t=L_v+1:1:L_v+L_trn%学習活性化
   X(:,t)=tanh(V*D(1,t)+W*X(:,t-1));%内部状態活性化
end
H=X(:,201:2200); 
H=H';
I=eye(N);%単位行列
%学習期間
ram=0.00001;%リッジ回帰λram=0.00000001くらいがベスト
U=pinv(H'*H+(ram)*I)*H'*D(L_v+2:L_v+L_trn+1)';   %教師ベクトル1ステップ先
%% 予測 1ステップ予測
for t=L_v+L_trn+1:L_v+L_trn+L_val                                      %出力
  X(:,t)=tanh(V*D(1,t)+W*X(:,t-1));
  Y(1,t-(L_v+L_trn))=U'*X(:,t);
end
MSE00 = mean(var(D(L_v+L_trn+2:L_v+L_trn+L_val+1)),1) 
NMSE = immse(D(L_v+L_trn+2:L_v+L_trn+L_val+1),Y(1:3000))/MSE00

nmse = mean((Y(1:3000)-D(L_v+L_trn+2:L_v+L_trn+L_val+1)).^2) / mean((D(L_v+L_trn+2:L_v+L_trn+L_val+1)-mean(D(L_v+L_trn+2:L_v+L_trn+L_val+1))).^2)
nmse0 = norm(Y(1:3000)-D(L_v+L_trn+2:L_v+L_trn+L_val+1)).^2 / norm(D(L_v+L_trn+2:L_v+L_trn+L_val+1)-mean(D(L_v+L_trn+2:L_v+L_trn+L_val+1))).^2
nmse1=calNMSE(D(L_v+L_trn+2:L_v+L_trn+L_val+1),Y(1:3000),0)
rmse=sqrt(sum((D(L_v+L_trn+2:L_v+L_trn+L_val+1)-Y(1:3000)).^2)/(3000))  %誤差計算
%% プロット
figure(1);
START=2202;
END=START+100-1;
plot((START:END),D(START:END),'-');
xlim([2202 2300])
xlabel('t');
ylabel('y(t)');
%title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));
hold on
plot((START:END),Y(1:100),'-');


%% Copyright(c) Naushad Ansari, 2017.
% %% Please feel free to use this open-source code for research purposes only. 
% %%
% %% contact at naushadansari09797@gmail.com in case of any query.
% %%
% %%
% %% This function calculates the nmse of a signal with reference to original 
% signal. NMSE can be calculated for 1-D/2-D/3-D signals.
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
% %% output: nmse-> nmse (normalized mean square error)
%            
% %% input:  orgSig-> original 1-D/2-D/3-D signal (or reference signal)
%            recSig-> reconstructed (1-D/2-D/3-D) signal/ signal obtained 
%            from the experiment/ signal, of which nmse is to be calculated 
%            with reference to original signal.
%            boun-> boun is the boundary left at the corners for the 
%            nmse calculation.  default value = 0
%%-----------------------------------------------------------------------%%
%%-----------------------------------------------------------------------%%
function nmse=calNMSE(orgSig,recSig,varargin)
if isempty(varargin)
    boun = 0;
else boun = varargin{1};
end
if size(orgSig,2)==1       % if signal is 1-D
    orgSig = orgSig(boun+1:end-boun,:);
    recSig = recSig(boun+1:end-boun,:);
else                       % if signal is 2-D or 3-D
    orgSig = orgSig(boun+1:end-boun,boun+1:end-boun,:);
    recSig = recSig(boun+1:end-boun,boun+1:end-boun,:);
end
mse=norm(orgSig(:)-recSig(:),2)^2/length(orgSig(:));
sigEner=norm(orgSig(:))^2;
nmse=(mse/sigEner);
end