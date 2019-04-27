% Machine learning activity 2
% This matlab file contains the code for specific questions
% Note that the functions used for clustering are the end of the file. 
% The function for clustering is Kmean_Clustering. 
% This file walks through the steps in constructing the clustering function.
% Sorry if this is an inconvinient format. 


clear all
%% Question 1
load embeddings
embeddings = embeddings(1:9964,1:end);
fid = fopen('wordlist.txt');
data = textscan(fid,'%s');
fclose(fid);
words = data{1};

%% Question 2 part i

[U,S,V] = svds(embeddings,2);
emb2d = U*sqrt(S);

figure(1)
clf
plot(emb2d(:,1),emb2d(:,2),'linestyle','none')
hold on
text(emb2d(:,1),emb2d(:,2), words)
%% Question 2 part ii
fid = fopen('plotwords.txt');
data = textscan(fid,'%s');
fclose(fid);
plotwords = data{1};

n=length(words);
toplot = false(n,1); %n is the number of words
for k = 1:n
word = words{k};
toplot(k) = sum(strcmpi(word,plotwords))>0;
end
figure(1)
clf
plot(emb2d(toplot,1),emb2d(toplot,2),'linestyle','none')
hold on
text(emb2d(toplot,1),emb2d(toplot,2), words(toplot))


%% Question 3 K-means clustering

%need K = 500 cluster. Therefore, 500 centres. 

%Randomly choose 500 rows of the matrix to get cluster centres

%% Trying with 3 cluster centres of svd data

k = 3;

%genrate random indices
indices = randperm(size(emb2d,1));
indices = indices(1:k);
randCentres = emb2d(indices,:);

%Clustering 
% Goal is to minize ||X - PC|| 
%P - selection matrix n x k 
%C - cluster centres matrix k x d (2 in this case)
% X - data matrix n x d
X = emb2d; 
n = size(X,1);
d = size(X,2);
C = randCentres; 
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
%% Done computing P 
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
    
%Found min C
%% testing function
Pmin = solveP(X,randCentres,n,d,k);
sum(Pmin == P)
%solveP works

Cmin = solveC(X,P,n,d,k);
sum(Cmin==C)
%solveC works
%%
%test clustering for emb2d 
[C,P] = Kmean_Clustering(embeddings,500,100);

%% get some clusters

%looking at the first 50 columns
cluster_words = {};
for i = 1:50
    p_i = P(:,i); %get i-th selection column
    idx = find(p_i == 1);
    cluster_words{size(cluster_words,2)+1} = words(idx);
end

%% Function made using script above


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


