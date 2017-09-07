#!/bin/bash

function read_dir(){
	for file in `ls $1 | grep -v last`
	do
		if [ -d  ${1}"/"${file} ]
		then
			read_dir $1"/"$file
		else
			read_file $1"/"$file
		fi
	done
}

function read_file(){
#	filepath=$1
#	echo $1
	if [ ${1##*/} == "build.xml" ]
	then
		echo -en "hudsonBuildNumber:\t"`echo $1 | grep -o '[0-9]\+'`
		echo -en '\t'
		cat $1 | egrep "builtOn"|head -1| while read line; do left=${line#*\<}; right=${left%\<*}; echo -en ${right/\>/:\\t}; echo -en '\t'; done
		#echo ""
		cat ${1%/*}"/log" | grep "Finished" |while read line; do echo -e ${line/ /\\t};done
	fi
}

read_dir $1 > result
passrate=let `cat result |grep SUCCESS| wc -l` / `cat result| wc -l`
echo "passrate: "$passrate
