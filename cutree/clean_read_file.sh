#!/bin/sh

input_sequence_file=$1

#echo ${input_sequence_file}

basepath=$(cd `dirname $0`; pwd)
while read line
do
    if echo $line | grep -q 'YES'
    then
        sequence_dir=$(echo $line | cut -d " " -f 1)
        sequence_name=$(echo $line | cut -d " " -f 2)
        width=$(echo $line | cut -d " " -f 3)
        height=$(echo $line | cut -d " " -f 4)
        framerate=$(echo $line | cut -d " " -f 5)
        #crflist="22 27 32 37"
        targetrate=$(echo $line | cut -d " " -f 6)
        #seq=$(echo $sequence_name | cut -d . -f 1)
        #for crf in ${crflist}
        #do
            #mkdir $(echo $sequence_name | cut -d . -f 1)_${crf}
            seq=${sequence_name%.*}
            if [ -d ${seq}_${targetrate} ]
            then
                rm -rf ${seq}_${targetrate}
            fi
        #done
    fi

done < ${input_sequence_file}
