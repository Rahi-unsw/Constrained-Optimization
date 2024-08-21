function [f,g,x] = vessel(objnum,x)
if nargin == 1
    prob.nx = 4;
    prob.nf = 1;
    prob.ng = 3;
    prob.range = zeros(prob.nx,2);
    prob.range(1,:) = [0,1];
    prob.range(2,:) = [0,1];
    prob.range(3,:) = [0,50];
    prob.range(4,:) = [0,240];
    f = prob;
else
    [f,g] = vessel_true(objnum,x);
end
return
function [f,g] = vessel_true(objnum,x)

g(:,1) = -(x(:,1) - 0.0193*x(:,3));
g(:,2) = -(x(:,2) - 0.00954*x(:,3));
temp = -((pi*x(:,3).^2.*x(:,4)) + (4/3*pi*x(:,3).^3) - 1296000);
for i = 1:numel(temp)
    if temp(i) >= 0
        g(i,3) = log(1+temp(i));
    else
        g(i,3) = -log(1-temp(i));
    end
end

f(:,objnum) = (0.6224*x(:,1).*x(:,3).*x(:,4)) + (1.7781*x(:,2).*x(:,3).^2) + (3.1661*x(:,1).^2.*x(:,4)) + (19.84*x(:,1).^2.*x(:,3));
return
