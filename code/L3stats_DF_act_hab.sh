#!/usr/bin/env bash

#This script will run group-level statistics on the Habituation_fMRI dataset

maindir=/Users/farerilab/Documents/Habituation_fMRI/deidentified
#mkdir ${maindir}/templates
# study-specific inputs
TASK=sonet
TYPE=act


for COPENUM in `seq 10 20`; do
  echo ${COPENUM}
  MAINOUTPUT=${maindir}/derivatives/fsl/
  OUTPUT=${MAINOUTPUT}/L3_model01_hab_n10_cope${COPENUM}_z23

  echo ${OUTPUT}

  rm -rf ${OUTPUT}.gfeat

  TEMPLATE=${maindir}/templates/L3_task-sonet_model-01_hab.fsf
  echo ${TEMPLATE}

  sed -e 's@OUTPUT@'$OUTPUT'@g' \
  -e 's@COPENUM@'$COPENUM'@g' \
  <$TEMPLATE> ${MAINOUTPUT}/L3_task-sonet_model-01_hab.fsf
  feat ${MAINOUTPUT}/L3_task-sonet_model-01_hab.fsf
done
