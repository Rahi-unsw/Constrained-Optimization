%% Multirun: This function is used to run specified algorithms and problems across multiple trials. 
%  Set the parameters first at the params.m file properly.
%  Check that matlab path is added properly for all functions required (Check startup.m file)
%  Now Run the function.
%%
function multirun
clc;clear all;close all;warning off;
startup;
path = cd;
count = 1;
params;

for i = 1:numel(def.allprobs)
    for k = 1:def.no_runs(i)
        disp(strcat('ParFR-EA->',' Prob->',num2str(i),' run-',num2str(k)));
        pth = strcat(cd,filesep,'Data',filesep,'Visualization',filesep,def.allprobs{i},filesep,'run-',num2str(k));
        mkdir(pth);
        cd(pth);
        def.pres_func_eval = def.all_pres_func_eval(i);
        def.problem_name = def.allprobs{i};
        def.nf = def.all_nf(i);
        def.seed = 100+k;
        def.run = k;
        save('Params.mat', 'def');
        path1{count} = pth;
        count = count+1;
        cd(path);
    end
end
cd(path);

% Run multiple parallel trials.
parfor i = 1:length(path1)
    cd(path1{i});
    disp(strcat('Running -> ',path1{i}));
    param = load('Params.mat');
    tic;
    EAFCS(param.def,path1{i});
    toc;
end
delete(gcp);
cd(path);
return