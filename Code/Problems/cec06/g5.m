function [f,g,x] = g5(objnum,x)
if nargin == 1
    prob.nx = 4;
    prob.nf = 1;
    prob.ng = 5;
    prob.range(1,:) = [0,1200];
    prob.range(2,:) = [0,1200];
    prob.range(3,:) = [-0.55,0.55];
    prob.range(4,:) = [-0.55,0.55];
    f = prob;
else
    [f,g] = g5_true(objnum,x);
end
end


function [f,g] = g5_true(objnum,x)
x = x';eps = 1.e-4;
% Fitness function
f = 3*x(1,:) + 0.000001*x(1,:).^3 + 2*x(2,:) + (0.000002/3)*x(2,:).^3;
f = f';

% Inequality constraints
g(1,:) = -x(4,:) + x(3,:) - 0.55;
g(2,:) = -x(3,:) + x(4,:) - 0.55;
% Equality constraints
tmp1 = 1000*sin(-x(3,:)-0.25) + 1000*sin(-x(4,:)-0.25) + 894.8 - x(1,:);
tmp2 = 1000*sin(x(3,:)-0.25) + 1000*sin(x(3,:)-x(4,:)-0.25) + 894.8 - x(2,:);
tmp3 = 1000*sin(x(4,:)-0.25) + 1000*sin(x(4,:)-x(3,:)-0.25) + 1294.8;
g(3,:) = abs(tmp1) - eps;
g(4,:) = abs(tmp2) - eps;
g(5,:) = abs(tmp3) - eps;
g = g';
end
