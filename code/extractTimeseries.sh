
maindir=/Users/farerilab/Documents/Habituation_fMRI/deidentified
#mkdir ${maindir}/templates
# study-specific inputs

for sub in "01" "02" "03" "04" "05" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "21" "22"; do
#for sub in "12" "13" "14" "15" "16" "17" "18" "19" "21" "22"; do
#for sub in "13"; do
	for cope in "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30"; do

		subjdir=${maindir}/derivatives/fsl/sub-${sub}_FIR
		outputdir=${maindir}/derivatives/fsl/FIR_DMN_5bins_zstats
		mkdir ${outputdir}
		mkdir ${outputdir}/sub-${sub}

		#mainout=${subjdir}/fsl
    #data will be filtered_func_data.nii.gz from level2 analyses
#    data=${subjdir}/L2_task-sonet_model-01_type-act_FIR_5bins.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
		data=${subjdir}/L2_task-sonet_model-01_type-act_FIR_5bins.gfeat/cope${cope}.feat/stats/zstat1.nii.gz
		#mkdir ${outputdir1}/${subj}/run${r}

		fslmeants -i ${data} -o ${outputdir}/sub-${sub}/cope${cope}_FIR_DMN_zstat.txt -m ${maindir}/masks/rpnas_3mm_separate0003.nii.gz

	done
done
