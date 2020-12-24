clc; clear; close all;

rating_rcd = 'recode_vqdb.csv';

fid_rcd = fopen(rating_rcd,'rt');

[status, result] = system(['wc -l <', rating_rcd]);

lineNum = str2num(result);

ssimRcd = zeros(lineNum,2);
tssimRcd = zeros(lineNum,2);
tartssimRcd = zeros(lineNum,2);
vmadRcd = zeros(lineNum,2);
psnrRcd = zeros(lineNum,2);
ssimRcd = zeros(lineNum,2);
msssimRcd = zeros(lineNum,2);

tline=fgetl(fid_rcd);
line = 1;

while (tline ~= -1)
    params = textscan(tline,'%s subj=%f, tssim=%f, tartssim=%f, vmaf=%f, psnr=%f, ssim=%f, ms_ssim=%f',1);
    subjRate = params{2};
    tssim = params{3};
    tartssim =  params{4};
    vmaf = params{5};
    psnr = params{6};
    ssim = params{7};
    msssim = params{8};
    tssimRcd(line, 1) = subjRate;
    tssimRcd(line, 2) = tssim;
    tartssimRcd(line, 1) = subjRate;
    tartssimRcd(line, 2) = tartssim;
    vmafRcd(line, 1) = subjRate;
    vmafRcd(line, 2) = vmaf;
    psnrRcd(line, 1) = subjRate;
    psnrRcd(line, 2) = psnr;
    ssimRcd(line, 1) = subjRate;
    ssimRcd(line, 2) = ssim;
    msssimRcd(line, 1) = subjRate;
    msssimRcd(line, 2) = msssim;

    line = line + 1;
    tline=fgetl(fid_rcd);    
end

normSsimRcd = (ssimRcd-mean(ssimRcd,1))./std(ssimRcd);
normTssimRcd = (tssimRcd-mean(tssimRcd,1))./std(tssimRcd);
normTartssimRcd = (tartssimRcd-mean(tartssimRcd,1))./std(tartssimRcd);
normVmafRcd = (vmafRcd - mean(vmafRcd,1))./std(vmafRcd);
normMsssimRcd = (msssimRcd - mean(msssimRcd,1))./std(msssimRcd);
normPsnrRcd = (psnrRcd - mean(psnrRcd,1))./std(psnrRcd);

[Ussim,Sssim,Vssim] = svd(normSsimRcd'*normSsimRcd);
[Utssim,Stssim,Vtssim] = svd(normTssimRcd'*normTssimRcd);
[Utartssim,Startssim,Vtartssim] = svd(normTartssimRcd'*normTartssimRcd);
[Uvmaf,Svmaf,Vvmaf] = svd(normVmafRcd'*normVmafRcd);
[Umsssim,Smsssim,Vmsssim] = svd(normMsssimRcd'*normMsssimRcd);
[Upsnr,Spsnr,Vpsnr] = svd(normPsnrRcd'*normPsnrRcd);

figure(1);
plot(normTartssimRcd(:,1),normTartssimRcd(:,2),'b*', normVmafRcd(:,1), normVmafRcd(:,2), 'r<', ...
    normSsimRcd(:,1),normSsimRcd(:,2),'go', normMsssimRcd(:,1), normMsssimRcd(:,2), 'k+', ...
    normPsnrRcd(:,1), normPsnrRcd(:,2), 'ms');
legend('tssim','vmaf','ssim','msssim', 'psnr');
xlabel('normalized subject rating (higher rating is worse quality)');
ylabel('normalized TSSIM/VMAF/SSIM/MSSIM/PSNR');

figure(2);
plot(tartssimRcd(:,1),100*tartssimRcd(:,2),'b*',vmafRcd(:,1),vmafRcd(:,2),'r<', ...
    ssimRcd(:,1),100*ssimRcd(:,2),'go', msssimRcd(:,1), 100*msssimRcd(:,2), 'k+', ...
    psnrRcd(:,1), psnrRcd(:,2), 'ms');

legend('tssim','vmaf','ssim','msssim', 'psnr');
xlabel('DMOS (higher rating is worse quality)');
ylabel('100*TSSIM/VMAF/100*SSIM/100*MSSIM/PSNR');

figure(3);
plot(tartssimRcd(:,1),100*tartssimRcd(:,2),'b*',vmafRcd(:,1),vmafRcd(:,2),'r<', ...
    ssimRcd(:,1),100*ssimRcd(:,2),'go');
legend('tssim','vmaf','ssim');
xlabel('DMOS (higher rating is worse quality)');
ylabel('100*TSSIM/VMAF/100*SSIM');

SSIM_deviation = Sssim(2,2) / Sssim(1,1);
TSSIM_deviation = Stssim(2,2) / Stssim(1,1);
TARTSSIM_deviation = Startssim(2,2) / Startssim(1,1);
VMAF_deviation = Svmaf(2,2) / Svmaf(1,1);
MSSSIM_deviation = Smsssim(2,2) / Smsssim(1,1);
PSNR_deviation = Spsnr(2,2) / Spsnr(1,1);
SSIM_corr = corrcoef(ssimRcd);
TSSIM_corr = corrcoef(tssimRcd);
TARTSSIM_corr = corrcoef(tartssimRcd);
VMAF_corr = corrcoef(vmafRcd);
MSSSIM_corr = corrcoef(msssimRcd);
PSNR_corr = corrcoef(psnrRcd);
fclose(fid_rcd);
