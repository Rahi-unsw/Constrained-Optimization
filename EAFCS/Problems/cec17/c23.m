function [f,g,x] = c23(objnum,x)
if nargin == 1
    prob.nx = 30;
    prob.nf = 1;
    prob.ng = 2;
    for i = 1:prob.nx
        prob.range(i,:) = [-100,100];
    end
    f = prob;
else
    [f,g] = c23_true(objnum,x);
end
end


function [f,g] = c23_true(objnum,x)
eps = 1.e-4;
global initial_flag
initial_flag = 0;
func_num = 23;
[f,c,ceq] = CEC2017(x,func_num);
ceq = abs(ceq) - eps;
g = [c,ceq];
end
