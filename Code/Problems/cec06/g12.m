function [f,g,x] = g12(objnum,x)
	if nargin == 1
		prob.nx = 3;
		prob.nf = 1;
		prob.ng = 1;
        for i = 1:prob.nx
            prob.range(i,:) = [0,10];
        end
		f = prob;
	else
		[f,g] = g12_true(objnum,x);
	end
end


function [f,g] = g12_true(objnum,x)
	
f(:,objnum) = -(repmat(100,size(x,1),1) - (x(:,1)-5).^2 - (x(:,2)-5).^2 - (x(:,3)-5).^2) ./ 100;
for ii=1:size(x,1)
    sum=0;
    flag=0;
    for i = 1:9
        for j = 1:9
            for k = 1:9
                gg = 0.0625 - ((x(ii,1)-i).^2 + (x(ii,2)-j).^2 + (x(ii,3)-k).^2);
                if(gg>=0)
                    flag=1;
                    break;
                end
                sum=sum+(gg.*-1);
            end
        end
    end
    if flag == 1
        g(ii,:)=0;
    else
        g(ii,:)=sum;
    end
end
end
