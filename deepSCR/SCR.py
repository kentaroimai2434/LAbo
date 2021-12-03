import numpy as np
import numpy.matlib as npm
import scipy as sc
import random
import sys

class SCR():
    
    def __init__(self, inputs, Ni, Nh, No):
        
        self.inputs = inputs  #入力
        self.Ni = Ni #入力ニューロン数
        self.Nh = Nh #中間ニューロン数
        self,No = No #出力ニューロン数
        
        self.L_train = len(inputs)*0.25
        self.L_val = len(inputs)*0.25
        self.L_test =  len(inputs)*0.45
        self.L_v = len(inputs)*0.05
        self.ALL　=　L_trn+L_val+L_tst+L_v

        return 
    
    def computeLayerState():
        
        #重み行列作成
        self.IWeight = np.random.rand(self.Nh,self.Ni) #入力重み行列 Nh×Ni次元
        self.HWeight = np.zeros((Nh,Nh)) #中間層重み行列
        self.OWeight =  np.random.rand(No,N) #出力層重み行列 
        
        #各パラメータ
        r=0.95 #リザーバの固定された絶対値r
        b=0.05 #リザーバの固定されたバックコネククション絶対値b
        v=0.95 #入力の重み

        # 状態更新準備
        X = zeros((self.Nh,self.ALL))  #内部状態保存用行列
        H = zeros((self.N,self.L_trn)) #学習用行列
        DD = zeros((self.L_trn,self.No)) #教師データベクトル 
        Y = zeros((1,self.L_val))  

        #中間層重み
        for i in range(Nh):
            if i<Nh-1:
                w[i+1,i]=r
            else:
                w[0,Nh-1]=r
        







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