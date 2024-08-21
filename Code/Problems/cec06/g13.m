function [f,g,x] = g13(objnum,x)
if nargin == 1
    prob.nx = 5;
    prob.nf = 1;
    prob.ng = 3;
    prob.range(1,:) = [-2.3,2.3];
    prob.range(2,:) = [-2.3,2.3];
    prob.range(3,:) = [-3.2,3.2];
    prob.range(4,:) = [-3.2,3.2];
    prob.range(5,:) = [-3.2,3.2];
    f = prob;
else
    [f,g] = g13_true(objnum,x);
end
end


function [f,g] = g13_true(objnum,x)
x = x';eps = 1.e-4;
% Fitness function
f = exp(x(1,:).*x(2,:).*x(3,:).*x(4,:).*x(5,:));
f = f';

% Equality constraints
tmp1 = x(1,:).^2 + x(2,:).^2 + x(3,:).^2 + x(4,:).^2 + x(5,:).^2 - 10;
tmp2 = x(2,:).*x(3,:) - 5*x(4,:).*x(5,:);
tmp3 = x(1,:).^3 + x(2,:).^3 + 1;
g(1,:) = abs(tmp1) - eps;
g(2,:) = abs(tmp2) - eps;
g(3,:) = abs(tmp3) - eps;
g = g';
end
