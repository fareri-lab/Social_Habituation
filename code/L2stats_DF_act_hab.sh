#!/usr/bin/env bash

#This script will run second-level statistics on the Habituation_fMRI dataset


maindir=/Users/farerilab/Documents/Habituation_fMRI/deidentified
#mkdir ${maindir}/templates
# study-specific inputs
TASK=sonet
TYPE=act

#for sub in "01" "02" "03" "04" "05" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "21" "22"; do
for sub in "17"; do
    echo "start sub-${sub}"
    MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}_FIR
    OUTPUT=${MAINOUTPUT}/L2_task-${TASK}_model-01_type-${TYPE}_FIR_5bins

    rm -rf ${OUTPUT}.gfeat*

    INPUT1=${MAINOUTPUT}/L1_task-sonet_model-01_type-act_run-01_sm-6_FIR_5bins.feat
    INPUT2=${MAINOUTPUT}/L1_task-sonet_model-01_type-act_run-02_sm-6_FIR_5bins.feat
    #INPUT3=${MAINOUTPUT}/L1_task-sonet_model-01_type-act_run-04_sm-6_FIR_5bins.feat
    #INPUT4=${MAINOUTPUT}/L1_task-sonet_model-01_type-act_run-04_sm-6_FIR_5bins.feat

    TEMPLATE=${maindir}/templates/L2_task-sonet_model-01_FIR_template_sub17only.fsf

    sed -e 's@OUTPUT@'$OUTPUT'@g' \
    -e 's@INPUT1@'$INPUT1'@g' \
    -e 's@INPUT2@'$INPUT2'@g' \
    #-e 's@INPUT3@'$INPUT3'@g' \
    #-e 's@INPUT4@'$INPUT4'@g' \
    <$TEMPLATE> ${MAINOUTPUT}/L2_task-sonet_model-01_FIR_template_sub17only.fsf
    feat ${MAINOUTPUT}/L2_task-sonet_model-01_FIR_template_sub17only.fsf

    echo "end sub-${sub}"
done
