%%
clc;
clear;
%%
%v = VideoWriter('shida.avi');
%open(v)
for t = 1:10
%%
oldX=0;
oldY=0;
xl = -3+t*0.2;
xh = 3-t*0.2;
yl = t*0.4;
yh = 10-t*0.4;
p=100000;
X=zeros(1,p+1);
Y=zeros(1,p+1);
cnt = 1;
while cnt<p
    U=randi(100,1,1);
    if U==1
        newX=0;
        newY=0.16*oldY;
    elseif (U >=2&&U<=8)
         newX=0.2*oldX-0.26*oldY;
         newY=0.23*oldX+0.22*oldY+0.16;
    elseif (U >=9&&U<=15)
         newX=-0.15*oldX+0.28*oldY;
         newY=0.26*oldX+0.24*oldY+0.44;
    else
         newX=0.85*oldX+0.04*oldY;
         newY=-0.04*oldX+0.85*oldY+1.6;        
    end
    oldX = newX;
    oldY = newY;
    if (oldX>=xl)&&(oldX<=xh)&&(oldY>=yl)&&(oldY<=yh)
    X(cnt+1) = newX;
    Y(cnt+1) = newY;
    cnt = cnt +1;
    end
end   
figure(t);
set(figure(t),'Position',[403 100 700 566])
%set(figure(t),'Visible','off')
plot1 =plot(X(2:p),Y(2:p),'.');
xlabel('x');
xlim([xl,xh]);
ylim([yl,yh]);
ylabel('y');
axis([xl,xh yl,yh])
set(plot1,'MarkerSize',1)
%frame(t) = getframe(t);
%%
%for i=1:3
   % writeVideo(v,frame(t))
end
%end
%close(v)