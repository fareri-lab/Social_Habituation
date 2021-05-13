


for subj in "01"; do

	subjdir=${expdir}/${subj}/RewAv
	outputdir1=${expdir}/scripts/RewAv/WMTimeSeries
	#mkdir ${outputdir1}/${subj}

		mainout=${subjdir}/fsl
    #data will be filtered_func_data.nii.gz from level2 analyses
    data=${mainout}/prestats${r}.feat/ICA_AROMA/denoised_func_data_nonaggr.nii.gz
		#mkdir ${outputdir1}/${subj}/run${r}

		fslmeants -i ${data} -o ${outputdir1}/${subj}/run${r}/${subj}_run${r}_WMTimeSeries.txt -m ${subjdir}/nii/run${r}/rrc2anat.nii
	
	done
done
