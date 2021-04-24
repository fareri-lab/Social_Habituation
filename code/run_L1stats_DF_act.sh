
#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
#scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#basedir="$(dirname "$scriptdir")"
basedir=/Users/farerilab/Documents/GitHub/Social_Habituation/

for sub in "01"; do #"02" "03" "04" "05" "06" "07" "08" "09" "10" "11"
		set -- $subj
	  sub=$1
		for run in "01" "02" "03" "04"
		run=$2
	  #nruns=$2

	  	# Manages the number of jobs and cores
	  SCRIPTNAME=${basedir}/code/L1stats_DF_act.sh
	  	#NCORES=15
	  	#while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	    #		sleep 1s
	  	#done
	 	bash $SCRIPTNAME $sub $run &
	 	sleep 1s
	  done
