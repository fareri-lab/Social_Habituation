#!/usr/bin/env bash

TASK=sonet
TYPE=act
sm=6
for sub in "01" "02" "03" "04" "05" "07" "08" "09" "10" "11"; do
	for run in "1" "2" "3" "4"; do

  maindir=/Users/farerilab/Documents/Habituation_fMRI/deidentified
  MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}
  OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-${TYPE}_run-0${run}_sm-${sm}

	cd ${OUTPUT}.feat/reg
	rm *.mat
	rm *.nii.gz

  cp $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/example_func2standard.mat
  cp $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/standard2example_func.mat
  cp ${OUTPUT}.feat/mean_func.nii.gz ${OUTPUT}.feat/reg/standard.nii.gz
  cp ${OUTPUT}.feat/example_func.nii.gz ${OUTPUT}.feat/reg/example_func2standard.nii.gz
done
done
