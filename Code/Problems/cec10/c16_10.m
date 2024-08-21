function [f,g,x] = c16_10(objnum,prob,x)
if nargin == 1
    prob.nx = 10;
    prob.nf = 1;
    prob.g = 2;
    prob.h = 2;
    prob.ng = 4;
    for i = 1:prob.nx
        prob.range(i,:) = [-10,10];
    end
    f = prob;
else
    [f,g] = c16_true(objnum,prob,x);
end
end


function [f,g] = c16_true(objnum,prob,x)
eps = 1.e-4;
gn = prob.g;hn = prob.h;
cfunc_num = 16;
[f,c,ceq] = cec10_cop(x, gn, hn, cfunc_num);
ceq = abs(ceq) - eps;
g = [c,ceq];
end

