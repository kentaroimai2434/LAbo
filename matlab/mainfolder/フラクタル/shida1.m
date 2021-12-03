%%
clc;
clear;
%%
p=10000;
U=randi(100,1,p);
X=zeros(1,p);
Y=zeros(1,p);
for n=1:1:p
    if U(n)==1
        X(n+1)=0;
        Y(n+1)=0.16*Y(n);
    elseif (U(n) >=2&&U(n)<=8)
         X(n+1)=0.2*X(n)-0.26*Y(n);
         Y(n+1)=0.23*X(n)+0.22*Y(n)+0.16;
    elseif (U(n) >=9&&U(n)<=15)
         X(n+1)=-0.15*X(n)+0.28*Y(n);
         Y(n+1)=0.26*X(n)+0.24*Y(n)+0.44;
    else
         X(n+1)=0.85*X(n)+0.04*Y(n);
         Y(n+1)=-0.04*X(n)+0.85*Y(n)+1.6;        
    end  
end   
%%
figure(1);
plot(X(1:p+1),Y(1:p+1),'.');
xlabel('x');
ylabel('y');
xlim([-3 3 ]);
ylim([0 10]);