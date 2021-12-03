function [Lens,Lens_avg]=func_Path_Length(matrix)
 
 Num = size(matrix,2);
 Lens   = matrix;
 Lens(find(Lens==0))=inf;    %将?接矩????接距?矩?，?点无?相?????inf，自身到自身的距??0.
 for i=1:Num           
     Lens(i,i)=0;       
 end   
 for k=1:Num            %Floyd算法求解任意?点的最短距?
     for i=1:Num
         for j=1:Num
             if Lens(i,j)>Lens(i,k)+Lens(k,j)
                Lens(i,j)=Lens(i,k)+Lens(k,j);
             end
         end
     end
 end
 Lens_avg=sum(sum(Lens))/(Num*(Num-1));  %平均路径?度
 if Lens_avg==inf
     disp('?网??不是?通?');
 end
         
