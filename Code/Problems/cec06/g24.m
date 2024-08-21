function [f,g,x] = g24(objnum,x)
if nargin == 1
    prob.nx = 2;
    prob.nf = 1;
    prob.ng = 2;
    prob.range(1,:) = [0,3];
    prob.range(2,:) = [0,4];
    f = prob;
else
    [f,g] = g24_true(objnum,x);
end
return

function [f,g] = g24_true(objnum,x)

g(:,1)=-2*x(:,1).^4+8*x(:,1).^3-8*x(:,1).^2+x(:,2)-2;
g(:,2)=-4*x(:,1).^4+32*x(:,1).^3-88*x(:,1).^2+96*x(:,1)+x(:,2)-36;

f(:,objnum) =-x(:,1)-x(:,2);

return