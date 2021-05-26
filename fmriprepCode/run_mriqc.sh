#!/bin/bash

for subnum in "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22"; do
	set -- $subnum
	sub=$1
	#nruns=$2

	script=mriqc_update.sh
  	#NCORES=7

		#while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
		#sleep 1s
  	#done
	bash $script $sub
	#$nruns
	#sleep 5s
done
