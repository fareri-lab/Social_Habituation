#!/usr/bin/env bash

#This script will run second-level statistics on the Habituation_fMRI dataset


maindir=/Users/farerilab/Documents/Habituation_fMRI/deidentified
#mkdir ${maindir}/templates
# study-specific inputs
TASK=sonet
TYPE=act

for sub in "02" "03" "04" "05" "07" "08" "09" "10" "11"; do
#for sub in "01"; do
    MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}
    OUTPUT=${MAINOUTPUT}/L2_sub-${sub}_task-${TASK}_model-01_type-${TYPE}_hab

    rm -rf ${OUTPUT}.gfeat*

    INPUT1=${MAINOUTPUT}/L1_task-sonet_model-01_type-act_run-01_sm-6.feat
    INPUT2=${MAINOUTPUT}/L1_task-sonet_model-01_type-act_run-02_sm-6.feat
    INPUT3=${MAINOUTPUT}/L1_task-sonet_model-01_type-act_run-03_sm-6.feat
    INPUT4=${MAINOUTPUT}/L1_task-sonet_model-01_type-act_run-04_sm-6.feat

    TEMPLATE=${maindir}/templates/L2_task-sonet_model-01_hab_new2.fsf

    sed -e 's@OUTPUT@'$OUTPUT'@g' \
    -e 's@INPUT1@'$INPUT1'@g' \
    -e 's@INPUT2@'$INPUT2'@g' \
    -e 's@INPUT3@'$INPUT3'@g' \
    -e 's@INPUT4@'$INPUT4'@g' \
    <$TEMPLATE> ${MAINOUTPUT}/L2_task-sonet_model-01_hab_new2.fsf
    feat ${MAINOUTPUT}/L2_task-sonet_model-01_hab_new2.fsf
done
