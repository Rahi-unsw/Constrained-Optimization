function [f,g,x] = c06_30(objnum,prob,x)
if nargin == 1
    prob.nx = 30;
    prob.nf = 1;
    prob.g = 0;
    prob.h = 2;
    prob.ng = 2;
    for i = 1:prob.nx
        prob.range(i,:) = [-600,600];
    end
    f = prob;
else
    [f,g] = c06_true(objnum,prob,x);
end
end


function [f,g] = c06_true(objnum,prob,x)
eps = 1.e-4;
gn = prob.g;hn = prob.h;
cfunc_num = 6;
[f,c,ceq] = cec10_cop(x, gn, hn, cfunc_num);
ceq = abs(ceq) - eps;
g = [c,ceq];
end

