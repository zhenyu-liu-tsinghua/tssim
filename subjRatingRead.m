function [subjRate] = subjRatingRead(vId, seqName)
% Inputs:
%           vId                     :   rating file handle
%           seqName                 :   sequence name
% Outputs:
%           subjRate                :   poc -> encorder

fid = fopen(vId,'rt');           % Open the x265_2pass log file
%read options in the first line 
tline=fgetl(fid);

while (tline ~= -1)
    if contains(tline, seqName)
        params = textscan(tline,'%s	%f	%f',1);
        subjRate = params{2};
        break;
    else
        tline=fgetl(fid);
    end
end

fclose(fid);
