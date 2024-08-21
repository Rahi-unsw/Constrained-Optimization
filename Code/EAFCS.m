%% Code Name: EAFCS Feasibility-ratio based partial evaluation module.
%  Paper: %%%%%% 
%% Developed by Kamrul Hasan Rahi, Masters(Research) student, UNSW, Canberra, Australia;
%  E-mail: kamrul.rahi@student.unsw.edu.au; kamrulhasanme038@gmail.com;
%  Contact no: +61 444 517 342; Web: www.mdolab.net/coremembers.html
% ===========================================================================================================================================
%% Main Algorithm
function  EAFCS(def,path)
% Load the problem definition
prob = load_problem_definition(def);

% For random initialization
stream = RandStream('mt19937ar','Seed',sum(100*clock)*def.run);
RandStream.setGlobalStream(stream);

% Maximum number of function evaluation
MNFE = def.pres_func_eval*(prob.nf+prob.ng);

% Defining the upper and lower bound  of the variables
LB = prob.range(:,1)';UB=prob.range(:,2)';

% Initializing the population
X_pop = repmat(LB,def.pop_size,1)+(repmat(UB,def.pop_size,1)-repmat(LB,def.pop_size,1)).*(lhsdesign(def.pop_size,prob.nx));

% Evaluating the initial population of solutions
func = str2func(def.problem_name);
[F_pop,G_pop] = func(prob.nf,X_pop);
if(~isempty(G_pop))
    CVpop = nansum(nanmax(G_pop,0),2);
else
    G_pop=[];
    CVpop = zeros(size(G_pop,1),1);
end

% Initial control parameter for preserving solutions on constraint boundary
initial_epsilon = [mean(nanmax(G_pop,0),1),mean(CVpop)];
eps_mnfe = round(MNFE*0.6); % Epsilon tolerance is applied upto 60% evaluation budget

% Evaluation counter
[counter, cost_so_far] = cost_counter(F_pop,G_pop);
tapping_counter = [counter, cost_so_far];
sol_id = 1:size(tapping_counter,1);
% Archive stores all evaluated data
Archive = [zeros(def.pop_size,1) sol_id' X_pop F_pop G_pop CVpop tapping_counter];
curr_cost = Archive(end,end);

% Ranking
[~, X_pop, F_pop, G_pop] = RankPop(X_pop, F_pop, G_pop, initial_epsilon(1:end-1));

%% Generation Loop Starts from here
k = 1;
while curr_cost < MNFE
    % Generate offspring
    [X_child] = Generate_child(X_pop,def,prob);
    
    % Updating epsilon 
    [g_eps,~,~] = eps_tol(initial_epsilon,eps_mnfe,curr_cost);
    
    % Evaluating the offspring population
    func = str2func(def.problem_name);
    [F_child,G_child,~] = func(prob.nf,X_child);
    d_gchild = gmodify(G_child,g_eps);
    
    % Sequencing
    id_seq = SseqFRLH(Archive(:,3+prob.nx+prob.nf:2+prob.nx+prob.nf+prob.ng));
    id_seq = repmat(id_seq,size(G_child,1),1);
    
    % Partial Evaluation
    [F_child,G_child] = partial_eval(F_child,G_child,d_gchild,id_seq,prob);

    % Update the Archive
    [counter, cost_so_far] = cost_counter(F_child,G_child);
    tapping_counter_1 = [counter, cost_so_far];
    tapping_counter = tapping_counter(end,:);
    tapping_counter = repmat(tapping_counter,size(tapping_counter_1,1),1);
    tapping_counter = tapping_counter+tapping_counter_1;
    if(~isempty(G_child))
        CVchild = nansum(nanmax(G_child,0),2);
    else
        G_child = [];
        CVchild = zeros(size(G_child,1),1);
    end
    sol_id = 1:size(tapping_counter,1);
    tmp = [X_child F_child G_child CVchild tapping_counter];
    Archive = [Archive; k*ones(size(tapping_counter,1),1) sol_id' tmp];
    curr_cost = Archive(end,end);

    % Environmental selection
    X_pop = [X_pop;X_child];
    F_pop = [F_pop;F_child];
    G_pop = [G_pop;G_child];       
    [~, X_pop, F_pop, G_pop] = RankPop(X_pop, F_pop, G_pop, g_eps);
    X_pop = X_pop(1:def.pop_size,:);
    F_pop = F_pop(1:def.pop_size,:);
    G_pop = G_pop(1:def.pop_size,:);
   
    % Update the number of function evaluation
    disp(strcat(path,filesep,'generation-',num2str(k)));
    k = k+1;
end
% Extracting best solution data
F_pop = Archive(:,3+prob.nx:2+prob.nx+prob.nf);
G_pop = Archive(:,3+prob.nx+prob.nf:2+prob.nx+prob.nf+prob.ng);
[rank] = Best(F_pop, G_pop);
best = Archive(rank(1),:);

%% Save Necessary Data
save('Archive.mat','Archive','-mat');
save('best.mat','best','-mat');
return

%% Load problem definition for specific problems
function [prob] = load_problem_definition(def)
funh = str2func(def.problem_name);
prob = funh(def.nf);
return


%% This function is used to tap the number of function evaluation and it's associated cost in every generation.
function [counter,cost_so_far] = cost_counter(F_pop,G_pop)
cost_so_far = [];
counter = update_evaluation(F_pop,G_pop);
for i = 1:size(F_pop,1)
    cost(i) = sum(counter(i,:),2);
    cost_so_far = [cost_so_far;cost(i)];
end
return

%% Counting Number of function evaluation
function [counter] = update_evaluation(F_pop,G_pop)
[N, M] = size(F_pop);[O, P] = size(G_pop);
G_counter = [];F_counter = [];
c = zeros(1,P);f = zeros(1,M);
for i = 1:O
    for j = 1:P
        if isinf(G_pop(i,j)) || isnan(G_pop(i,j))
            c(:,j) = c(:,j);
        else
            c(:,j) = c(:,j)+1;
        end
    end
    G_counter = [G_counter;c];
end
for i = 1:N
    for k = 1:M
        if  isinf(F_pop(i,k)) || isnan(F_pop(i,k))
            f(:,k) = f(:,k);
        else
            f(:,k) = f(:,k)+1;
        end
        F_counter = [F_counter;f];
    end
end
counter = [F_counter, G_counter];
return


%% Finding best value 
function  [rank] = Best(F_pop, G_pop)
N = size(F_pop,1);
if ~isempty(G_pop)
    [~,M] = size(G_pop);
    G1_pop = G_pop;
    G1_pop(G1_pop <= 0) = 0;
    tmp = (G1_pop == 0);
    NS = sum(tmp,2);
    NS_max = max(NS);
    cvsum1 = nansum(G1_pop,2);
    rank = [];
    while NS_max >= 0
        if NS_max == M
            id_feas = find(NS == NS_max);
            f = F_pop(id_feas,:);
            [~,idf] = sort(f);
            f_id = id_feas(idf,:);
            rank = [rank;f_id];
            NS_max = NS_max-1;
        else
            id = find(NS == NS_max);
            if ~isempty(id)
                cv = cvsum1(id,:);
                [~,idx] = sort(cv);
                G_id = id(idx,:);
                rank = [rank;G_id];
                NS_max = NS_max-1;
            else
                NS_max = NS_max-1;
            end
        end
    end
    rank = rank(1:N,:);
else
    rank = [];
end
return


%% Ranking based on NS and CV considering epsilon
function  [rank, X_pop, F_pop, G_pop] = RankPop(X_pop, F_pop, G_pop, eps)
N = size(X_pop,1);
if ~isempty(G_pop)
    [~,M] = size(G_pop);
    G1_pop = G_pop;
    G1_pop(G1_pop <= eps) = 0;
    tmp = (G1_pop == 0);
    NS = sum(tmp,2);
    NS_max = max(NS);
    cvsum = nansum(nanmax(G_pop,0),2);
    rank = [];
    while NS_max >= 0
        if NS_max == M
            id_feas = find(NS == NS_max);
            f = [F_pop(id_feas,:),cvsum(id_feas,:)];
            [~,idf] = nd_sort(f,(1:size(f,1))');
            f_id = id_feas(idf,:);
            rank = [rank;f_id];
            NS_max = NS_max-1;
        else
            id = find(NS == NS_max);
            if ~isempty(id)
                cv = cvsum(id,:);
                [~,idx] = sort(cv);
                G_id = id(idx,:);
                rank = [rank;G_id];
                NS_max = NS_max-1;
            else
                NS_max = NS_max-1;
            end
        end
    end
    X_pop = X_pop(rank(1:N),:);
    F_pop = F_pop(rank(1:N),:);
    G_pop = G_pop(rank(1:N),:);
else
    G_pop = [];
end
return


%% Non-dominated sorting
function [fronts,idx] = nd_sort(f_all, id)
idx = [];
if isempty(f_all) 
	fronts = [];
	return
end

if nargin == 1
	id = (1:size(f_all,1))';
end

if isempty(id)
	fronts = [];
	return
end

try
	fronts = nd_sort_c(id, f_all(id,:));
catch
	warning('ND_SORT() MEX not available. Using slower matlab version.');
	fronts = nd_sort_m(id, f_all(id,:));
end
for i = 1:size(fronts,2)
    if i == 1
        [ranks, dist] = sort_crowding(f_all, fronts(i).f);
        idx = [idx;ranks];
    else
        idx = [idx;(fronts(i).f)'];
    end
end

return


%% C-implementation of non-dominated sorting
function [F] = nd_sort_c(feasible, f_all)
[frontS, frontS_n] = ind_sort2(feasible', f_all');
F = [];
for i = 1:length(feasible)
	count = frontS_n(i);
	if count > 0
		tmp = frontS(1:count, i) + 1;
		F(i).f = feasible(tmp)';
	end
end
return


%% Matlab implementation of non-dominated sorting
function [F] = nd_sort_m(feasible, f_all)

front = 1;
F(front).f = [];

N = length(feasible);
M = size(f_all,2);

individual = [];
for i = 1:N
	id1 = feasible(i);
	individual(id1).N = 0;
	individual(id1).S = [];
end

% Assignging dominate flags
for i = 1:N
	id1 = feasible(i);
	f = repmat(f_all(i,:), N, 1);
	dom_less = sum(f <= f_all, 2);
	dom_more = sum(f >= f_all, 2);
	for j = 1:N
		id2 = feasible(j);
		if dom_less(j) == M && dom_more(j) < M
			individual(id1).S = [individual(id1).S id2];
		elseif dom_more(j) == M && dom_less(j) < M
			individual(id1).N = individual(id1).N + 1;
		end
	end
end

% identifying the first front
for i = 1:N
	id1 = feasible(i);
	if individual(id1).N == 0
		F(front).f = [F(front).f id1];
	end
end

% Identifying the rest of the fronts
while ~isempty(F(front).f)
	H = [];
	for i = 1 : length(F(front).f)
		p = F(front).f(i);
		if ~isempty(individual(p).S)
			for j = 1 : length(individual(p).S)
				q = individual(p).S(j);
				individual(q).N = individual(q).N - 1;
				if individual(q).N == 0
					H = [H q];
				end
			end
		end
	end
	if ~isempty(H)
		front = front+1;
		F(front).f = H;
	else
		break
	end
end
return

%% Crowding distance
function [ranks, dist] = sort_crowding(f_all1, front_f)
f_all = f_all1;
L = length(front_f);
if L == 1
    ranks = front_f;
    dist = Inf;
else
    dist = zeros(L, 1);
    nf = size(f_all, 2);
    
    for i = 1:nf
        f = f_all(front_f, i);		% get ith objective
        [tmp, I] = sort(f);
        scale = f(I(L)) - f(I(1));
        dist(I(1)) = Inf;
        for j = 2:L-1
            id = I(j);
            id1 = front_f(I(j-1));
            id2 = front_f(I(j+1));
            if scale > 0
                dist(id) = dist(id) + (f_all(id2,i)-f_all(id1,i)) / scale;
            end
        end
    end
    dist = dist / nf;
    [tmp, I] = sort(dist, 'descend');
    ranks = front_f(I)';
end
return


%% DE crossover
function [X_Child] = Generate_child(X_pop,param,prob)
X_Child = [];tmp = X_pop(1:param.pop_size,:);
% This will autimatically generate ind1, ind2 and ind3 unique and ind1; follows the order 1:N
ind1 = 1:param.pop_size;
for i = 1:param.pop_size
    id = randperm(param.pop_size-1);
    set = setdiff(1:param.pop_size,ind1(i));
    ind2(i) = set(id(1));
    ind3(i) = set(id(2));
end
% Generate unique offspring: They are unique wrt to 2N
i=1;
while (size(X_Child,1) < param.pop_size)
    child = DE(prob,X_pop([ind1(i);ind2(i);ind3(i)],:));
    tmp1 = [tmp;child];
    [~,uni_id] = unique(tmp1,'rows','stable');
    if(length(uni_id) == size(tmp,1)+1)
        X_Child = [X_Child; child];
        tmp = [tmp;child];
        i = i+1;
    end
end
return

%% DE
function Offspring = DE(Prob,Parent)
[N,D]     = size(Parent);
[CR,F,proM,disM] = deal(0.9,0.5,1/D,30);

%% Differental evolution
Parent1Dec   = Parent(1:N/3,:);
Parent2Dec   = Parent(N/3+1:N/3*2,:);
Parent3Dec   = Parent(N/3*2+1:end,:);
Offspring = Parent1Dec;
Site = rand(N/3,D) < CR;
Offspring(Site) = Offspring(Site) + F*(Parent2Dec(Site)-Parent3Dec(Site));

%% Polynomial mutation
Site  = rand(N/3,D) < proM/D;
mu    = rand(N/3,D);
temp1 = Site & mu<=0.5;
Lower = repmat(Prob.range(:,1)',N/3,1);
Upper = repmat(Prob.range(:,2)',N/3,1);
Offspring(temp1) = Offspring(temp1)+(Upper(temp1)-Lower(temp1)).*((2.*mu(temp1)+(1-2.*mu(temp1)).*...
    (1-(Offspring(temp1)-Lower(temp1))./(Upper(temp1)-Lower(temp1))).^(disM+1)).^(1/(disM+1))-1);
temp2  = Site & mu>0.5;
Offspring(temp2) = Offspring(temp2)+(Upper(temp2)-Lower(temp2)).*(1-(2.*(1-mu(temp2))+2.*(mu(temp2)-0.5).*...
    (1-(Upper(temp2)-Offspring(temp2))./(Upper(temp2)-Lower(temp2))).^(disM+1)).^(1/(disM+1)));

temp3 = Offspring < Lower;
temp4 = Offspring > Upper;

Offspring(temp3) = Lower(temp3);
Offspring(temp4) = Upper(temp4);

id = find(isnan(Offspring));
Offspring(id) = Lower(id)+(Upper(id)-Lower(id)).*rand(1,length(id));
return


%% Controlling epsilon parameter
function [g_eps,cv_eps,cp] = eps_tol(initial_epsilon,MNFE,curr_cost)
T = MNFE;cpmin = 3;
cp = max(cpmin,(-5-log(initial_epsilon))./log(0.05));
if curr_cost>0 && curr_cost<=T
    epsilon = initial_epsilon.*(1-(curr_cost./T)).^cp;
else
    epsilon = zeros(1,length(initial_epsilon));
end
g_eps = epsilon(1:end-1);
cv_eps = epsilon(end);
return


%% Modify constraints (detecting epsilon feasible)
function g_modified = gmodify(gpop,eps)
eps(eps<0) = 0;
gpop(gpop<=eps) = 0;
g_modified = gpop;
return


%% Sequencing based on feasibility ratio
function [id_seq] = SseqFRLH(G_child)
% Calculating feasibility ratio
g = G_child;
g(g<0) = 0;
feas = (g==0);
Nfeas = sum(feas,1);
NEval = (~isnan(g));
NumberEval = sum(NEval,1);
FR = Nfeas./NumberEval;
[~,id_seq] = sort(FR);
return


%% Partial Evaluation
function [F_child_partial,G_child_partial] = partial_eval(F_child,G_child,d_gchild,id_seq,prob)
G_child_partial = [];
if ~isempty(G_child)
    for i = 1:size(G_child,1)
        g = NaN*ones(1,prob.ng);
        for j = 1:prob.ng
            G_child_val = G_child(i,id_seq(i,j));
            G_child_val1 = d_gchild(i,id_seq(i,j));
            if G_child_val1 > 0
                g(:,id_seq(i,j)) = G_child_val;
                G_child_partial(i,:) = g;
                break;
            elseif G_child_val1 <=  0
                g(:,id_seq(i,j)) = G_child_val;
                G_child_partial(i,:) = g;
            end
        end
    end
    F_child_partial = NaN*ones(length(F_child),prob.nf);
    idf = find(sum(d_gchild,2) == 0);
    F_child_partial(idf,:) = F_child(idf,:);
else
    G_child_partial = [];
    F_child_partial = F_child;
end
return
