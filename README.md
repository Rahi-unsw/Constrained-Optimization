# Constrained-Optimization
Evolutionary algorithm embedded with bump-hunting for constrained design optimization

Please cite the following papers if you use this algorithm.

1. Rahi, K. H., Singh, H. K., & Ray, T. Evolutionary algorithm embedded with bump-hunting for constrained design optimization; 
   ASME Transaction of Mechanical Design, May 2020. 
2. Rahi, K. H., Singh, H. K., & Ray, T. (2019, June). Expediting the convergence of evolutionary algorithms by identifying
   promising regions of the search space; in the proceedings of The Genetic and Evolutionary Computation Conference (GECCO);
   July 8th – 12th 2020 @ Cancun, Mexico.


%%%%%Steps to run the code%%%%%%%%%%%%

1. Go to the startup.m just to check both 'Problems' and 'mex' folders are added correctly. If you just keep 'BumpEA-ID' folder name
   unchanged, you don't need to change anything.
2. Go to params.m script. You can specify all the parameters. The demo parameters for g-series and engineering design problems are 
   given. Please, write the problem scripts (g1.m, g2.m in the 'Problems' folder accordingly). All the parameters are kept in the 
   'def' structure.
3. Open the 'mex' folder as your current folder. In the matlab command prompt, write mex('ind_sort2.c'). If mex file is built
   successfully, return to the BumpEA-ID folder.
4. You are now fully set to run the code. Run the multirun.m script to run the algorithm. Note that, 'parfor' command will run 
   multiple trails parallelly according to 'number of workers' in your PC. Check PC system configuration->number of cores. If
   you don't want to use 'parfor', just replace it with 'for' command and comment 'delete(gcp)' command. That's it. Just run the
   specific algorithm (BaseEA/BumpEA_FF/BumpEA_ID/EFEA_FF) now.
5. All the data will be saved in a newly generated 'Data' folder. The format to store data is arranged as follows:
   Data->problem name->run number->stored data (Archive.m, best.m, Params.m).


%%%%%Stored data format%%%%%%%%%%%%%%

1. Archive.m stores all data raw data in a (N*M) matrix during the whole optimization process. The format is as follows:
   N = Total number of function evaluation budget (population size*no. of generation)
   M = [Generation no	nth solution in current generation	variables (x1...xD)	objective values (f1-single objective)	constraint values (G1...GP)	Sum of constraint violation	function evaluation so far]
2. best.m stores only the best data information in each generation in a matrix (N*M)
   N = Total number of generation
   M = [Generation no	variables (x1...xD)	objective values (f1-single objective)	constraint values (G1...GP)	Sum of constraint violation	function evaluation so far]
3. Params.m stores all specified parameters.
