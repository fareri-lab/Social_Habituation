#!/usr/bin/env bash

#This script will run group-level statistics on the Habituation_fMRI dataset

maindir=/Users/farerilab/Documents/Habituation_fMRI/deidentified
#mkdir ${maindir}/templates
# study-specific inputs
TASK=sonet
TYPE=act


for COPENUM in '34' '39' '44' '49' '59' '64'; do
  echo ${COPENUM}
  MAINOUTPUT=${maindir}/derivatives/fsl
  OUTPUT=${MAINOUTPUT}/L3_model01_FIR_TR5_cope${COPENUM}_z31

  echo ${OUTPUT}

  rm -rf ${OUTPUT}.gfeat

  TEMPLATE=${maindir}/templates/L3_task-sonet_model-01_FIR_template.fsf
  echo ${TEMPLATE}

  sed -e 's@OUTPUT@'$OUTPUT'@g' \
  -e 's@COPENUM@'$COPENUM'@g' \
  <$TEMPLATE> ${MAINOUTPUT}/L3_task-sonet_model-01_FIR.fsf
  feat ${MAINOUTPUT}/L3_task-sonet_model-01_FIR.fsf
done
