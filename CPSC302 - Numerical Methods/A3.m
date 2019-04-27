%% Assignment 3
% Akshdeep Sandhu
%SN: 20665148
%(2a)
%Fixed point iteration

g=@(x) ((1-x)*sqrt(3+x))/(sqrt(1+x)*3.06)

x1 = 0
x2 = g(x1)

num_its = 0 %number of iterations

ezplot(g,[0,5]);
hold on
ezplot('x', [[0,5]])

while(abs(x2-x1) > 10e-6 && num_its < 100)
    plot([x1 x1], [x1 x2], 'k-')
    plot([x1 x2], [x2 x2], 'k--')

    num_its = num_its + 1;
    x1 = x2;
    x2 = g(x1);

end

num_its
%remove semicolon to produce output

[x1 x2];

%%
%2b
% Newtowns method function

[x_1, xvals_1] = newton(1,10e-10, 50);
[x_2, xvals_2] = newton(0.3,10e-10,50);

t1 = [array2table(xvals_1', 'VariableNames',{'x0_1'})];
t2 = [array2table(xvals_2', 'VariableNames',{'x0_03'})];
%remove semicolon to produce table output
t1;
t2;


%%
%3a
% rootfunc(a,p,X0)
%run this for different values of a,p and x0
[k,f,x] = rootfunc(0,2,2);
A = [k;f;x];
T = array2table(A');
T.Properties.VariableNames = {'k','f','x'};
T;









%% Section containg functions used
function [x, xvals] = newton(x0, tol, nmax)
    %function implenting newtons method
    % x0 is the initial point
    %tol is the tolerance
    %nmax is the maximum number of iterations

    x = x0;
    n = 1;
    diff = 1;
    xvals = [];
    while diff >= tol && n <= nmax
        xnew = x;
        x = x - (((1-x)^2)*(3+x) - (3.06^2)*(x^2)*(x+1))/(-25.0908*x^2 - 16.7272*x-5);
        diff = abs(x - xnew);
        n = n + 1;
        xvals = [xvals,x];
    end

end



function [k_vals,f_vals,x_vals] = rootfunc(a,p,X0)
%function to calculate the p-th root for a given value a
%a - value
%p-root
%x0 - intial guess

Xk=X0;
fd= p*Xk^(p-1);
f=(Xk^p)-a;
k = 0;
k_vals = [];
f_vals = [];
x_vals = [];
while abs(Xk^p - a) >= 10^(-8) && k < 50

    Xk1 = Xk - f/fd;
    Xk = Xk1;
    fd = p*Xk^(p-1);
    f = (Xk^p)-a;
    %increment iteration counter
    k = k+1;
    %add values to appropriate arrays
    k_vals = [k_vals,k];
    f_vals = [f_vals, f];
    x_vals = [x_vals,Xk];

end



end







