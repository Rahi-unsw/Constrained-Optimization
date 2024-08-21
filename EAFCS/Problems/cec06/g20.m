function [f,g,x] = g20(objnum,x)
if nargin == 1
    prob.nx = 24;
    prob.nf = 1;
    prob.ng = 20;
    for i = 1:prob.nx
        prob.range(i,:) = [0,10];
    end
    f = prob;
else
    [f,g] = g20_true(objnum,x);
end
end


function [f,g] = g20_true(objnum,x)
x = x';eps = 1.e-4;
a = [0.0693 0.0577 0.05 0.2 0.26 0.55 0.06 0.1 0.12 0.18 0.1 0.09 0.0693 0.0577 0.05 0.2 0.26 0.55 0.06 0.1 0.12 0.18 0.1 0.09];
b = [44.094 58.12 58.12 137.4 120.9 170.9 62.501 84.94 133.425 82.507 46.07 60.097 44.094 58.12 58.12 137.4 120.9 170.9 62.501 84.94 133.425 82.507 46.07 60.097];
c = [123.7 31.7 45.7 14.7 84.7 27.7 49.7 7.1 2.1 17.7 0.85 0.64];
d = [31.244 36.12 34.784 92.7 82.7 91.6 56.708 82.7 80.8 64.517 49.4 49.1];
e = [0.1 0.3 0.4 0.3 0.6 0.3];

k = (0.7302)*(530)*(14.7/40);

n_i = size(x, 2);
f_x = zeros (1, n_i);
g1 = zeros (6, n_i);
h = zeros (14, n_i);

% Fitness function
for i=1 : n_i
    f_x(i) = sum(a'.*x(:,i));
    
    % Inequality constraints
    sum_t = sum(x(:,i));
    for j=1:3
        g1(j,i) = ((x(j,i) + x(j+12,i)))/(sum_t+e(j));
    end
    for j=4:6
        g1(j,i) = ((x(j+3,i) + x(j+15,i)))/(sum_t+e(j));
    end
    
    % Equality contraints
    sum_t1 = sum(x(13:24,i)./b(13:24)');
    sum_t2 = sum(x(1:12,i)./b(1:12)');
    for j=1 : 12
        h(j,i) = (x(j+12,i)/(b(j+12)*sum_t1))-((c(j)*x(j,i))./(40*b(j)*sum_t2));
    end
    h(13,i) = sum_t - 1;
    h(14,i) = sum(x(1:12,i)./d')+k*sum(x(13:24,i)./b(13:24)')-1.671;
end
f = f_x';
g2 = abs(h) - eps;
g = [g1',g2'];
end
