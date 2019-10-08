% matlab has a limit on maximum matrix size (800 iterations?).
% so save the results of permutation piece by piece.
% e.g., to iterate the permutations for 10000 times, it's better to run 500
% permutations 20 times and save the results in two mat files.
% to do this, set params.iterations=10000; params.iterations_piece = 500;
% and run the folloowing command in the terminal: submit 20 stats_bootstrap_isc2_claire.m
% the number of output files should be 20.

params.iterations = 1000;
params.iterations_PerPiece = 20;
params.iterations_piece = params.iterations/params.iterations_PerPiece;
iterations_piece =0;

while iterations_piece < params.iterations_piece ;
    clearvarlist = ['clearvarlist';setdiff(who,{'params','iterations_piece'})];
    clear(clearvarlist{:});
    iterations_piece = iterations_piece+1;
    loc='cluster';
    set_parameters
    params.datadir=[expdir slash 'intersubj' slash 'inputs'];
    params.permute      = 1;
    params.crop=[];
    input_types= {'trans_filtered_func' , 'trans_res4d'};
    input_type=input_types{1};
    
    for ci = 1%5:length(conditions);
        cond=conditions{ci};
        pairN=0;
        
        for pi = 4%:length(iscpair);
            p=iscpair(pi);
            
            params.savename = [ params.datadir slash '..' slash input_type slash 'corrmap' slash 'Pair' num2str(p) '_' cond '_corr_iter' ];
            
            % Load subdata
            p=iscpair(pi);
            nccu_file = fullfile(params.datadir, ['Pair' num2str(p) '_nccu_' conditions{ci} '_' input_type '.mat']);
            nccu_data = load(nccu_file);
            nymu_file = fullfile(params.datadir, ['Pair' num2str(p) '_nymu_' conditions{ci} '_' input_type '.mat']);
            nymu_data = load(nymu_file);
            
            %% Mask data
            nccu_data_brain = NaN(length(nccu_data.keptvox), size(nccu_data.data,2));
            nymu_data_brain = nccu_data_brain;
            
            % Claire: I don't know what tc is.
            nccu_data_brain(nccu_data.keptvox==1,:) = nccu_data.data(nccu_data.keptvox==1,:);
            nymu_data_brain(nymu_data.keptvox==1,:) = nymu_data.data(nymu_data.keptvox==1,:);
            
            % get shared voxels
            shared_vox = intersect(find(nccu_data.keptvox), find(nymu_data.keptvox));
            
            % get only good data
            nccu_data_kept = nccu_data_brain(shared_vox,:);
            nymu_data_kept = nymu_data_brain(shared_vox,:);
            
            %% Other preprocessing
            % Crop
            if ~isempty(params.crop)
                
                nccu_data = nccu_data_kept(:, params.crop(1):params.crop(2));
                nymu_data = nymu_data_kept(:, params.crop(1):params.crop(2));
            else
                nccu_data = nccu_data_kept;
                nymu_data = nymu_data_kept;
            end
            
            % Zscore
            nymu_data = zscore(nymu_data,0, 2);
            nccu_data = zscore(nccu_data,0,2);
            
            %% Phase scram & corr
            fprintf('phase scrambling ');
            % initialize corrdata if first subject
            if pairN == 0
                corr_data_sum = zeros(params.iterations_PerPiece, size(nymu_data,1));
                bootstrap=[];
            end
            
            for j = 1%:params.iterations_PerPiece;
                fprintf(['-' num2str(j)]);
                
                % phase randomize average of nymu
                nymu_scram = phase_rand(nymu_data, params.permute);
                
                % calc correlation subject to phase scrambled avg nymu
                corr_data = sum(nccu_data'.*nymu_scram')/(size(nccu_data,2)-1);
                corr_data_sum(j,:) = corr_data_sum(j,:)+corr_data;
            end
            pairN=pairN+1;
            fprintf('\n');
        end
        
        bootstrap = corr_data_sum/ pairN;
    %    save(sprintf([params.savename num2str(params.iterations) '_%03d.mat'],iterations_piece ), 'bootstrap', 'params');
        
    end
end
