function [f,g,x] = c18(objnum,x)
if nargin == 1
    prob.nx = 30;
    prob.nf = 1;
    prob.ng = 3;
    for i = 1:prob.nx
        prob.range(i,:) = [-100,100];
    end
    f = prob;
else
    [f,g] = c18_true(objnum,x);
end
end


function [f,g] = c18_true(objnum,x)
eps = 1.e-4;
global initial_flag
initial_flag = 0;
func_num = 18;
[f,c,ceq] = CEC2017(x,func_num);
ceq = abs(ceq) - eps;
g = [c,ceq];
end
