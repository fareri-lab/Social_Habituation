#!/usr/bin/env bash

# This script will perform Level 1 statistics in FSL.
# Rather than having multiple scripts, we are merging three analyses
# into this one script:
#		1) activation
#		2) seed-based ppi
#		3) network-based ppi
# Note that activation analysis must be performed first.
# Seed-based PPI and Network PPI should follow activation analyses.

# ensure paths are correct irrespective from where user runs the script
#scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#maindir="$(dirname "$scriptdir")"

maindir=/Users/farerilab/Documents/Habituation_fMRI/deidentified
#mkdir ${maindir}/templates
# study-specific inputs
TASK=sonet
TYPE=act
#sub=$1
#run=$2
#ppi=$3 # 0 for activation, otherwise seed region or network

# list of exclusions/skips (study specific)
#if [ $sub -eq 150 -a $run -eq 2 ]; then
#	echo "participant fell asleep. skip run"
#	exit
#fi

# set inputs and general outputs (should not need to chage across studies in Smith Lab)


#DATA=${maindir}/derivatives/fmriprep/sub-${sub}/func/sub-${sub}_task-${TASK}_run-${run}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz
#CONFOUNDEVS=${maindir}/derivatives/fsl/confounds/sub-${sub}/sub-${sub}_task-${TASK}_run-${run}_desc-fslConfounds.tsv
#if [ ! -e $CONFOUNDEVS ]; then
#	echo "missing: $CONFOUNDEVS " >> ${maindir}/re-runL1.log
#	exit # exiting to ensure nothing gets run without confounds
#fi

# check for empty EVs (extendable to other studies)
#MISSED_TRIAL_Q=${EVDIR}/Miss_Ques_${run}.txt
#if [ -e $MISSED_TRIAL_Q ]; then
#	EV_SHAPE=3
#else
#	EV_SHAPE=10
#fi

#MISSED_TRIAL_FB=${EVDIR}/Miss_FB_${run}.txt
#if [ -e $MISSED_TRIAL_FB ]; then
#	EV_SHAPE=3
#else
#	EV_SHAPE=10
#fi

for sub in "08" "09" "10" "11"; do
	for run in "1" "2" "3" "4"; do

		DATA=${maindir}/derivatives/fmriprep/sub-${sub}/func/sub-${sub}_task-${TASK}_run-${run}_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii.gz
		CONFOUNDEVS=${maindir}/derivatives/fsl/confounds/sub-${sub}/sub-${sub}_task-${TASK}_run-${run}_desc-fslConfounds.tsv
		sm=6
		MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}
		mkdir -p $MAINOUTPUT
		EVDIR=${maindir}/derivatives/fsl/EVfiles/sub-${sub}/run-0${run}


		if [ ! -e $CONFOUNDEVS ]; then
			echo "missing: $CONFOUNDEVS " >> ${maindir}/re-runL1.log
			exit # exiting to ensure nothing gets run without confounds
		fi

	# set output based in whether it is activation or ppi
		OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-${TYPE}_run-0${run}_sm-${sm}

# check for output and skip existing
		if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
			exit
		else
			echo "missing: $OUTPUT " >> ${maindir}/re-runL1.log
			rm -rf ${OUTPUT}.feat
		fi

	# create template and run analyses
		INPUT01=${EVDIR}/C_Ques_${run}.txt
		INPUT02=${EVDIR}/H_Ques_${run}.txt
		INPUT03=${EVDIR}/F_Ques_${run}.txt
		INPUT04=${EVDIR}/PunishC_FB_${run}.txt
		INPUT05=${EVDIR}/PunishH_FB_${run}.txt
		INPUT06=${EVDIR}/PunishF_FB_${run}.txt
		INPUT07=${EVDIR}/RewardC_FB_${run}.txt
		INPUT08=${EVDIR}/RewardH_FB_${run}.txt
		INPUT09=${EVDIR}/RewardF_FB_${run}.txt
		INPUT10=${EVDIR}/Miss_Ques_${run}.txt
		INPUT11=${EVDIR}/Miss_FB_${run}.txt

		ITEMPLATE=${maindir}/templates/L1_task-${TASK}_model-01.fsf
		OTEMPLATE=${MAINOUTPUT}/L1_sub-${sub}_task-${TASK}_model-01_run-0${run}.fsf
				sed -e 's@OUTPUT@'$OUTPUT'@g' \
				-e 's@DATA@'$DATA'@g' \
				-e 's@CONFOUNDEVS@'$CONFOUNDEVS'@g' \
				-e 's@INPUT01@'$INPUT01'@g' \
				-e 's@INPUT02@'$INPUT02'@g' \
				-e 's@INPUT03@'$INPUT03'@g' \
				-e 's@INPUT04@'$INPUT04'@g' \
				-e 's@INPUT05@'$INPUT05'@g' \
				-e 's@INPUT06@'$INPUT06'@g' \
				-e 's@INPUT07@'$INPUT07'@g' \
				-e 's@INPUT08@'$INPUT08'@g' \
				-e 's@INPUT09@'$INPUT09'@g' \
				-e 's@INPUT10@'$INPUT10'@g' \
				-e 's@INPUT11@'$INPUT11'@g' \
				<$ITEMPLATE> $OTEMPLATE
				feat $OTEMPLATE

# fix registration as per NeuroStars post:
# https://neurostars.org/t/performing-full-glm-analysis-with-fsl-on-the-bold-images-preprocessed-by-fmriprep-without-re-registering-the-data-to-the-mni-space/784/3
		mkdir -p ${OUTPUT}.feat/reg
		ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/example_func2standard.mat
		ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/standard2example_func.mat
		ln -s ${OUTPUT}.feat/mean_func.nii.gz ${OUTPUT}.feat/reg/standard.nii.gz

		# delete unused files
		rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
		rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
		rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
		rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
	done
done
