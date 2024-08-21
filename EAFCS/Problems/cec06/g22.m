function [f,g,x] = g22(objnum,x)
if nargin == 1
    prob.nx = 22;
    prob.nf = 1;
    prob.ng = 20;
    prob.range(1,:) = [0,20000];
    for i = 2:4
        prob.range(i,:) = [0,1e6];
    end
    for i = 5:7
        prob.range(i,:) = [0,4e7];
    end
    prob.range(8,:) = [100,299.99];
    prob.range(9,:) = [100,399.99];
    prob.range(10,:) = [100.01,300];
    prob.range(11,:) = [100,400];
    prob.range(12,:) = [100,600];
    for i = 13:15
        prob.range(i,:) = [0,500];
    end
    prob.range(16,:) = [0.01,300];
    prob.range(17,:) = [0.01,400];
    for i = 18:22
        prob.range(i,:) = [-4.7,6.25];
    end
    f = prob;
else
    [f,g] = g22_true(objnum,x);
end
end


function [f,g] = g22_true(objnum,x)
x = x';eps = 1.e-4;
% Fitness function
f = x(1,:);
f = f';

% Inequality constraints
g(1,:) = -x(1,:) + x(2,:).^0.6 + x(3,:).^0.6 + x(4,:).^0.6;

% Equality constraints
g(2,:) = abs(x(5,:) - 100000*x(8,:) + 1e7) - eps;
g(3,:) = abs(x(6,:) + 100000*x(8,:) - 100000*x(9,:)) - eps;
g(4,:) = abs(x(7,:) + 100000*x(9,:) - 5e7) - eps;
g(5,:) = abs(x(5,:) + 100000*x(10,:) - 3.3e7) - eps;
g(6,:) = abs(x(6,:) + 100000*x(11,:) - 4.4e7) - eps;
g(7,:) = abs(x(7,:) + 100000*x(12,:) - 6.6e7) - eps;
g(8,:) = abs(x(5,:) - 120*x(2,:).*x(13,:)) - eps;
g(9,:) = abs(x(6,:) - 80*x(3,:).*x(14,:)) - eps;
g(10,:) = abs(x(7,:) - 40*x(4,:).*x(15,:)) - eps;
g(11,:) = abs(x(8,:) - x(11,:) + x(16,:)) - eps;
g(12,:) = abs(x(9,:) - x(12,:) + x(17,:)) - eps;
g(13,:) = abs(-x(18,:) + log(x(10,:)-100)) - eps;
g(14,:) = abs(-x(19,:) + log(-x(8,:)+300)) - eps;
g(15,:) = abs(-x(20,:) + log(x(16,:))) - eps;
g(16,:) = abs(-x(21,:) + log(-x(9,:)+400)) - eps;
g(17,:) = abs(-x(22,:) + log(x(17,:))) - eps;
g(18,:) = abs(-x(8,:) - x(10,:) + x(13,:).*x(18,:) - x(13,:).*x(19,:) + 400) - eps;
g(19,:) = abs(x(8,:) - x(9,:) - x(11,:) + x(14,:).*x(20,:) - x(14,:).*x(21,:) + 400) - eps;
g(20,:) = abs(x(9,:) - x(12,:) - 4.60517*x(15,:) + x(15,:).*x(22,:) + 100) - eps;

g = g';
end
