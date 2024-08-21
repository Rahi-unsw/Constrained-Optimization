function [f,g,x] = test_prob(objnum,x)
	if nargin == 1
		prob.nx = 2;
		prob.nf = 1;
		prob.ng = 4;
		prob.range(1,:) = [-5.12,5.12];
		prob.range(2,:) = [-5.12,5.12];
		f = prob;
	else
		[f,g] = test_prob_true(objnum,x);
	end
end


function [f,g] = test_prob_true(objnum,x)
	f(:,objnum) = 3*(1-x(:,1)).^2.*exp(-(x(:,1).^2) - (x(:,2)+1).^2) ...
    - 10*(x(:,1)./5 - x(:,1).^3 - x(:,2).^5).*exp(-x(:,1).^2-x(:,2).^2) ...
    - 1/3*exp(-(x(:,1)+1).^2 - x(:,2).^2);
	g(:,1) = (x(:,1).^2)+(x(:,2).^2)-2;
	g(:,2) = 0.3724.*x(:,1)+x(:,2);
	g(:,3) = (25.*(sin(x(:,1))).^2)+x(:,1).^2+(x(:,1).*x(:,2))-10;
	g(:,4) = sin(x(:,2))+(cos(x(:,1))).^2;
end
