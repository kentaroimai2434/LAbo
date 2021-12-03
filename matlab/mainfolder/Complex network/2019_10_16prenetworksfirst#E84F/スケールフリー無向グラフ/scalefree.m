clear;
clc;
startSize =2;
m = 1;
N = 150;
g = scalefreenetwork(startSize, m, N);
plot(g, 'LineWidth', 0.2, 'EdgeAlpha', 0.4, 'MarkerSize', 8, 'Layout', 'force');
Z=zeros(150,150);
Edges = g.Edges(:,1);
%{
%%
z=Edges{1,1};
Z(z(1,1),z(1,2))=1;
for t=2:2384;
out=Edges{t,1};
z=[z;out];
Z(z(t,1),z(t,2))=1;
end
save('scallmat.mat','Z');
%%

z=Edges{1,1};
Z(z(1,1),z(1,2))=1;
for t=2:428;
out=Edges{t,1};
z=[z;out];
Z(z(t,1),z(t,2))=1;
end
save('scallmat.mat','Z')
%}
function g = scalefreenetwork(startSize, m, N)
    % create complete graph
    A = ones(startSize) - diag(ones(1, startSize));
    remain = N - startSize;
    g = graph(A);

    for r = 1 : remain
        r + startSize
        g = addnode(g, 1);

        % add m links
        deg = degree(g);
        prob = rand(m, 1) * sum(deg);
        randIndex = zeros(m, 1);

        A = adjacency(g);
        for i = 1 : m
            total = 0;

            for j = 1 : startSize + r - 1
                total = total + deg(j);
                if (total >= prob(i, 1))
                    randIndex(i) = j;
                    break;
                end
            end

            if (A(startSize + r, randIndex(i)) == 1) 
                continue;
            else
                g = addedge(g, [startSize + r], [randIndex(i)], [1]);
            end

            A = adjacency(g);
        end
    end

    [~, order] = sort(degree(g), 'descend');
    order
    [g, idx] = reordernodes(g, order);
end