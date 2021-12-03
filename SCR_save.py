L_trn=2000;
L_val=3000;
L_tst=3000;
L_v=200;
ALL=L_trn+L_val+L_tst+L_v;

# ESN設定
#設定
K=1;            #入力ニューロン数
N=100;          #リザーバニューロン数
L=1;            #出力ニューロン数

#重み作成
V=zeros(N,K);   #入力重み行列 N×K次元
W=zeros(N,N);   #中間層重み行列 N×K次元 各モデルに調整する
U=zeros(L,N);   #出力層重み行列 L×N次元 学習する

#各パラメータ
r=0.95;         #リザーバの固定された絶対値r
b=0.05;          #リザーバの固定されたバックコネククション絶対値b
v=0.95;           #入力の重み

# 状態更新準備
X=zeros(N,ALL);                       #内部状態保存用行列
H=zeros(N,L_trn);                     #学習用行列
DD=zeros(L_trn,L);                    #教師データベクトル 
Y=zeros(1,L_val);  

# 入力重み
R=1;          #[-R,R]で乱数決定する
#V=(rand(N,K)*(R+R))-R;              #[-R,R]の一様分布入力重み(ESN)
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

# ESN DLR,DLRB,SCRの　重み
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
for i=1:N-1 %SCR
    W(i+1,i)=r;
end
    W(1,N)=r;
%}


# 内部状態活性化 
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