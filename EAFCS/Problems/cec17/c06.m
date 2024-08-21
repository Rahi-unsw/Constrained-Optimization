function [f,g,x] = c06(objnum,x)
if nargin == 1
    prob.nx = 30;
    prob.nf = 1;
    prob.ng = 6;
    for i = 1:prob.nx
        prob.range(i,:) = [-20,20];
    end
    f = prob;
else
    [f,g] = c06_true(objnum,x);
end
end


function [f,g] = c06_true(objnum,x)
eps = 1.e-4;
global initial_flag
initial_flag = 0;
func_num = 6;
[f,c,ceq] = CEC2017(x,func_num);
ceq = abs(ceq) - eps;
g = [c,ceq];
end
