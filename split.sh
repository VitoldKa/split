#!/bin/bash

while test $# != 0
do case "$1" in
        -t)    shift; offset="$1";;
		 *)		#echo ${infile};
		 if [[ opt=$1 =~ ^-.* ]];
		 	then echo "invalid option $1"; exit;
		 else
			if [ ! "${infile}" ];
				then infile=$1;
		 	else outfile=$1; fi; fi ;;
esac
shift
done

if [ ! "${infile}" ]; then echo "no infile"; exit; fi
if [ ! "${offset}" ]; then echo "use -t 0:0:0.0"; exit; fi
if [ ! "${outfile}" ]; then outfile="${infile}"; fi;
if [ ${offset} ]; then offset="${offset}"; fi;


if [ ${offset} ];
then
echo "${offset}"
	start_h=$(echo "${offset}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\1/g')
	start_m=$(echo "${offset}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\2/g')
	start_s=$(echo "${offset}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\3/g')
	start_c=$(echo "${offset}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\4/g')
	echo start_h: $start_h;	echo start_m: $start_m;	echo start_s: $start_s;	echo start_c: $start_c;

	start_m=$(echo "$start_m*60" | bc -q )
	start_h=$(echo "$start_h*3600" | bc -q )
	offset=$(echo "$start_m+$start_h+$start_s" | bc -q ).${start_c}
	echo $start_m;	echo $start_h;	echo $offset;
	offset_str="${offset}"
else
	offset=0.000
fi;


name=$(echo "${outfile}" | sed -e 's/^\(.*\)\.\(.*\)$/\1/g')
ext=$(echo "${outfile}" | sed -e 's/^\(.*\)\.\(.*\)$/\2/g')


outfile="${name}.1.${ext}"
app="/cygdrive/c/bin/ffmpeg_cuda.2.exe -threads 0"

cv="-c:v copy"
ca="-c:a copy"
map="-map"

outfile="${name}.1.${ext}"
echo ${app} -stats -v verbose -v error -v fatal \
    -i "$infile" ${map} ${cv} ${ca} ${cs} -ss ${offset_str} "$outfile" ;

outfile="${name}.2.${ext}"
echo ${app} -stats -v verbose -v error -v fatal \
    -i "$infile" ${map} ${cv} ${ca} ${cs} -ss ${offset_str} "$outfile" ;
