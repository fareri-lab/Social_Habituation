#!/bin/bash

#User inputs:

# usage: bash mriqc_hab.sh sub
# example: bash mriqc_hab.sh 104

bids_root_dir=$HOME/Documents/Habituation_fMRI/deidentified/BIDS
#subj=01
nthreads=2
mem=10 #gb
container=docker #docker or singularity

subj=$1

#Make mriqc directory and participant directory in derivatives folder
if [ ! -d $bids_root_dir/derivatives/mriqc ]; then
mkdir $bids_root_dir/derivatives/mriqc
fi


#for subj in 01 02 03; do
if [ ! -d $bids_root_dir/derivatives/mriqc/sub-${subj} ]; then
mkdir $bids_root_dir/derivatives/mriqc/sub-${subj}
fi

#Run MRIQC
echo ""
echo "Running MRIQC on participant ${subj}"
echo ""

if [ $container == singularity ]; then
  unset PYTHONPATH; singularity run $HOME/mriqc_0.15.1.simg \
  $bids_root_dir $bids_root_dir/derivatives/mriqc/sub-${subj} \
  participant \
  --n_proc $nthreads \
  --hmc-fsl \
  --correct-slice-timing \
  --mem_gb $mem \
  --float32 \
  --ants-nthreads $nthreads \
  -w $bids_root_dir/derivatives/mriqc/sub-${subj}
else
  docker run -it --rm -v $bids_root_dir:/data:ro -v $bids_root_dir/derivatives/mriqc/sub-${subj}:/out \
  poldracklab/mriqc:0.15.1 /data /out \
  participant \
  --n_proc $nthreads \
  --hmc-fsl \
  --correct-slice-timing \
  --mem_gb $mem \
  --float32 \
  --ants-nthreads $nthreads \
  -w $bids_root_dir/derivatives/mriqc/sub-${subj}
fi
