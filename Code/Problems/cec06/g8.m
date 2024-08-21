function [f,g,x] = g8(objnum,x)
if nargin == 1
    prob.nx = 2;
    prob.nf = 1;
    prob.ng = 2;
    prob.range(1,:) = [0,10];
    prob.range(2,:) = [0,10];
    f = prob;
else
    [f,g] = g8_true(objnum,x);
end
return


function [f,g] = g8_true(objnum,x)

g(:,1) = -(-x(:,1).^2 + x(:,2) - 1);
g(:,2) = -(-1 + x(:,1) - (x(:,2)-4).^2);
f(:,objnum) = - sin(2*pi*x(:,1)).^3 .* sin(2*pi*x(:,2)) ./ (x(:,1).^3 .* (x(:,1)+x(:,2)));
return
