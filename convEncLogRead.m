function [encOrder, frameNum, frameWidth, frameHeight, frameCutree, frameDuration] = convEncLogRead(vid)

% Inputs:
%           vid                     :   x265_2pass log name
% Outputs:
%           encOrder                :   poc -> encorder
%           frameNum                :   encoded frame number
%           frameWidth, frameHeight :   frame size
%           frameCutree             :   frame grain cutree strength

fid = fopen(vid,'rt');           % Open the x265_2pass log file
%read options in the first line 
tline=fgetl(fid);

%params = textscan(tline,'#options: cpuid=%d frame-threads=%d numa-pools=%s %s %s %s %s %s log-level=%d csvfn=%s csv-log-level=%d bitdepth=%d fps=%d/%d input-res=%dx%d interlace=%d total-frames=%d ');
%params = textscan(tline,'#options: cpuid=%d frame-threads=%d ');

%framethreads = params{2};

%if framethreads == 1
%    params = strread(tline,' csv-log-level=%d ');
%end

if isempty(strfind(tline, 'numa-pools'))
    if isempty(strfind(tline, 'csvfn'))
        params = textscan(tline,'#options: cpuid=%d frame-threads=%d %s %s %s %s %s log-level=%d bitdepth=%d input-csp=%d fps=%f/%f input-res=%dx%d interlace=%d total-frames=%d ', 1);
        frameNum = params{16};
        frameWidth = params{13};
        frameHeight = params{14};
        frameRate = params{11} / params{12};
        frameDuration = 1000.0 / frameRate;
    end
end


encOrder = zeros(1,frameNum);
frameCutree = zeros(1,frameNum);
for iFrame = 1:frameNum
    tline=fgetl(fid);
    if isempty(strfind(tline, 'tlayer'))
        params = textscan(tline,'in:%d out:%d type:%s q:%f q-aq:%f q-noVbv:%f q-Rceq:%f tex:%d mv:%d misc:%d icu:%f pcu:%f scu:%f avgQpOffsetCutree:%f',1);
        poc = params{1} + 1;
        ec = params{2} + 1;
        encOrder(poc) = ec;
        slicetype = char(params{3});
        %if( strcmp(slicetype, 'P'))
        %    prePCUtree = max(params{4} - params{5},0);
        %    frameCutree(ec) = prePCUtree;
        %elseif( strcmp(slicetype, 'I'))
        %    frameCutree(ec) = max(params{4} - params{5},0);
        %else
        %    frameCutree(ec) = prePCUtree;
        %end
        %frameCutree(ec) = max(params{4} - params{5},0);
        frameCutree(ec) = max(-params{14},0);
    else
        params = textscan(tline,'in:%d out:%d type:%s q:%f q-aq:%f q-noVbv:%f q-Rceq:%f tex:%d mv:%d misc:%d icu:%f pcu:%f scu:%f tlayer:%d pbqpoffset:%f pbfactor:%f avgQpOffsetCutree:%f',1);
        poc = params{1} + 1;
        ec = params{2} + 1;
        encOrder(poc) = ec;
        slicetype = char(params{3});
        frameCutree(ec) = max(-params{17},0);
        %frameCutree(ec) = max(-params{17},0);
    end
end
fclose(fid);
