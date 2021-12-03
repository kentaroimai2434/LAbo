clear;
clc;
Z = BAgraph(150,20,8);
%save('scallmat.mat','A');%隣接行列保存
ZZ=digraph(Z);%有向グラフに変更
plot(ZZ, 'LineWidth', 0.2, 'EdgeAlpha', 0.4, 'MarkerSize', 8, 'Layout', 'force');
N = nnz(Z);%非ゼロ行列要素の数
%c = dynamic_clustering(A)
%{
C=clustering_coef_bd(Z);
CC=mean(C)
lambda = charpath(Z);
deg = degrees_dir(Z);
[Dds,Dds_avg,M,P_Dds]=func_Degree_Distribution(Z);
[Lens,Lens_avg]=func_Path_Length(Z);
%D = degree(AA) ;
%}
%%
load('BAorigin_new_noise.mat')
[row,col,v] = find(Z);
[m,n] = size(v);
V=normrnd(0,exp(-0.7),[m,n]);

A=zeros(150);
for t=1:1:m
    A(row(t),col(t))=V(t);
end

%%
%save('BAorigin_new_noise.mat','Z')
save('BAconect_new_noise.mat','A');%隣接行列保存
%save('CCC.mat','CC');
%save('LLL.mat','Lens_avg')
%save('deg2.mat','deg')
%%
function A = BAgraph(N,mo,m)
% Generates a scale-free directed adjacency matrix using Barabasi and Albert algorithm
% Input: N - number of nodes in the network, mo - size of seed, m = average degree. Use mo=m or m<mo.
% Example: A = BAgraph(300,10,10);
% Ref: Methods for generating complex networks with selected structural properties for simulations, Pretterjohn et al, Frontiers Comp Neurosci
% Author:
% Tapan P Patel, Ph.D., tapan.p.patel@gmail.com
% University of Pennsylvania
hwait = waitbar(0,'Please wait. Generating directed scale-free adjacency matrix');
A = zeros(N);
E = 0;
for i=1:mo
	for j=i+1:mo
		
		A(i,j) =1;
		A(j,i) = 1;
		E = E + 2;
	end
end
% Second add remaining nodes with a preferential attachment bias - rich get
% richer
for i=mo+1:N
	waitbar(i/N,hwait,sprintf('Please wait. Generating directed scale-free adjacency matrix\n%.1f %%',(i/N)*100));
	curr_deg =0;
	while(curr_deg<m)
		sample = setdiff(1:N,[i find(A(i,:))]);
		j = datasample(sample,1);
		b = sum(A(j,:))/E;
		r = rand(1);
		if(b>r)
			r = rand(1);
			if(b>r)
			A(i,j) = 1;
			A(j,i) = 1;
			E = E +2;
			else
			A(i,j) = 1;
			E = E +1;
			end
		else
			no_connection = 1;
			while(no_connection)
				sample = setdiff(1:N,[i find(A(i,:))]);
				h = datasample(sample,1);
				b = sum(A(h,:))/E;
				r = rand(1);
				if(b>r)
					r = rand(1);
					if(b>r)
					A(h,i) = 1;
					A(i,h) = 1;
					E = E +2;
					else
					A(i,h) = 1;
					E = E+1;
					end
					no_connection = 0;
				end
			end
		end
		curr_deg = sum(A(i,:));
	end
end
delete(hwait);
end
%{
function c = dynamic_clustering(trace)
% Function calculating the Dynamic Clustering Coefficient defined in the
% paper "Understanding and Modeling the Small-World Phenomenon in Dynamic
% Networks - AD. Nguyen et al. - MSWIM 2012".
% Inputs:
% - trace: the 3D-matrix denoting the temporal graph. The 1st and 2nd
% dimension correspond to node's IDs and the 3rd dimension corresponds to
% the time.
% Outputs:
% - c: average dynamic clustering coefficient of the network..
% Author: Anh-Dung Nguyen
% Email: nad1186@gmail.com
N = size(trace,1); % number of nodes
clustering_nodes = zeros(N,1);
for i = 1:N
    t_transitive = [];
    for t1 = 1:size(trace,3)
        neighbors = setdiff(find(trace(i,:,t1)==1),i);
        if ~isempty(neighbors)
            for k = 1:length(neighbors)
                for t2 = t1:size(trace,3)
                    neighbors_of_neighbor = setdiff(find(trace(neighbors(k),:,t2)==1),[neighbors(k) i]);
                    if ~isempty(neighbors_of_neighbor)
                        for l = 1:length(neighbors_of_neighbor)
                            t3 = find(trace(neighbors_of_neighbor(l),i,t2:end)==1,1);
                            if ~isempty(t3)
                                t_transitive = [t_transitive t3];
                            end
                        end
                        break;
                    end
                end
            end
            break;
        end
    end
   
    if isempty(t_transitive)
        clustering_nodes(i) = 0;
    else
        clustering_nodes(i) = 1/min(t_transitive);
    end
end
c = mean(clustering_nodes);
end
%}
function C=clustering_coef_bd(A)
%CLUSTERING_COEF_BD     Clustering coefficient
%
%   C = clustering_coef_bd(A);
%
%   The clustering coefficient is the fraction of triangles around a node
%   (equiv. the fraction of node's neighbors that are neighbors of each other).
%
%   Input:      A,      binary directed connection matrix
%
%   Output:     C,      clustering coefficient vector
%
%   Reference: Fagiolo (2007) Phys Rev E 76:026107.
%
%
%   Mika Rubinov, UNSW, 2007-2010

%Methodological note: In directed graphs, 3 nodes generate up to 8 
%triangles (2*2*2 edges). The number of existing triangles is the main 
%diagonal of S^3/2. The number of all (in or out) neighbour pairs is 
%K(K-1)/2. Each neighbour pair may generate two triangles. "False pairs" 
%are i<->j edge pairs (these do not generate triangles). The number of 
%false pairs is the main diagonal of A^2.
%Thus the maximum possible number of triangles = 
%       = (2 edges)*([ALL PAIRS] - [FALSE PAIRS])
%       = 2 * (K(K-1)/2 - diag(A^2))
%       = K(K-1) - 2(diag(A^2))

S=A+A.';                    %symmetrized input graph
K=sum(S,2);                 %total degree (in + out)
cyc3=diag(S^3)/2;           %number of 3-cycles (ie. directed triangles)
K(cyc3==0)=inf;             %if no 3-cycles exist, make C=0 (via K=inf)
CYC3=K.*(K-1)-2*diag(A^2);	%number of all possible 3-cycles
C=cyc3./CYC3;               %clustering coefficient
end

function  [lambda,efficiency,ecc,radius,diameter] = charpath(D,diagonal_dist,infinite_dist)
%CHARPATH       Characteristic path length, global efficiency and related statistics
%
%   lambda                                  = charpath(D);
%   lambda                                  = charpath(D);
%   [lambda,efficiency]                     = charpath(D);
%   [lambda,efficiency,ecc,radius,diameter] = charpath(D,diagonal_dist,infinite_dist);
%
%   The network characteristic path length is the average shortest path
%   length between all pairs of nodes in the network. The global efficiency
%   is the average inverse shortest path length in the network. The nodal
%   eccentricity is the maximal path length between a node and any other
%   node in the network. The radius is the minimal eccentricity, and the
%   diameter is the maximal eccentricity.
%
%   Input:      D,              distance matrix
%               diagonal_dist   optional argument
%                               include distances on the main diagonal
%                                   (default: diagonal_dist=0)
%               infinite_dist   optional argument
%                               include infinite distances in calculation
%                                   (default: infinite_dist=1)
%
%   Outputs:    lambda,         network characteristic path length
%               efficiency,     network global efficiency
%               ecc,            nodal eccentricity
%               radius,         network radius
%               diameter,       network diameter
%
%   Notes:
%       The input distance matrix may be obtained with any of the distance
%   functions, e.g. distance_bin, distance_wei.
%       Characteristic path length is defined here as the mean shortest
%   path length between all pairs of nodes, for consistency with common
%   usage. Note that characteristic path length is also defined as the
%   median of the mean shortest path length from each node to all other
%   nodes.
%       Infinitely long paths (i.e. paths between disconnected nodes) are
%   included in computations by default. This behavior may be modified with
%   via the infinite_dist argument.
%
%
%   Olaf Sporns, Indiana University, 2002/2007/2008
%   Mika Rubinov, U Cambridge, 2010/2015

%   Modification history
%   2002: original (OS)
%   2010: incorporation of global efficiency (MR)
%   2015: exclusion of diagonal weights by default (MR)
%   2016: inclusion of infinite distances by default (MR)

n = size(D,1);
if any(any(isnan(D)))
    error('The distance matrix must not contain NaN values');
end
if ~exist('diagonal_dist','var') || ~diagonal_dist || isempty(diagonal_dist)
    D(1:n+1:end) = NaN;             % set diagonal distance to NaN
end
if  exist('infinite_dist','var') && ~infinite_dist
    D(isinf(D))  = NaN;             % ignore infinite path lengths
end

Dv = D(~isnan(D));                  % get non-NaN indices of D

% Mean of entries of D(G)
lambda     = mean(Dv);

% Efficiency: mean of inverse entries of D(G)
efficiency = mean(1./Dv);

% Eccentricity for each vertex
ecc        = nanmax(D,[],2);

% Radius of graph
radius     = min(ecc);

% Diameter of graph
diameter   = max(ecc);

end

function [id,od,deg] = degrees_dir(CIJ)
%DEGREES_DIR        Indegree and outdegree
%
%   [id,od,deg] = degrees_dir(CIJ);
%
%   Node degree is the number of links connected to the node. The indegree 
%   is the number of inward links and the outdegree is the number of 
%   outward links.
%
%   Input:      CIJ,    directed (binary/weighted) connection matrix
%
%   Output:     id,     node indegree
%               od,     node outdegree
%               deg,    node degree (indegree + outdegree)
%
%   Notes:  Inputs are assumed to be on the columns of the CIJ matrix.
%           Weight information is discarded.
%
%
%   Olaf Sporns, Indiana University, 2002/2006/2008


% ensure CIJ is binary...
CIJ = double(CIJ~=0);

% compute degrees
id = sum(CIJ,1);    % indegree = column sum of CIJ
od = sum(CIJ,2)';   % outdegree = row sum of CIJ
deg = id+od;        % degree = indegree+outdegree


end
