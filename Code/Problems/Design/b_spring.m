function [f,g,x] = b_spring(objnum,x)
if nargin == 1
    prob.nx = 4;
    prob.nf = 1;
    prob.ng = 7;
    prob.range = zeros(prob.nx,2);
    prob.range(1,:) = [5.0,15.0];
    prob.range(2,:) = [5.0,15.0];
    prob.range(3,:) = [0.01,6.0];
    prob.range(4,:) = [0.05,0.5];
    f = prob;
else
    [f,g] = b_spring_true(objnum,x);
end
return

function [f,g] = b_spring_true(objnum,x)

pi = 3.14159;

D_e = x(:,1);
D_i = x(:,2);
t = x(:,3);
h = x(:,4);

P_max = 5400;		% lb
delta_max = 0.2;	% in
D_max = 12.01;		% in
sigma_D = 200e3;	% psi
l = 2.0;			% in

E = 30e6;			% psi
mu = 0.3;			% poisson ratio for steel


K = D_e ./ D_i;
alpha = (6 ./ (pi * log(K))) .* ((K-1)./K).^2;
beta = (6 ./ (pi * log(K))) .* (((K-1)./log(K)) - 1);
gamma = (6 ./ (pi * log(K))) .* ((K-1)./2);

a = D_e ./ 2;
sigma = ((E*delta_max) ./ ((1-mu^2).*alpha.*a.^2)) .* ((beta.*(h - delta_max/2)) + (gamma.*t));

P = ((E*delta_max) ./ ((1-mu^2).*alpha.*a.^2)) .* (((h-delta_max/2).*(h-delta_max).*t) + t.^3);

aa_pt = 1.4:0.1:2.8;
fa_pt = [1 0.85 0.77 0.71 0.66 0.63 0.60 0.58 0.56 0.55 0.53 0.52 0.51 0.51 0.50];
aa = h./t;
for i=1:size(x,1)
    if aa(i,:) < 1.4
        fa(i,:) = 1;
    elseif aa(i,:) > 2.8
        fa(i,:) = 0.5;
    else
        fa(i,:) = spline(aa_pt, fa_pt, aa(i,:));
    end
end
delta_l = fa .* h;

g(:,1) = -(sigma_D - sigma);
g(:,2) = -(P - P_max);
g(:,3) = -(delta_l - delta_max);
g(:,4) = -(l - h - t);
g(:,5) = -(D_max - D_e);
g(:,6) = -(D_e - D_i);
g(:,7) = -(0.3 - (h./(D_e-D_i)));

f(:,objnum) = (0.283*pi./4) .* ((D_e.^2 - D_i.^2).*t);

return
