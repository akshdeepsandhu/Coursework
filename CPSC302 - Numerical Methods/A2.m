%%
% x is a global variable defining the interval [1.96,2.08] 
x = 1.94:0.001:2.08;
%%
%(3a)(i) Nested evaluation method

coef = [1, -18, 144, -672, 2016, -4032, 5376, -4608, 2304, -512];
sol = nested_horner(coef,x);
plot(x,sol)
xlabel("x")
ylabel("f1(x)")
title("Evaluating f1(x) via nested evaluation"); 
axis tight
%%
%(3a)(ii) Direct evaluation 

f2 = (x-2).^9;
plot(x,f2)
xlabel("x")
ylabel("f2(x)")
title("Evaluating f2(x) directly"); 
axis tight
%%
%(3a)(iii) Mononomial evaulation 

f3 = x.^9 - 18*x.^8 + 144*x.^7 - 672*x.^6 + 2016*x.^5 -4032*x.^4 + 5376*x.^3 - 4608*x.^2 + 2304*x - 512;
plot(x,f3)
xlabel("x")
ylabel("f3(x)")
title("Mononomial evaluation of f3(x) "); 
axis tight





%% Functions

function x = nested_horner(coef,vals)
%function that preforms the nested evaluation 
%coef is a vector of polynomial coefficents
%vals is a vector of values that will be evaluated

n = length(coef);
m = length(vals);
result = coef(1)*ones(1,m);
for j = 2:n
    result = result.*vals + coef(j);
end
x = result;
end 



