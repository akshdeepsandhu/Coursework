function [clusterCentres,P] = Kmean_Clustering(X,k,iter)
%Function that preforms k-means clustering
% param X: data matrix
% param k: the number of clusters desired
% param iter: number of iterations you wanted


%initialize K-means with random centres
%genrate random indices
indices = randperm(size(X,1));
indices = indices(1:k);
randCentres = X(indices,:);

%Clustering
% Goal is to minize ||X - PC||
%P - selection matrix n x k
%C - cluster centres matrix k x d (2 in this case)
% X - data matrix n x d
n = size(X,1);
d = size(X,2);

%Solve once using initialization centres
C = randCentres;
P = solveP(X,C,n,d,k);

for iteration = 1:iter
    %Given P solve for C
    C = solveC(X,P,n,d,k);
    %Given solved C, solve for P
    P = solveP(X,C,n,d,k);

end

clusterCentres = C;


end

function P = solveP(X,C,n,d,k)
%Helper function to solve for P
%param X: data matrix
%param C: Cluster centres
%param n: number of rows
%param d: number of features
%param k: number of cluster centres

%Make zeros matrix for P
P = zeros(n,d);

for i  = 1:size(X,1)

%Solve for P, given C and X
%for each in X, find which cluster it is nearest to
min_dist_idx = NaN;
min_dist = inf;
%get i-th row of X
x = X(i,:);
for j = 1:k
    %get j-th cluster centre and compute distance
    c = C(j,:);
    %get eucldian distane between two vectors
    dist = norm(c - x);
    if (dist < min_dist)
        min_dist = dist;
        min_dist_idx = j;
    end
end

%Add 1 to P(i,min_dist_idx).
%i.e. which cluster centre i-th row of x is nearest to

P(i,min_dist_idx) = 1;
end

end


function C = solveC(X,P,n,d,k)
%Helper function to solve for P
%param X: data matrix
%param P: Cluster centres
%param n: number of rows
%param d: number of features
%param k: number of cluster centres

% Given X and P, computing C
% Each row of C, minmize the LS problem  (C = k x d)
%ck = mean of points in cluster
%nk = number of point in given cluster

C = zeros(k,d);

for j=1:k

    p = P(:,j);%get j-th column of P. i.e all points in cluster j
    nk = sum(p); %nk = number of point is j-th cluster
    px = p.*X; %get relevant rows
    sumk = sum(px);
    mean = sumk/nk;
    C(j,:) = mean ;

end

end
