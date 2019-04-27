clc
clear

sigmoid = @(x)(1./(1+exp(-x)));
rng(1);
m = 5;
A =  randn(m,2);
b = randn(m,1) > 0;
ng = 100;
xg = linspace(-20,20,ng);
yg = xg;
[xg,yg] = meshgrid(xg,yg);

zg = zeros(ng);
for i = 1:ng
    for j = 1:ng
        v = [xg(i,j); yg(i,j)];
        zg(i,j) = -(b'*log(sigmoid(A*v)+eps))-sum((1-b)'*log(1-sigmoid(A*v)+eps));
    end
end

[u,lam] = eig(A'*A);

%%

figure(2)
clf
surf(xg,yg,zg)
shading interp


figure(1)
clf
contour(xg,yg,zg)
hold on

%%

% first step, change me!
x = [-15;-15];

figure(1)
plot(x(1),x(2),'k*')
stepsize = 1/sqrt(lam(2,2));
for iter = 1:100
    z = sigmoid(A*x);
    g = A'*(z-b);
    x = x - stepsize*g;
end


