function [f,g,x] = c09_10(objnum,prob,x)
if nargin == 1
    prob.nx = 10;
    prob.nf = 1;
    prob.g = 0;
    prob.h = 1;
    prob.ng = 1;
    for i = 1:prob.nx
        prob.range(i,:) = [-500,500];
    end
    f = prob;
else
    [f,g] = c09_true(objnum,prob,x);
end
end


function [f,g] = c09_true(objnum,prob,x)
eps = 1.e-4;
gn = prob.g;hn = prob.h;
cfunc_num = 9;
[f,c,ceq] = cec10_cop(x, gn, hn, cfunc_num);
ceq = abs(ceq) - eps;
g = [c,ceq];
end

