%Ash Sandhu Hwk 5
% Question 6
clc
clear
%% load data
fid = fopen('spambase/spambase.data','r');
data = textscan(fid,repmat('%f',1,58),'delimiter',',');
fclose(fid);
data = cell2mat(data);
A = data(:,1:end-1);
b = data(:,end)*2-1; % change 0,1 to -1,1
[m,n] = size(A);
b01 = data(:,end); % revert back to 0/1 classification

%% Train-test split
rng('default')
rng(1);
mtrain = 4000;
mtest = 601;
p = randperm(m); 
A = A(p,:); b = b(p);b01 = b01(p);
Atrain = A(1:mtrain,:);
btrain = b(1:mtrain);
b01train = b01(1:mtrain);
Atest = A(mtrain+1:end,:);
btest = b(mtrain+1:end);
b01test = b01(mtrain+1:end);

%% de-mean 
Am = mean(Atrain,1);
Atrain = Atrain - ones(mtrain,1)*Am;
Atest = Atest - ones(mtest,1)*Am;
Ac = std(Atrain,1);
Atrain = Atrain ./ (ones(mtrain,1)*Ac);
Atest = Atest ./ (ones(mtest,1)*Ac);

%% Gradient descent wtih backtracking search
% This is classification as 0,1 
x_logreg = zeros(57,1);
test_err_arr = zeros(1000,1);
train_err_arr = zeros(1000,1);


%fixed step size
alpha = 1/m;

%cost and sigmoid function
sigmoid = @(x)(1./(1+exp(-x)));
cost = @(s)(( -b01train' * log(sigmoid(s)+eps) - (1-b01train)' * log(1-sigmoid(s)+eps)));

%preform gradient desenct
for i=1:1000
    
     z = sigmoid(Atrain*x_logreg);
     grad = Atrain'*(z - b01train);
    %computed best step size
    x_logreg = x_logreg - alpha*grad;
    
    %update cost for plotting
    c(i) = cost(Atrain*x_logreg);
    
    %get training and test error
    b_search_tr = getB(Atrain,x_logreg,0);
    b_search_test = getB(Atest,x_logreg,0);
    
    test_err_arr(i) =  miss_class(b01train,b_search_tr);
    train_err_arr(i) = miss_class(b01test,b_search_test);
    
    
end

%%
plot(1:1000,c)
xlabel("Iterations")
ylabel("Cost of objective function")

%%
plot(1:1000,train_err_arr)
xlabel("Iterations")
ylabel("Training Error")
%%
plot(1:1000,test_err_arr)
xlabel("Iterations")
ylabel("Testing Error")
%% get training and test for logistic regression with gradient descent using line search
b_search_tr = getB(Atrain,x_logreg,0);
b_search_test = getB(Atest,x_logreg,0);

log_train_miss_class_search =  miss_class(b01train,b_search_tr);
log_test_miss_class_search = miss_class(b01test,b_search_test);
%% Dampened Newtons Method
    
x_dn = zeros(57,1);
test_err_arr = zeros(1000,1);
train_err_arr = zeros(1000,1);


%fixed step size
alpha = 1/m;

%cost and sigmoid function
sigmoid = @(x)(1./(1+exp(-x)));
cost = @(s)(( -b01train' * log(sigmoid(s)+eps) - (1-b01train)' * log(1-sigmoid(s)+eps)));

%preform gradient desenct
for i=1:1000
    
    z = sig(Atrain*x_dn);
    grad = Atrain'*( z - b01train);
    hess = Atrain'*diag(zref.*(1-zref))*Atrain;
    
    x_dn = x_dn - alpha.*inv(hess)*grad;
    
    %update cost for plotting
    c(i) = cost(Atrain*x_dn);
    
    %get training and test error
    b_search_tr = getB(Atrain,x_dn,0);
    b_search_test = getB(Atest,x_dn,0);
    
    test_err_arr(i) =  miss_class(b01train,b_search_tr);
    train_err_arr(i) = miss_class(b01test,b_search_test);
    
    
end

%%
plot(1:1000,c)
xlabel("Iterations")
ylabel("Cost of objective function")

%%
plot(1:1000,train_err_arr)
xlabel("Iterations")
ylabel("Training Error")
%%
plot(1:1000,test_err_arr)
xlabel("Iterations")
ylabel("Testing Error")
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


