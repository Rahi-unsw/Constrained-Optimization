function [f,g,x] = g15(objnum,x)
if nargin == 1
    prob.nx = 3;
    prob.nf = 1;
    prob.ng = 2;
    for i = 1:prob.nx
        prob.range(i,:) = [0,10];
    end
    f = prob;
else
    [f,g] = g15_true(objnum,x);
end
end


function [f,g] = g15_true(objnum,x)
x = x';eps = 1.e-4;
% Fitness function
f = 1000 - x(1,:).^2 - 2*x(2,:).^2 - x(3,:).^2 - x(1,:).*x(2,:) - x(1,:).*x(3,:);
f = f';

% Equality constraints
tmp1 = x(1,:).^2 + x(2,:).^2 + x(3,:).^2 - 25;
tmp2 = 8*x(1,:) + 14*x(2,:) + 7*x(3,:) - 56;
g(1,:) = abs(tmp1) - eps;
g(2,:) = abs(tmp2) - eps;
g = g';
end
