#!/bin/sh

input_sequence_file=$1

basepath=$(cd `dirname $0`; pwd)

if [ -f result.csv ]
then
    rm result.csv
fi

while read -r line
do
    if echo $line | grep -q 'YES'
    then
        sequence_name=$(echo $line | cut -d " " -f 2)
        seq=${sequence_name%.*}
        targetrate=$(echo $line | cut -d " " -f 6)
        #for crf in ${crflist}
        #do
            while read -r line1
            do
               if  ! echo $line1 | grep -q 'Command' 
               then
                   rate=$(echo $line1 | cut -d , -f 5)
                   ssim=$(echo $line1 | cut -d , -f 10)
                   psnr=$(echo $line1 | cut -d , -f 9)
                   echo -n "${seq}, " >> result.csv
                   echo -n "${rate}, " >> result.csv
                   echo ${ssim} >> result.csv
               fi
            done < ${seq}_${targetrate}/${seq}_${targetrate}.csv
        #done
    fi

done < ${input_sequence_file}

