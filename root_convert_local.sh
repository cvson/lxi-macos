#!/bin/bash

#source /home/cvson/offline/root6d24/install/bin/thisroot.sh
source /Users/cvson/meOffline_nosync/root6/root_reinstall/bin/thisroot.sh

dir_base=/Users/cvson/meOffline/DAQ/RTM3004/
#dir_sub=20231222_710kW_ssemout_ssem19in
#dir_rawdata=${dir_base}rawdata/${dir_sub}
#dir_rootdata=${dir_base}rootdata/${dir_sub}
dir_rawdata=${dir_base}rawdata/
dir_rootdata=${dir_base}rootdata/

#IFS=$'\n'
#filelist=`ls $dir_rawdata/*.dat`
cd $dir_rawdata

filelist=`find ${1}* -maxdepth 0 -type f`

#cd $dir_base 

for eachfile in $filelist
do
	if [ -f "$eachfile" ]; then
	echo $eachfile;
	file2read=`echo "${eachfile}" | rev | cut -c5- | rev`
	echo $file2read;
        root -b -q ${dir_base}/read_rawdata.C\(\"${file2read}\"\) ;
	fi
done

cd $dir_base

#for eachfile in $filelist
#do
#        if [ -f "$eachfile" ]; then
#        root -b -q read_rawdata.C\(\"${eachfile}\"\)
#        fi
#done


#find $dir_rawdata/ -maxdepth 1 -printf "%f\n"

#files=$(find "$dir_rawdata" -maxdepth 1 | sort)

#for ithfile in $files
#do
#	echo "$ithfile"
#done

#for FILE in $dir_rawdata/*.dat
#do
#	echo "$FILE"

#done 

#files=$(find "$dir_rawdata" -maxdepth 1 | sort)
#IFS=$'n'

#while true
#do
#	sleep 5s
#	newfiles=$(find "$dir_rawdata" -maxdepth 1 | sort)
#	addedfile=$(comm -13 <(echo "$file") <(echo "$newfiles"))

#	["$addedfile" != ""] && find $addedfile -maxdepth 1 -printf '%Tc\t%s\t%p\n' |
#	echo "$addedfile to process"

#	files="$newfiles"
#done 

#root -b -q read_rawdata.C\(\"${outputFile}_raw_p${subrun}\"\) 


