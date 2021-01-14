# TSSIM
Temporal Structural Similarity index, one full-reference video quality assessment that estimates the duration of one error signal, with which we can derive the temporal weighting of this error. The experiments on two open source video
bases, i.e., LIVE and CISQ, demonstrated that TSSIMoutperformed
the state-of-the-art algorithm Video Multi-Method Assessment Fusion
(VMAF).

## Contact
Author: Zhenyu Liu;<br />
Address: 4-305, FIT Building, Tsinghua University, Beijing (100084), China;<br />
Email: liuzhenyu73@tsinghua.edu.cn

## Usage

### generate log file
With x265 (compiled under CentOS 7) in the directory''log-generator'', we generate the log file for computing
the average delta QP of every frame. The command line example is

```
./x265 --pass 1 -rc-lookahead 32 --preset ultrafast --min-keyint 1 --input ${sequence_dir}/${sequence_name} --input-res ${width}x${height} --fps ${framerate} --ref 4 --frame-thread 1 --no-wpp --bitrate ${rate} --no-pmode --no-pme --slices 0 --lookahead-slices 0 --psnr --tune psnr --qg-size 64 --b-adapt 2 --bframes 15 --keyint 5000 -o output-pass1.265
```
where, ${sequence\_dir}/${sequence\_name} indicates the compressed video with distortions
(For example, BasketballDrive\_832x480\_dst\_16.yuv in CISQ database) in YUV
format. This procedure is to analyze the distortion signal dusration, which is recoded
in ''x265\_2pass.log''. The variables ${framerate}, ${width}, ${height} represent the
frame rate, the frame width and the frame height of the distorted video. ${rate}
represents the target rate. One critical value ''avgQpOffsetCutree'' in ''x265\_2pass.log''
recodes the averaged delta QP of every frame. It should be noticed that the function
of x265 is for generating ''x265\_2pass.log'', which will be applied in TSSIM.

### compute TSSIM

video\_seq\_temporal\_conv\_ssim\_artifacts\_vs\_subject.m is the main program
for the TSSIM computation. At present, we support YUV420 8-bit
video format.<br />

The inputs include _dec\_seq\_base\_dir_ and _seq\_cfg_.<br />

_dec\_seq\_base\_dir_: The base directory of the temporal analysis for distorted videos.
For example, in this example, its value is ''./cutree/''. In the base directory,
each video has its dedicated subdirectory. The subdirectory name is determined by the 
configurations in _seq\_cfg_, which will be explained.<br />

_seq\_cfg_: Each line in _seq\_cfg_ contains the following terms in order: The directory of 
YUV videos, YUV file name, frame width, frame height, frame rate, bitrate in log
generation, and video type (REF:the reference video; DEC:the decoded video).<br />

For example, the first line in sequence\_cisqdb\_subject\_evaluation\_file.txt is<br />
/Users/zhenyu/Documents/video\_sequence/cisq\_database BasketballDrive\_832x480\_ref.yuv 832 480 50 2000 REF<br />
which indicates that the reference ''BasketballDrive\_832x480\_ref.yuv'' in the
diretory ''/Users/zhenyu/Documents/video\_sequence/cisq\_database'' with 832x480 frame
size and 50fps frame rate.<br />

The second line, i.e.,<br />
/Users/zhenyu/Documents/video\_sequence/cisq\_database BasketballDrive\_832x480\_dst\_16.yuv 832 480 50 2000 DEC
indciates that ''BasketballDrive\_832x480\_dst\_16.yuv'' in ''/Users/zhenyu/Documents/video\_sequence/cisq\_database''
is a decoded video under quality analysis. Its temporal dependecy log file (x265\_2pass.log) is determined
by the ''YUV file name'' and the ''bitrate'' terms. For instance, the x265\_2pass.log of
''BasketballDrive\_832x480\_dst\_16.yuv'' is saved in the directory ''./cutree/BasketballDrive\_832x480\_dst\_16\_2000''.

### Data Analysis
rating\_variant\_analyze.m is applied the analyze the recodes generated
by video\_seq\_temporal\_conv\_ssim\_artifacts\_vs\_subject.m.
