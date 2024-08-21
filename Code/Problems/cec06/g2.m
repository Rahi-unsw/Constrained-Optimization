function [f,g,x] = g2(objnum,x)
if nargin == 1
    prob.nx = 20;
    prob.nf = 1;
    prob.ng = 2;
    prob.range = zeros(prob.nx,2);
    for i = 1:prob.nx
        prob.range(i,:) = [1.e-4,10];
    end
    f = prob;
else
    [f,g] = g2_true(objnum,x);
end
return


function [f,g] = g2_true(objnum,x)
tmp1 = zeros(size(x,1),1);
tmp2 = ones(size(x,1),1);
tmp3 = zeros(size(x,1),1);
for i = 1:size(x,2)
    tmp1 = tmp1 + cos(x(:,i)).^4;
    tmp2 = tmp2 .* cos(x(:,i)).^2;
    tmp3 = tmp3 + i*x(:,i).^2;
end
f(:,objnum) = -abs((tmp1 - 2*tmp2) ./ sqrt(tmp3));
g(:,1) =  -(prod(x,2) - 0.75);
g(:,2) = -(7.5*size(x,2) - sum(x,2));                
return
