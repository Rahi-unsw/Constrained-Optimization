function [f,g,x] = g21(objnum,x)
if nargin == 1
    prob.nx = 7;
    prob.nf = 1;
    prob.ng = 6;
    prob.range(1,:) = [0,1000];
    prob.range(2,:) = [0,40];
    prob.range(3,:) = [0,40];
    prob.range(4,:) = [100,300];
    prob.range(5,:) = [6.3,6.7];
    prob.range(6,:) = [5.9,6.4];
    prob.range(7,:) = [4.5,6.25];
    f = prob;
else
    [f,g] = g21_true(objnum,x);
end
end


function [f,g] = g21_true(objnum,x)
x = x';eps = 1.e-4;
% Fitness function
f = x(1,:);
f = f';

% Inequality constraints
g(1,:) = -x(1,:) + 35*x(2,:).^0.6 + 35*x(3,:).^0.6;
% Equality constraints
tmp1 = -300*x(3,:) + 7500*x(5,:) - 7500*x(6,:) - 25*x(4,:).*x(5,:) + 25*x(4,:).*x(6,:) + x(3,:).*x(4,:);
tmp2 = 100*x(2,:) + 155.365*x(4,:) + 2500*x(7,:) - x(2,:).*x(4,:) - 25*x(4,:).*x(7,:) - 15536.5;
tmp3 = -x(5,:) + log(-x(4,:)+900);
tmp4 = -x(6,:) + log(x(4,:)+300);
tmp5 = -x(7,:) + log(-2*x(4,:)+700);
g(2,:) = abs(tmp1) - eps;
g(3,:) = abs(tmp2) - eps;
g(4,:) = abs(tmp3) - eps;
g(5,:) = abs(tmp4) - eps;
g(6,:) = abs(tmp5) - eps;
g = g';
end
