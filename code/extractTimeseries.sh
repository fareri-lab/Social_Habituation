
maindir=/Users/farerilab/Documents/Habituation_fMRI/deidentified
#mkdir ${maindir}/templates
# study-specific inputs

for sub in "01" "02" "03" "04" "05" "07" "08" "09" "10" "11"; do
	for cope in "8" "9"; do

		subjdir=${maindir}/derivatives/fsl/sub-${sub}
		outputdir=${maindir}/derivatives/fsl/VSTimeSeries
		mkdir ${outputdir}
		mkdir ${outputdir}/sub-${sub}

		#mainout=${subjdir}/fsl
    #data will be filtered_func_data.nii.gz from level2 analyses
    data=${subjdir}/L2_sub-${sub}_task-sonet_model-01_type-act_hab.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
		#mkdir ${outputdir1}/${subj}/run${r}

		fslmeants -i ${data} -o ${outputdir}/sub-${sub}/cope${cope}_VSTimeSeries.txt -m ${maindir}/masks/rBilateralNAcc_bin.nii

	done
done
