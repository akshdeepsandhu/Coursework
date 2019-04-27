%% ML Activity 1

%Load and view a sample image from the dataset
clear all
load('mnist.mat')
%view the data
figure(1)
clf
imshow(reshape(trainX(2,:),28,28)')
title(trainY(2))

%%
% Q2

%Create test and training dataframes
idx = trainY == 4 | trainY == 9;
A = double(trainX(idx,:));
b = double(trainY(idx));

idx = testY == 4 | testY == 9;
Atest = double(testX(idx,:));
btest = double(testY(idx));


b(b == 4) = [1];
b(b== 9) = [-1];

%Normalize and remove bias
m = size(A,1) ;
Amean = mean(A,1);
A = A - ones(m,1)*Amean;

Astd = std(A,1);
A = A./ max(ones(m,1)*Astd,1);

%Solve using LS
xls = A\b';
loss = norm(A*xls - b');
%xls is solution to ls problem 

%% get training error for ls
b_ls_tr = getB(A,xls,1);
train_err_ls = miss_class(b',b_ls_tr);
disp("LS training error is: " + train_err_ls);


%% 

%normalize test data
mtest= size(Atest,1);
Atest = Atest - ones(mtest,1)*Amean;
Atest = Atest./ max(ones(mtest,1)*Astd,1);

%define classes for test vector
btest(btest == 4) = [1];
btest(btest== 9) = [-1];

%% get test error ls
b_ls_test = getB(Atest,xls,1);
test_err_ls = miss_class(btest',b_ls_test);
disp("LS test error is: " + test_err_ls);


%% Logistic regression (fixed step size)

%make b vectors {0,1} classes
b = (b+1)/2;
btest = (btest + 1)/2;

%%
%generate weights vectors
x_logreg = zeros(size(testX,2),1);

%fixed step size
alpha = 1/m;

sigmoid = @(x)(1./(1+exp(-x)));
cost = @(s)(( -b * log(sigmoid(s)+eps) - (1-b')' * log(1-sigmoid(s)+eps)));

%preform gradient desenct
for i=1:1000 
    
    z = sigmoid(A*x_logreg);
    grad = A'*(z - b');
    x_logreg = x_logreg - alpha*grad;
    
    c(i) = cost(A*x_logreg);%( -b * log(sigmoid(A*x_logreg)+eps) - (1-b')' * log(1-sigmoid(A*x_logreg)+eps)) ;
end

%plot cost vs iterations
plot(1:1000,c)
xlabel("Iteration")
ylabel("Cost of objective function")

%% Get training and test error for logistic regresion (using gradient descent)
b_log_tr = getB(A,x_logreg,0);
b_log_test = getB(Atest,x_logreg,0);

log_train_miss_class = miss_class(b',b_log_tr);
log_test_miss_class = miss_class(btest',b_log_test);

disp("Logistic regression traing error is: " + log_train_miss_class);
disp("Logistic regression test error is: " + log_test_miss_class);
%% Gradient descent wtih backtracking search

x_logreg = zeros(size(testX,2),1);

%line search parameters
alpha = 0.5;
beta = 0.5;
s =1;

%cost and sigmoid function
sigmoid = @(x)(1./(1+exp(-x)));
cost = @(s)(( -b * log(sigmoid(s)+eps) - (1-b')' * log(1-sigmoid(s)+eps)));


%preform gradient desenct with backtracking line search
for i=1:1000
    
    z = sigmoid(A*x_logreg);
    grad = A'*(z - b'); %gradient (computing descent direction)
    
    %starting line search to select best step size
    fx = cost(A*x_logreg);
    
    while cost(A*(x_logreg -alpha*grad)) < fx -alpha*s*norm(grad)^2
        alpha = beta*alpha;
    end
   
    %computed best step size
    x_logreg = x_logreg - alpha*grad;
    
    %update cost for plotting
    c(i) = cost(A*x_logreg);
end

plot(1:1000,c)
xlabel("Iterations")
ylabel("Cost of objective function")

%% get training and test for logistic regression with gradient descent using line search
b_search_tr = getB(A,x_logreg,0);
b_search_test = getB(Atest,x_logreg,0);

log_train_miss_class_search =  miss_class(b',b_search_tr);
log_test_miss_class_search = miss_class(btest',b_search_test);

disp("Logistic regression (with line search) traing error is: " + log_train_miss_class_search);
disp("Logistic regression(with line search) test error is: " + log_test_miss_class_search);

%% Functions

function miss_class_rate = miss_class(b,b_hat)


%function that returns the missclassification rate
%param b: vector of observed class
%param b_hat: vector of estimated class
%return miss_class_rate: missclassifcation error rate

miss_class_rate = 0;
m = size(b,1);

miss_class_rate = sum(b ~= b_hat)/m;

end

function b_hat = getB(A,x,type)
 
%function that computes b_hat, i.e. A*x 
%for some estimated parameters x
%param A: data matrix
%param x: parameter estimates
%param type: type = 1 {-1,1} classification, type = 0 {0,1} classification
%return b_hat: vector of predicted classes

if type == 1
    c = 0;
    c1 = 1;
    c2 = -1;
    
elseif type == 0 
    c = 0.5;
    c1 = 1;
    c2 = 0;
else
    disp("Error, type can only be 0 or 1");
end

rows = size(A,1);
b_hat = zeros(rows,1);

%test error
for i=1:rows
    %loop over rows and classifiy as 1 or 0
    if A(i,:)*x > c
        b_hat(i)= c1;
    else
        b_hat(i)= c2;
    end
    
end

end


