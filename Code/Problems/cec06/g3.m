function [f,g,x] = g3(objnum,x)
if nargin == 1
    prob.nx = 10;
    prob.nf = 1;
    prob.ng = 1;
    for i = 1:10
        prob.range(i,:) = [0,1];
    end
    f = prob;
else
    [f,g] = g3_true(objnum,x);
end
end


function [f,g] = g3_true(objnum,x)
x = x';eps = 1.e-4;
% Fitness function
n = 10;
f = -(sqrt(n))^n*prod(x);
f = f';

% Equality constraints
h (1,:) = sum(x.^2) - 1;
h = h';
g = abs(h) - eps;
end
