#!/bin/sh

input_sequence_file=$1

#echo ${input_sequence_file}

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
            if [ -d ${seq}_${rate} ]
            then
                rm -rf ${seq}_${rate}
            fi

            mkdir ${seq}_${rate}

            sub_file=${basepath}/${seq}_${rate}/${seq}_${rate}_job.sub
            echo ${seq}_${rate}
            echo "universe        = vanilla" > ${sub_file}
            echo "executable      = x265" >> ${sub_file}
            echo "initialdir      = ${basepath}/${seq}_${rate}" >> ${sub_file}
            echo "error           = ${seq}_${rate}.error" >> ${sub_file}
            echo "log             = ${seq}_${rate}.log" >> ${sub_file}
            echo "output          = ${seq}_${rate}.output" >> ${sub_file}
            echo "notification    = error" >> ${sub_file}
            echo "should_transfer_files = YES" >> ${sub_file}
            echo "run_as_owner    = True" >> ${sub_file}
            echo "priority        = 10" >> ${sub_file}
            echo "arguments       =  --preset veryslow --min-keyint 1 --pass 1 --input ${sequence_dir}/${sequence_name} --input-res ${width}x${height} --fps ${framerate} --ref 4 --frame-thread 1 --no-wpp --bitrate ${rate} --no-pmode --no-pme --slices 0 --lookahead-slices 0 --ssim --tune ssim --qg-size 64 --aq-mode 1 --aq-strength 1.0 --b-adapt 2 --bframes 15 --keyint 5000 -o output.265" >> ${sub_file}
            #echo "arguments       =  --preset medium --pass 1 --input ${sequence_dir}/${sequence_name} --input-res ${width}x${height} --fps ${framerate} --ref 4 --frame-thread 1 --no-wpp --bitrate ${rate} --no-pmode --no-pme --slices 0 --lookahead-slices 0 --ssim --tune ssim --qg-size 64 --aq-mode 1 --aq-strength 1.0 --b-adapt 2 --bframes 15 --keyint 5000 --max-tlayer 4 -o output.265" >> ${sub_file}
            #echo "arguments       =  --preset medium --pass 1 --input ${sequence_dir}/${sequence_name} --input-res ${width}x${height} --fps ${framerate} --ref 4 --bitrate ${rate} --ssim --tune ssim --qg-size 64 --aq-mode 1 --aq-strength 1.0 --b-adapt 1 --bframes 15 --keyint 5000 --max-tlayer 4 -o output.265" >> ${sub_file}
            echo "queue" >> ${sub_file}
            condor_submit ${sub_file}
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
            cd ${seq}_${rate}
            if [ -f ${seq}_${rate}.error ]
            then
                mv ${seq}_${rate}.error ${seq}_${rate}.error.1
            fi
            if [ -f ${seq}_${rate}_job.sub ]
            then
                rm ${seq}_${rate}_job.sub
            fi
            if [ -f ${seq}_${rate}.output ]
            then
                mv ${seq}_${rate}.output ${seq}_${rate}.output.1
            fi
            if [ -f ${seq}_${rate}.csv ]
            then
                rm *.csv
            fi
            if [ -f output.265 ]
            then
                rm output.265
            fi
            if [ -f ${seq}_${rate}.log ]
            then
                mv ${seq}_${rate}.log ${seq}_${rate}.log.1
            fi
            cd ..
            sub_file=${basepath}/${seq}_${rate}/${seq}_${rate}_job.sub
            echo ${seq}_${rate}
            echo "universe        = vanilla" > ${sub_file}
            echo "executable      = x265" >> ${sub_file}
            echo "initialdir      = ${basepath}/${seq}_${rate}" >> ${sub_file}
            echo "error           = ${seq}_${rate}.error" >> ${sub_file}
            echo "log             = ${seq}_${rate}.log" >> ${sub_file}
            echo "output          = ${seq}_${rate}.output" >> ${sub_file}
            echo "notification    = error" >> ${sub_file}
            echo "should_transfer_files = YES" >> ${sub_file}
            echo "run_as_owner    = True" >> ${sub_file}
            echo "priority        = 10" >> ${sub_file}
            echo "arguments       =  --preset veryslow --min-keyint 1 --pass 2 --input ${sequence_dir}/${sequence_name} --input-res ${width}x${height} --fps ${framerate} --ref 4 --frame-thread 1 --no-wpp --bitrate ${rate} --no-pmode --no-pme --slices 0 --lookahead-slices 0 --ssim --tune ssim --qg-size 64 --aq-mode 1 --aq-strength 1.0 --b-adapt 2 --bframes 15 --keyint 5000 -o output.265 --csv ${seq}_${rate}.csv --stats ${basepath}/${seq}_${rate}/x265_2pass.log" >> ${sub_file}
            #echo "arguments       =  --preset medium --pass 2 --input ${sequence_dir}/${sequence_name} --input-res ${width}x${height} --fps ${framerate} --ref 4 --frame-thread 1 --no-wpp --bitrate ${rate} --no-pmode --no-pme --slices 0 --lookahead-slices 0 --ssim --tune ssim --qg-size 64 --aq-mode 1 --aq-strength 1.0 --b-adapt 1 --bframes 15 --keyint 5000 --max-tlayer 4 -o output.265 --csv ${seq}_${rate}.csv --stats ${basepath}/${seq}_${rate}/x265_2pass.log" >> ${sub_file}
            #echo "arguments       =  --preset medium --pass 2 --input ${sequence_dir}/${sequence_name} --input-res ${width}x${height} --fps ${framerate} --ref 4 --bitrate ${rate} --ssim --tune ssim --qg-size 64 --aq-mode 1 --aq-strength 1.0 --b-adapt 1 --bframes 15 --keyint 5000 --max-tlayer 4 -o output.265 --csv ${seq}_${rate}.csv --stats ${basepath}/${seq}_${rate}/x265_2pass.log" >> ${sub_file}
            echo "queue" >> ${sub_file}
            condor_submit ${sub_file}
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

