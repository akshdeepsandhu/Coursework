%% Assignment 2 
%load the data
data = load('homework2data.mat');
y = data.b;
z = data.z;
m = data.m;

%% Question 2
% fit the line f(z) = x1 + x2*z (i.e. y = x1 + x2*z)
%fitting the model ax + b, here ax = x2*z and b = x1
ft2 = fittype({'x','1'}); 
fit_obj = fit(z,y,ft2);
plot(fit_obj,z,y);
title('Least squares fit of f(z) = x1 + x2*z');
xlabel('z');
ylabel('y');
xlim([0 2.2]);
ylim([-2 7]);
%x1 = 1.973 CI:(1.859, 2.086); x2 = -0.4127 CI:(-0.544, -0.2813)

%% Trying a different method
X = [ones(length(z),1) z];
b = X\y;
yhat = X*b;
hold on 
scatter(z,y)
plot(z,yhat)
title('Least squares fit of f(z) = x1 + x2*z');
xlabel('z');
ylabel('y');
xlim([0 2.2]);
ylim([-2 7]);

y_reidual = y - yhat;
residual_norm = norm(y_reidual); % 33.3814

%% Question 3
% polynomial datafitting for d = 2,3,4,5. Pick the one with the best/lowest
% 2-norm residual 

[p1,S1] = polyfit(z,y,2);
[p2,S2] = polyfit(z,y,3);
[p3,S3] = polyfit(z,y,4);
[p4,S4] = polyfit(z,y,5);

vals = linspace(0,2.5);
yhat_poly = polyval(p4,vals);
hold on 
scatter(z,y)
plot(vals,yhat_poly,'r')
title('Polynomial fit (d=5)');
xlabel('z');
ylabel('y');
xlim([0 2.6]);
ylim([-2 7]);

%% Question 5]
%A = randn(m,n);x = randn(n,1);b = A*x;clear x;  %Given code, can be used to create random mxn matricies

m_arr = [10,100,100,100,100];
n_arr = [20,200,2000,20000,200000];
time = zeros(1,5);
time_blackslash  = zeros(1,5);

for i= 1:5
    m  = m_arr(i); n = n_arr(i);
    A = randn(m,n);x = randn(n,1);b = A*x;clear x;
    tic;
    [Q,R] = qr(A',0);
    x = Q*(R'\b);
    time(i) = toc;
    
    tic;
    x = A\b;
    time_blackslash(i) = toc;
end



