#!/bin/bash
#"11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22"


for subj in "03" "04"; do
	set -- $subj
	sub=$1

  	script=run_fmriprep_hab.sh
  	#NCORES=8
  	#while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
 		#sleep 1s
  	#done
  	bash $script $sub &
  	sleep 5s
done
