function [f,g,x] = c17_30(objnum,prob,x)
if nargin == 1
    prob.nx = 30;
    prob.nf = 1;
    prob.g = 2;
    prob.h = 1;
    prob.ng = 3;
    for i = 1:prob.nx
        prob.range(i,:) = [-10,10];
    end
    f = prob;
else
    [f,g] = c17_true(objnum,prob,x);
end
end


function [f,g] = c17_true(objnum,prob,x)
eps = 1.e-4;
gn = prob.g;hn = prob.h;
cfunc_num = 17;
[f,c,ceq] = cec10_cop(x, gn, hn, cfunc_num);
ceq = abs(ceq) - eps;
g = [c,ceq];
end

