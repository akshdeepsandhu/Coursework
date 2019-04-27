%Assignment 1
%Akshdeep Sandhu
%SN: 20665148


%%
%1b:

x0 = 1.2;
f0 = sin(x0);
fp = cos(x0);
i = -20:0.5:0;
h = 10.^i;
err = abs (fp - (sin(x0+h) - sin(x0-h))./(2*h));
%d_err may not be neccesary but is there just for fun
d_err = (fp/6)*(h.^2);
loglog (h,err,'-*');
hold on
loglog (h,d_err,'r-.');
xlabel('h')
ylabel('Absolute error')
axis([10^(-20) 1 10^(-15) 1])


%%
%3a
format short g

input_vector = logspace(-12,0, 13); %create input values
%display 13x3 matrix |theta|H1(theta)|H2(theta)|
[input_vector; H1(input_vector); H2(input_vector)]' 

%%
%3b

%get errors
abs_error = abs(H1(input_vector)-H2(input_vector));
rel_error = abs_error./abs(H1(input_vector)) ;

%produce log-log plot 
loglog(input_vector,abs_error,'r-*');
hold on 
loglog(input_vector, rel_error, 'b-*');
xlabel('\theta')
ylabel('Error')
legend('Absolute error', 'Relative error')


%%
%3c
%p1 = (phi1, lambda1) p2 = (phi2, lambda2)
R = 6371.0088;

%input values are in degrees 
p1 = [49.261245 , 123.248109];
p2 = [49.266772,  123.249843]; 

format long
%call functions
ans_d1 = D1(p1(1), p1(2), p2(1),p2(2), R)
ans_d2 = D2(p1(1), p1(2), p2(1),p2(2), R)
error = abs(ans_d1 - ans_d2)

%%
%Section containing function defintions 



function y1 = H1(theta)
% assume theta is in degrees

y1 = sind(theta/2).^2;
end

function y2 = H2(theta)
% asusme theta is in degrees
y2 = 1/2*(1-cosd(theta));
end

function y3 = D1(phi1, lambda1, phi2,lambda2, R)
%function inputs are in degrees. Returns the length between two points in
%km. The arcsine function must return a value in radians. 
x = sqrt(H1(phi2-phi1) + cosd(phi1)*cosd(phi2)*H1(lambda2-lambda1));
y3 = 2*R*deg2rad(asind(x));
end

function y4 = D2(phi1, lambda1, phi2,lambda2, R)
%function inputs are in degrees. Returns the length between two points in
%km. The arccos functon must return a value in radians. 
x = sind(phi1)*sind(phi2) + cosd(phi1)*cosd(phi2)*cosd(lambda2-lambda1);
y4 = R*deg2rad(acosd(x));
end
%%





