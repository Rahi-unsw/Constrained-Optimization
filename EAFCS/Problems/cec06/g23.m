function [f,g,x] = g23(objnum,x)
if nargin == 1
    prob.nx = 9;
    prob.nf = 1;
    prob.ng = 6;
    prob.range(1,:) = [0,300];
    prob.range(2,:) = [0,300];
    prob.range(3,:) = [0,100];
    prob.range(4,:) = [0,200];
    prob.range(5,:) = [0,100];
    prob.range(6,:) = [0,300];
    prob.range(7,:) = [0,100];
    prob.range(8,:) = [0,200];
    prob.range(9,:) = [0.01,0.03];
    f = prob;
else
    [f,g] = g23_true(objnum,x);
end
end


function [f,g] = g23_true(objnum,x)
x = x';eps = 1.e-4;
% Fitness function
f = -9*x(5,:) - 15*x(8,:) + 6*x(1,:) + 16*x(2,:) + 10*(x(6,:)+x(7,:));
f = f';

% Inequality constraints
g(1,:) = x(9,:).*x(3,:) + 0.02*x(6,:) - 0.025*x(5,:);
g(2,:) = x(9,:).*x(4,:) + 0.02*x(7,:) - 0.015*x(8,:);
% Equality constraints
tmp1 = x(1,:) + x(2,:) - x(3,:) - x(4,:);
tmp2 = 0.03*x(1,:) + 0.01*x(2,:) - x(9,:).*(x(3,:)+x(4,:));
tmp3 = x(3,:) + x(6,:) - x(5,:);
tmp4 = x(4,:) + x(7,:) - x(8,:);
g(3,:) = abs(tmp1) - eps;
g(4,:) = abs(tmp2) - eps;
g(5,:) = abs(tmp3) - eps;
g(6,:) = abs(tmp4) - eps;
g = g';
end
