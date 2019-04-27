%Assignment 5 

%% Question 1
format long

theta = [-0.1289, -0.1352 ,-0.1088, -0.0632, -0.0587, -0.0484, -0.0280, -0.0085,0.0259, 0.0264,0.1282]';
r = [42895, 42911, 42851, 42779, 42774,42764,42750,42744, 42749, 42749, 42894]';

%Equation: y = mx + b
%Let y= 2r ; m = -2rcos(theta);  x = epsilon; b = L 
%Equation is now 2r = L - 2rcos(theta)*epsilon
%A = [1 -2rcos(theta)]; x =[L epsilon] ; b = [2r] 
%Solve Ax = b

m = -2*r.*cos(theta);

%Solve for L and epsilon
b = 2*r;
A = [ones(1,11)' m];

x = A\b;

L = x(1);
epsilon = x(2);


%Now that L and epsilon are calculated, plot predicted function and given data
%points: Function: r = L/(2(1+?cos?)
min_val = min(theta);
max_val = max(theta);
extra = abs(min_val-max_val)/10;

XX = linspace(min_val-extra, max_val+extra, 200); 
YY = L./(2*(1+epsilon*cos(XX))); 
plot(XX,YY, 'k-', theta,r,'ro');
legend('Least-squares fit', 'Original data')


%Generate a plot in polar coordinates
theta_2 = linspace(-pi,pi); 
r_2 = L./(2*(1+epsilon*cos(theta_2))); 
%polarplot(theta_2, r_2);
hold on
%polarplot(theta,r, 'ro');




%% Question 4
%below is the code relevant to part a
%Just to ensure that the method is able to solve the system

N = 63;
n = N*N;
h = 1/(N+1);
c = 2*(pi*h)^2;
A = delsq(numgrid('S',N+2)) + c*speye(n);

l = N;
m = N;
eig1 = 4 - 2*(cos(l*pi*h)+cos(m*pi*h)) + 2*(pi*h)^2;
eig2 =  4 - 2*(cos(pi*h)+cos(pi*h)) + 2*(pi*h)^2;

K2 = abs(eig1)/abs(eig2)

actual = cond(full(A))

%% part b
%Below is the driver code to run the functions and produce the appropriate
%plots

%define tol, L and N
tol = 10^-5;
L = 2:5;
N_vals = 2.^L - 1;

%create matrix of output for different N values
x_arr = cell(4,1);
for i=1:4
    
    %create relevant variables
    N = N_vals(i);
    n = N*N;
    %h = 1/(N+1);
    c = 2*(pi/(N+1))^2;
    A = delsq(numgrid('S',N+2)) + c*speye(n);
    b = 1/(N+1) *ones(n,1);
    
    
    %compute solutuion
    [x_sol, K2_sol, itr_sol, n_sol] = systemSolver(A,b, tol);  

    %store solutions
    x_arr{i} = x_sol;
    K2_arr(i) = K2_sol;
    itr_arr(i) = itr_sol;
    n_arr(i) = n_sol;
    
    
end 

%produce a plot of n vs iteration count to look at relationship 
plot(n_arr,itr_arr);
xlabel('n');
ylabel('iteration count');

%expect a linear plot, since the algortihm has O(n) complexity, so makes
%sense. i.e. as n increases, the number of iterations required lineraly
%with n.


%% Question 5
%Below is the driver code to run the functions and produce the appropriate
%plots

%define tol, L and N
tol = 10^-5;
L2 = 2:6;
N_vals2 = 2.^L2 - 1;

%create matrix of output for different N values
x_arr2 = cell(5,1);
for i=1:5
    
    %create relevant variables
    N2 = N_vals2(i);
    n2 = N2*N2;
    c2 = 2*(pi/(N2+1))^2;
    A2 = delsq(numgrid('S',N2+2)) + c2*speye(n2);
    b2 = 1/(N2+1) *ones(n2,1);
    
    %compute solutuion
    [x_sol2,n_sol2, itr_sol2, K2_sol2] = pcg_method(A2,b2, tol);  

    %store solutions
    x_arr2{i} = x_sol2;
    K2_arr2(i) = K2_sol2;
    itr_arr2(i) = itr_sol2;
    n_arr2(i) = n_sol2;
    
    
end 

%produce a plot of n vs iteration count to look at relationship 
semilogx(n_arr2, itr_arr2);
xlabel('n');
ylabel('iteration count');




%% Functions 
% The functions relevant to Questions 4 and 5 are given below


function [xJ, K2, itr, n] = systemSolver(A,b, tol)
    %Function that uses jacobi method to solve a linear system Ax = b
    
    n = size(A,1);
   
    N = sqrt(n); %get N and h to compute the condition number
    h = 1/(N+1);
    c = 2*(pi*h)^2;
    A = delsq(numgrid('S',N+2)) + c*speye(n);

    l = N;
    m = N;
    eig1 = 4 - 2*(cos(l*pi*h)+cos(m*pi*h)) + 2*(pi*h)^2;
    eig2 =  4 - 2*(cos(pi*h)+cos(pi*h)) + 2*(pi*h)^2;
    
   
    K2 = abs(eig1)/abs(eig2); %evaluate condintion number 
    
    Dv = diag(A); %Get diagonal elements of A
            
    x = zeros(n,1); r = b;
    count = 0;
    for i=1:100000 
        x = x + r./Dv; 
        r = b - A*x; %get residual 
        
        rJ(i) = norm(r)/norm(b);
        count = i;
        if rJ(i) < tol, break, end
        
    end 
    xJ = x; %return vector of x values
    itr = count; %number of iterations before residual goes below tolerance
    
end


function [xCG,n,itr, K2] = pcg_method(A,b,tol)
    %PCG method for a given system 
    
    n = size(A,1);
   
    N = sqrt(n); %get N and h to compute the condition number
    h = 1/(N+1);
    c = 2*(pi*h)^2;
    A = delsq(numgrid('S',N+2)) + c*speye(n);

    l = N;
    m = N;
    eig1 = 4 - 2*(cos(l*pi*h)+cos(m*pi*h)) + 2*(pi*h)^2;
    eig2 =  4 - 2*(cos(pi*h)+cos(pi*h)) + 2*(pi*h)^2;
    
   
    K2 = abs(eig1)/abs(eig2); %evaluate condintion number 
    
    %run matlab pcg function and get relevant values
    [x_cg, flag, relres, pcg_itr] = pcg(A,b,tol,100000);
    
    xCG = x_cg;
    itr = pcg_itr;
    
    
end 
    
    


