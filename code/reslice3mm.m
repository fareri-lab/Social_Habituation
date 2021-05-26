datadir = '/Users/farerilab/Documents/Habituation_fMRI/deidentified/derivatives/fsl';
addpath(datadir);
%addpath '/home/login/spm12';

scriptdir = '/Users/farerilab/Documents/GitHub/Social_Habituation/code';


sub_list = [01];
for s = 1:length(sub_list)
    subject = ['sub-',num2str(sub_list(s))];
    %subnum = sub_list(s);
    nii_dir = fullfile(datadir,subject,'L2_sub-'num2str(sub01_task-sonet_model-01_type-act_hab.gfeat'RewAv','nii');
    cd(nii_dir);
    Nruns = 2;

    
    for r = 1:Nruns
    inhdr = 'rc2anat.nii';
    tarhdr = 'rwrenderanat.nii';
    rundir = sprintf('run%d',r);
    cd(rundir);
    nii_reslice_target(inhdr,'',tarhdr);
    cd ../
    end
end
