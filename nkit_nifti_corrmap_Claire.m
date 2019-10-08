
function nifti_corrmap_Claire(funcnames1, funcnames2, opts)
%
% This function calculates correlations between a number of Nifti files.
%
% For within-group correlations:
%   nifti_corrmap(funcnames1, [], opts)
% For between-group correlations:
%   nifti_corrmap(funcnames1, funcnames2, opts)
%
%  Parameters:
%     funcnames1 & funcnames2 = cell array of strings indicating full paths to 4D NIFTI files
%     funcnames1 = {...
%         'Z:\janice\DDA\ddaskyra\subjects\JC_012312\analysis\preproc\preproc03.feat\trans_filtered_func_data.nii',...
%         'Z:\janice\DDA\ddaskyra\subjects\MA_102411\analysis\preproc\preproc03.feat\trans_filtered_func_data.nii'}
%
% The output is written to a 3D NIFTI file with the name
% [opts.outputPath opts.outputName]. An output path must be specified.
%
% If only one list of funcnames is input to the function it calculates within-group correlation:
% for each voxel in a common space, it returns the (average of)
% the correlations of the INDIVIDUAL timecourses in path1
% against the AVERAGE of the timecourses of the OTHER funcnames in path1.
%
% If two lists of funcnames are input to the function it calculates between-group correlation:
% for each voxel in a common space, it returns the (average of)
% the correlations of the INDIVIDUAL timecourses in path1
% against the AVERAGE of the timecourses of the funcnames in path2 .
%
% opts.outputName is used for funcnames1; opts.outputName2 is used for funcnames2
%
% j chen 2012/2013
%

if ~isfield(opts,'save_maps'),              opts.save_maps = 1; end
if ~isfield(opts,'save_avgothers_nii'),     opts.save_avgothers_nii = 0; end
if ~isfield(opts,'save_mean_nii'),          opts.save_mean_nii = 1; end
if ~isfield(opts,'mcutoff'),                opts.mcutoff = []; end
if ~isfield(opts,'scutoff'),                opts.scutoff = []; end
if ~isfield(opts,'mask'),                   opts.mask = []; end
if ~isfield(opts,'crop_special'),           opts.crop_special = 0; end
if ~isfield(opts,'apply_cutoff'),           opts.apply_cutoff = 1; end

if isempty(opts.mcutoff), mcutoff = 6000; else mcutoff = opts.mcutoff; end % mean (over time) value at a voxel must be at least this high to be retained
if isempty(opts.scutoff), scutoff = 0.7; else scutoff = opts.scutoff; end % at least 70% of subjects must contribute data to each voxel
if ~isempty(funcnames2), opts.save_mean_nii = 1; end % this will enable the loading of avg-group2 during btwn-grp calculation

if ~exist(opts.outputPath,'dir')
    [pathstr,dirname] = fileparts(opts.outputPath);
    mkdir(pathstr,dirname);
end
% keyboard
% First load the data and save as .mat files for faster reanalysis
if opts.load_nifti == 1
    save_data_as_mat(funcnames1,mcutoff);
    if ~isempty(funcnames2)
        save_data_as_mat(funcnames2,mcutoff);
    end
end

% For each subject, calculate and save average-of-others (within group)
% First calculate the sum of all subjects. Then for each subject, subtract
% his own data from the sum and average, to produce the avg-of-others.
if opts.calc_avg == 1
    crop_opts.crop_beginning = opts.crop_beginning;
    crop_opts.crop_end = opts.crop_end;
    crop_opts.crop_special = opts.crop_special;
    save_avg_of_others(funcnames1,scutoff,opts,opts.outputName,crop_opts);
    if ~isempty(funcnames2)
        crop_opts2.crop_beginning = opts.crop_beginning;
        crop_opts2.crop_end = opts.crop_end;
        crop_opts2.crop_special = opts.crop_special2;
        save_avg_of_others(funcnames2,scutoff,opts,opts.outputName2,crop_opts2);
    end
end


% Run correlations.
% For each subject, calculate corr between that individual and the avg of others
% corr_data is voxels x subjects
% If two lists of funcnames are input to the function it calculates between-group correlation:
% for each voxel in a common space, it returns the (average of)
% the correlations of the INDIVIDUAL timecourses in path1
% against the AVERAGE of the timecourses of the funcnames in path2 .
if opts.calc_corr == 1
    fprintf('Calculating correlations\n');
    if isempty(funcnames2)
        calc_within_group_corr(funcnames1,opts,scutoff);  % calculate within-group correlation for funcnames1
    else
        calc_between_group_corr(funcnames1,funcnames2,opts,scutoff);  % calculate btwn-group correlation for funcnames1 vs. funcnames2
    end
end

if opts.save_maps == 1
    
    corrdata_name =fullfile(opts.outputPath,[ strrep(opts.outputName,'_nccu','') '_corr_data']);
    load(corrdata_name);
    
    % Reshape back to voxel space
    corr_img = reshape(corr_data,[datasize(1), datasize(2), datasize(3)]);
    
    % Save a Nifti file for the mean corr map
    fprintf('Saving maps\n');
    nii = load_nii(opts.standard);
    nii.hdr.dime.datatype = 16;
    nii.hdr.dime.bitpix = 32;
    nii.hdr.dime.cal_min=0.15;
    nii.hdr.dime.cal_max=0.6;
    
    nii.img = corr_img;
    nii.img(isnan(nii.img)) = 0;
    
    nii.hdr.dime.dim(2) = datasize(1);
    nii.hdr.dime.dim(3) = datasize(2);
    nii.hdr.dime.dim(4) = datasize(3);
    
    
    savename =[strrep(opts.outputName,'_nccu','') '_corr_data'];
    fprintf(['Between-group analysis: correlation map saved as ' savename '.nii\n']);
    save_nii(nii,fullfile(opts.outputPath,[savename '.nii']));
end
end


%% Sub-Functions

% Save the .nii data as .mat for faster loading in the future
function save_data_as_mat(funcnames,mcutoff)
if isempty(funcnames), return; end
for sid = 1:length(funcnames)
    fprintf(['Loading subject ' num2str(sid) ' nifti file\n']);
    if ~exist(funcnames{sid})
        fprintf([funcnames{sid} '\nFile not found -- did you unzip the trans_filtered_func_data files?\n']);
    else
        tic
        nii = load_nii(funcnames{sid});
        data = nii.img;
        nii.img = [];
        % Do not crop or mask data until next step
        datasize = size(data);
        data = single(reshape(data,[(size(data,1)*size(data,2)*size(data,3)),size(data,4)]));
        mdata = mean(data,2);
        keptvox = mdata>mcutoff;
        fpath = fileparts(funcnames{sid});
        save([funcnames{sid}(1:end-3) 'mat'],'data','datasize','keptvox','-v7.3');
        toc
    end
end
end

% Calculate between-group correlation for group1 vs group2
% (this only happens if funcnames2 is NOT empty)
function savename = calc_between_group_corr(funcnames1,funcnames2,opts,scutoff)

if ~isempty(opts.mask)
    masknii = load_nii(opts.mask);
    mask = masknii.img;
    clear masknii
end

load([funcnames1{1}(1:end-3) 'mat']); % loads data
% data are saved as voxelsXtimepoints 2D, so we reshape to 3D to crop
data = reshape(data,[datasize(1), datasize(2), datasize(3), datasize(4)]);
if ~isempty(opts.mask)
    data = data.*repmat(mask,[1 1 1 size(data,4)]); % mask
end
data = crop_data(1,data,opts);
data = reshape(data,[(size(data,1)*size(data,2)*size(data,3)),size(data,4)]);
data1 = zscore(data')'; % zscore every voxel timecourse
keptvox1=keptvox;

load([funcnames2{1}(1:end-3) 'mat']); % loads data
% data are saved as voxelsXtimepoints 2D, so we reshape to 3D to crop
data = reshape(data,[datasize(1), datasize(2), datasize(3), datasize(4)]);
if ~isempty(opts.mask)
    data = data.*repmat(mask,[1 1 1 size(data,4)]); % mask
end
data = crop_data(1,data,opts);
data = reshape(data,[(size(data,1)*size(data,2)*size(data,3)),size(data,4)]);
data2 = zscore(data')'; % zscore every voxel timecourse
keptvox2=keptvox;

corr_data(:,1) = sum(data1'.*data2')/(size(data1,2)-1);

% Save corr_data
fprintf('Saving correlation data\n');
n1 = length(funcnames1); n2 = length(funcnames2);
savename =  fullfile(opts.outputPath,[ strrep(opts.outputName,'_nccu','') '_corr_data'])
save(savename,'corr_data','datasize');
end

% Crop the data. Input must be 3D, not 2D.
function data = crop_data(sid,data,opts)
if ~ismember(sid,opts.crop_special(:,1))
    data(:,:,:,1:opts.crop_beginning) = []; % crop TRs from beginning of time series
    data(:,:,:,end-opts.crop_end+1:end) = []; % crop TRs from end of time series
elseif ismember(sid,opts.crop_special(:,1)) % crop different begin/end TRs for specified subjects
    cid = find(sid==opts.crop_special(:,1));
    crop_begin = opts.crop_special(cid,2);
    crop_end = opts.crop_special(cid,3);
    if crop_begin<0 % adds timepoints to the beginning of series if needed
        for k = 1:crop_begin*-1
            data(:,:,:,2:end+1) = data;
        end
    end
    data(:,:,:,1:crop_begin) = []; % crop TRs from beginning of time series
    if crop_end<0 % adds timepoints to the end of series if needed
        for k = 1:crop_end*-1
            data(:,:,:,end+1) = data(:,:,:,end);
        end
    end
    data(:,:,:,end-crop_end+1:end) = []; % crop TRs from end of time series
end
end


