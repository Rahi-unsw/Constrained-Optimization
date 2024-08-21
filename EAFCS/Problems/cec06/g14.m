function [f,g,x] = g14(objnum,x)
if nargin == 1
    prob.nx = 10;
    prob.nf = 1;
    prob.ng = 3;
    for i = 1:prob.nx
        prob.range(i,:) = [1.e-10,10];
    end
    f = prob;
else
    [f,g] = g14_true(objnum,x);
end
end


function [f,g] = g14_true(objnum,x)
x = x';eps = 1e-4;
% Fitness function
c = [-6.089 -17.164 -34.054 -5.914 -24.721 -14.986 -24.1 -10.708 -26.662 -22.179];
den = sum(x);
n_i = size (x, 2);
f = zeros (1, n_i);
for i=1:n_i
    f(i) = sum(x(:,i) .* (c' + log(x(:,i)/den(i))));
end
f = f';

% Equality constraints
tmp1 = x(1,:) + 2*x(2,:) + 2*x(3,:) + x(6,:) + x(10,:) - 2;
tmp2 = x(4,:) + 2*x(5,:) + x(6,:) + x(7,:) - 1;
tmp3 = x(3,:) + x(7,:) + x(8,:) + 2*x(9,:) + x(10,:) - 1;
g(1,:) = abs(tmp1) - eps;
g(2,:) = abs(tmp2) - eps;
g(3,:) = abs(tmp3) - eps;
g = g';
end
