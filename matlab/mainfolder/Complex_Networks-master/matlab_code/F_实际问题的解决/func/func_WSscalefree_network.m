function [matrix,x,y] = func_WSscalefree_network(Num,K,Per);


XY_data = 1000*rand(2,Num);
x       = XY_data(1,:);
y       = XY_data(2,:);
Size1   = 8;%��ʾ����ĳ�ʼ�ڵ����
Size2   = 4;%��ʾ�µ�����������ߵ���Ŀ

%����ϡ�����,�ڽӾ���
adjmatrix = sparse(Size1,Size1);
for i=1:Size1
    for j=1:Size1
        if j~=i
           adjmatrix(i,j) = 1;
        end
    end
end
adjmatrix = sparse(adjmatrix);

%����ڵ��
Ddegree = zeros(1,Size1+1) ;  
for p = 2:Size1+1
    Ddegree(p) = sum(adjmatrix(1:Size1,p-1));
end
 
for Js = Size1+1:Num
    %����֮ǰ����������ڵ�Ķ���֮��
    total_degree = 2*Size2*(Js-4)+6;
    cum_degree   = cumsum(Ddegree/total_degree);
    choose       = zeros(1,Size2);
    %��һ�����µ������ӵ�
    r1           = rand();
    choose(1)    = min(find((cum_degree>=r1)==1));
    %�ڶ������µ������ӵ�
    r2           = rand();
    choose(2)    = min(find((cum_degree>=r2)==1));
    while choose(2)==choose(1)
          r2        = rand();
          choose(2) = min(find((cum_degree>=r2)==1)) ;
    end
      
    %���������µ������ӵ�
    r3          = rand();
    choose(3)   = min(find((cum_degree>=r3)==1));
     
    while(choose(3)==choose(1))|(choose(3)==choose(2))
          r3 = rand();
          choose(3) = min(find((cum_degree>=r3)==1));
    end
     
     %���ĸ����µ������ӵ�
     r4         = rand();
     choose(4)  = min(find((cum_degree>=r4)==1));
     
     while(choose(4)==choose(1))|(choose(4)==choose(2))|(choose(4)==choose(3))
           r4        = rand();
           choose(4) = min(find((cum_degree>=r4)==1));
     end

     for k=1:Size2
         adjmatrix(Js,choose(k)) = 1;
         adjmatrix(choose(k),Js) = 1;
     end
     Ddegree         = zeros(1,Js+1);
     Ddegree(2:Js+1) = sum(adjmatrix);
     
    matrix = full(adjmatrix); 
    for i1=1:Js
        for j1=i1+1:i1+K
            j2=j1;
            if j1>Num
               j2=mod(j1,Num);
            end
            p1 = rand();
            %������������ж��Ƿ��������
            if p1 < Per             
               matrix(i1,j2) = 0;
               matrix(j2,i1) = 0;  
               matrix(i1,i1) = inf; 
               a             = find(matrix(i1,:)==0);
               rand_data     = randint(1,1,[1,length(a)]);
               jjj           = a(rand_data);
               matrix(i1,jjj)= 1;
               matrix(jjj,i1)= 1;
               matrix(i1,i1) = 0;
            end
        end
    end
 
end


