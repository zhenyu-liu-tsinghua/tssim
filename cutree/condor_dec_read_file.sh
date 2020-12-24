#!/bin/sh

input_sequence_file=$1

#echo ${input_sequence_file}
cnt=0
basepath=$(cd `dirname $0`; pwd)
echo ${basepath}
while read line
do
    if echo $line | grep -q 'YES'
    then
        sequence_dir=$(echo $line | cut -d " " -f 1)
        sequence_name=$(echo $line | cut -d " " -f 2)
        width=$(echo $line | cut -d " " -f 3)
        height=$(echo $line | cut -d " " -f 4)
        framerate=$(echo $line | cut -d " " -f 5)
        rate=$(echo $line | cut -d " " -f 6)
        
        #seq=$(echo $sequence_name | cut -d . -f 1)
        #for crf in ${crflist}
        #do
            #mkdir $(echo $sequence_name | cut -d . -f 1)_${crf}
            seq=${sequence_name%.*}
            if [ -f ${seq}_${rate}_dec.error ]
            then
                rm -f ${seq}_${rate}_dec.error
            fi
            if [ -f ${seq}_${rate}_dec.log ]
            then
                rm -f ${seq}_${rate}_dec.log
            fi
            if [ -f ${seq}_${rate}_dec.output ]
            then
                rm -f ${seq}_${rate}_dec.output
            fi
            sub_file=${basepath}/${seq}_${rate}/${seq}_${rate}_dec_job.sub

            echo ${seq}_${rate}
            echo "universe        = vanilla" > ${sub_file}
            echo "executable      = TAppDecoderStatic" >> ${sub_file}
            echo "initialdir      = ${basepath}/${seq}_${rate}" >> ${sub_file}
            echo "error           = ${seq}_${rate}_dec.error" >> ${sub_file}
            echo "log             = ${seq}_${rate}_dec.log" >> ${sub_file}
            echo "output          = ${seq}_${rate}_dec.output" >> ${sub_file}
            echo "notification    = error" >> ${sub_file}
            echo "should_transfer_files = YES" >> ${sub_file}
            echo "run_as_owner    = True" >> ${sub_file}
            echo "priority        = 10" >> ${sub_file}
            echo "arguments       =  -b ${basepath}/${seq}_${rate}/output.265 -o ${seq}_${rate}.yuv" >> ${sub_file}
            echo "queue" >> ${sub_file}
            condor_submit ${sub_file}
            
            cnt=`expr $cnt + 1`
            
            if [ $cnt -gt 4 ]
            then
               cnt=0
               sleep 10s
               while true
               do
                   #if ps aux | grep -v "grep" | grep -q "condor_exec"
                   if condor_q | grep -v "grep" | grep -q "ID:"
                   then
                       sleep 10s
                   else
                       break
                   fi
               done               
            fi
            #cd ..
        #done
    fi

done < ${input_sequence_file}

sleep 30s

while true
do
    #if ps aux | grep -v "grep" | grep -q "condor_exec"
    if condor_q | grep -v "grep" | grep -q "ID:"
    then
       sleep 10s
    else
        break
    fi
done
