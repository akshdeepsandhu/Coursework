
%%

%%Question 3
%Build a solver for any penta-diagaonal system (assume not always
%symmetric) 
% Used textbook tridiagonal algorith and this website as a reference http://www.math.uakron.edu/~kreider/anpde/penta.f
d1 = [ 8    16    24    32    40    48];
d2 = [-2    -4    -6    -8   -10];
d3 = [-2    -4    -6    -8   -10];
d4 = [1     2     3     4];
d5 = [1     2     3     4];
b = [ 7    12    18    24    25    42]' ;
n = 6;

eXact = [1 1 1 1 1 1]';
A = [8 -2 1 0 0 0; -2 16 -4 2 0 0 ; 1 -4 24 -6 3 0; 0 2 -6 32 -8 4; 0 0 3 -8 40 -10; 0 0 0 4 -10 48];
b = A*eXact;

x =pentasolver(d1,d2,d3,d4,d5,b,n); 

norm(eXact - x,2);

function x = pentasolver(d1,d2,d3,d4,d5,b,n)
% A function that solves a penta-diagonal system in O(n) flops. i.e. solves
% Ax=b for x. This procedure will only work in the input parameters are in
% the sepicfied order below. The function returns a soltuion vector x.
% Assume no pivoting is required.
% the order given below
% @param d1: main diagonal size n
% @param d2: first sub-diagonal size n-1
% @param d3: first super-diagonal size n-1
% @param d4: second sub-diagonal size n-2
% @param d5: second super-diagonal size n-2
% @param b: b-vector in the given system Ax=b
% @param n: size of system (i.e. number of rows)
% @return x: return vector of solutions 

for i = 2:n-1
    %get multiplier value
    L1 = d2(i-1)/d1(i-1);
    d1(i) = d1(i) - L1*d3(i-1);
    d3(i) = d3(i) - L1*d5(i-1);
    b(i) = b(i) - L1*b(i-1);
    L2 = d4(i-1)/d1(i-1);
    d2(i) = d2(i) - L2*d3(i-1);
    d1(i+1) = d1(i+1) - L2*d5(i-1);
    b(i+1) = b(i+1) - L2*b(i-1);
end
L3 = d2(n-1)/d1(n-1);
d1(n) = d1(n)-L3*d3(n-1);
x(n) = (b(n) - L3*b(n-1))/d1(n);
x(n-1) = (b(n-1) - d3(n-1)*x(n))/d1(n-1);

for i = n-2:-1:1
    x(i)= (b(i) - d5(i)*x(i+2) - d3(i)*x(i+1))/d1(i) ;
end


end 
%%

