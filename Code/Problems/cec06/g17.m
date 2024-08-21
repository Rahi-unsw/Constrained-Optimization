function [f,g,x] = g17(objnum,x)
if nargin == 1
    prob.nx = 6;
    prob.nf = 1;
    prob.ng = 4;
    prob.range(1,:) = [0,400];
    prob.range(2,:) = [0,1000];
    prob.range(3,:) = [340,420];
    prob.range(4,:) = [340,420];
    prob.range(5,:) = [-1000,1000];
    prob.range(6,:) = [0,0.5236];
    f = prob;
else
    [f,g] = g17_true(objnum,x);
end
end


function [f,g] = g17_true(objnum,x)
x = x';eps = 1.e-4;
% Fitness function
n_i = size (x, 2);
f_x = zeros (1, n_i);
for i=1 : n_i
    if x(1,i)>=0 && x(1,i)<300
        fx_1 = 30*x(1,i);
    else
        fx_1 = 31*x(1,i);
    end
    
    if x(2,i)>=0 && x(2,i)<100
        fx_2 = 28*x(2,i);
    elseif x(2,i)>=100 && x(2,i)<200
        fx_2 = 29*x(2,i);
    else
        fx_2 = 30*x(2,i);
    end
    f_x(i) = fx_1 + fx_2;
end
f = f_x';

% Equality constraints
tmp1 = -x(1,:) + 300 - ((x(3,:).*x(4,:))/131.078).*cos(1.48477-x(6,:)) + ((0.90798*x(3,:).^2)/131.078)*cos(1.47588);
tmp2 = -x(2,:) - ((x(3,:).*x(4,:))/131.078).*cos(1.48477+x(6,:)) + ((0.90798*x(4,:).^2)/131.078)*cos(1.47588);
tmp3 = -x(5,:) - ((x(3,:).*x(4,:))/131.078).*sin(1.48477+x(6,:)) + ((0.90798*x(4,:).^2)/131.078)*sin(1.47588);
tmp4 = 200 - ((x(3,:).*x(4,:))/131.078).*sin(1.48477-x(6,:)) + ((0.90798*x(3,:).^2)/131.078)*sin(1.47588);
g(1,:) = abs(tmp1) - eps;
g(2,:) = abs(tmp2) - eps;
g(3,:) = abs(tmp3) - eps;
g(4,:) = abs(tmp4) - eps;
g = g';
end
