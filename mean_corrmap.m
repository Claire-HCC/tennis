clearvars;

set_parameters;

for input_typei=1%:2;
    input_type=input_types{input_typei};
     fs=dir([expdir 'intersubj/' input_type '/group/*.nii' ]);
     fs={fs.name};
     fs_full=cellfun(@(x) [expdir 'intersubj/' input_type '/group/' x],fs,'UniformOutput',0);
  %  fs=cellstr(ls([expdir 'intersubj/' input_type '/group/*.nii' ]));
   % fs_full= cellfun(@(x) [expdir 'intersubj/' input_type '/group/' x],fs,'UniformOutput',0);
    for ci =1:length(fs);
    opts.crop_beginning=0;
    opts.crop_end=0;
    opts.mcutoff=-1;
    opts.outputName=[expdir 'intersubj/' input_type '/group/' fs{ci}];
    opts.standard=[expdir '/data/MNI152_T1_3mm_brain.nii'];
    nkit_nifti_mean_and_std(fs_full,opts);
    end
end
