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

# study-specific inputs
TASK=sonet
TYPE=act
sm=6
#sub=$1
#run=$2

# list of exclusions/skips (study specific)
#if [ $sub -eq 150 -a $run -eq 2 ]; then
#	echo "participant fell asleep. skip run"
#	exit
#fi


for sub in "01" "02"; do
	for run in "1" "2" "3" "4"; do

# set inputs and general outputs (should not need to chage across studies in Smith Lab)
	MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}
	mkdir -p $MAINOUTPUT
	DATA=${maindir}/derivatives/fmriprep/sub-${sub}/func/sub-${sub}_task-${TASK}_run-${run}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz
	CONFOUNDEVS=${maindir}/derivatives/fsl/confounds/sub-${sub}/sub-${sub}_task-${TASK}_run-${run}_desc-fslConfounds.tsv
	if [ ! -e $CONFOUNDEVS ]; then
		echo "missing: $CONFOUNDEVS " >> ${maindir}/re-runL1.log
		exit # exiting to ensure nothing gets run without confounds
	fi
	EVDIR=${maindir}/derivatives/fsl/EVfiles/sub-${sub}/run-0${run}

# check for empty EVs (extendable to other studies)
	MISSED_TRIAL_Q=${EVDIR}_Miss_Ques_${run}.txt
	MISSED_TRIAL_FB=${EVDIR}_Miss_FB_${run}.txt
	if [ -e $MISSED_TRIAL_Q ]; then
		EV_SHAPE=3
	else
		EV_SHAPE=10
	fi

	if [ -e $MISSED_TRIAL_FB ]; then
		EV_SHAPE=3
	else
		EV_SHAPE=10
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
	ITEMPLATE=${maindir}/templates/L1_task-${TASK}_model-01_type-${TYPE}.fsf
	OTEMPLATE=${MAINOUTPUT}/L1_sub-${sub}_task-${TASK}_model-01_run-0${run}.fsf

	INPUT1=${EVDIR}/C_Ques_${run}.txt
	INPUT2=${EVDIR}/F_Ques_${run}.txt
	INPUT3=${EVDIR}/H_Ques_${run}.txt
	INPUT4=${EVDIR}/PunishC_FB_${run}.txt
	INPUT5=${EVDIR}/PunishF_FB_${run}.txt
	INPUT6=${EVDIR}/PunishH_FB_${run}.txt
	INPUT7=${EVDIR}/RewardC_FB_${run}.txt
	INPUT8=${EVDIR}/RewardF_FB_${run}.txt
	INPUT9=${EVDIR}/RewardH_FB_${run}.txt
	#INPUT10=${EVDIR}/Miss_Ques_${run}.txt
	#INPUT11=${EVDIR}/Miss_FB_${run}.txt

	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@DATA@'$DATA'@g' \
	-e 's@EVDIR@'$EVDIR'@g' \
	-e 's@MISSED_TRIAL_Q@'$MISSED_TRIAL_Q'@g' \
	-e 's@MISSED_TRIAL_FB@'$MISSED_TRIAL_FB'@g' \
	-e 's@EV_SHAPE@'$EV_SHAPE'@g' \
	-e 's@SMOOTH@'$sm'@g' \
	-e 's@CONFOUNDEVS@'$CONFOUNDEVS'@g' \
	-e 's@INPUT1@'$INPUT1'@g' \
	-e 's@INPUT2@'$INPUT2'@g' \
	-e 's@INPUT3@'$INPUT3'@g' \
	-e 's@INPUT4@'$INPUT4'@g' \
	-e 's@INPUT5@'$INPUT5'@g' \
	-e 's@INPUT6@'$INPUT6'@g' \
	-e 's@INPUT7@'$INPUT7'@g' \
	-e 's@INPUT8@'$INPUT8'@g' \
	-e 's@INPUT9@'$INPUT9'@g' \
	#-e 's@INPUT8@'$INPUT10'@g' \
	#-e 's@INPUT8@'$INPUT11'@g' \
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
