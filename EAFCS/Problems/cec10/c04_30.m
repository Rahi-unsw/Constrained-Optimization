function [f,g,x] = c04_30(objnum,prob,x)
if nargin == 1
    prob.nx = 30;
    prob.nf = 1;
    prob.g = 0;
    prob.h = 4;
    prob.ng = 4;
    for i = 1:prob.nx
        prob.range(i,:) = [-50,50];
    end
    f = prob;
else
    [f,g] = c04_true(objnum,prob,x);
end
end


function [f,g] = c04_true(objnum,prob,x)
eps = 1.e-4;
gn = prob.g;hn = prob.h;
cfunc_num = 4;
[f,c,ceq] = cec10_cop(x, gn, hn, cfunc_num);
ceq = abs(ceq) - eps;
g = [c,ceq];
end


