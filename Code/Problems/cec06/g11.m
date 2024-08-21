function [f,g,x] = g11(objnum,x)
if nargin == 1
    prob.nx = 2;
    prob.nf = 1;
    prob.ng = 1;
    prob.range(1,:) = [-1,1];
    prob.range(2,:) = [-1,1];
    f = prob;
else
    [f,g] = g11_true(objnum,x);
end
end


function [f,g] = g11_true(objnum,x)
x = x';eps = 1.e-4;
% Fitness function
f = x(1,:).^2+(x(2,:)-1).^2;
f = f';

% Equality constraints
tmp1 = x(2,:) - x(1,:).^2;
g(1,:) = abs(tmp1) - eps;
g = g';
end
