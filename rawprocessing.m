function refWB = rawprocessing(raw,ref_info,bayer)
if isa(raw,'string')
    ref = rawread(raw);
    [row,col] = size(ref);
    ref_info = rawinfo(raw);
else
    ref = raw;
end
    

% linearize cfa image
colorInfo = ref_info.ColorInfo;
maxLinValue = 10^4;
linTable = colorInfo.LinearizationTable;

%scale pixel values to suitable range
% perform black level correction
blackLevel = colorInfo.BlackLevel;
blackLevel = reshape(blackLevel,[1 1 numel(blackLevel)]);
blackLevel = planar2raw(blackLevel);
repeatDims = ref_info.ImageSizeInfo.VisibleImageSize ./ size(blackLevel);
blackLevel = repmat(blackLevel,repeatDims);
ref = ref - blackLevel;

%clamp negative pixel values
ref = max(0,ref);

%scale pixel values
ref = double(ref);
maxValue = max(ref(:));
ref = ref ./ maxValue;

% adjust white balance
whiteBalance = colorInfo.CameraAsTakenWhiteBalance;

gLoc = strfind(ref_info.CFALayout,"G"); 
gLoc = gLoc(1);
whiteBalance = whiteBalance/whiteBalance(gLoc);

whiteBalance = reshape(whiteBalance,[1 1 numel(whiteBalance)]);
whiteBalance = planar2raw(whiteBalance);

whiteBalance = repmat(whiteBalance,repeatDims);
refWB = ref .* whiteBalance;

refWB = im2uint16(refWB);

if size(bayer)>0
    mask_r = bayer(:,1);
    mask_g = bayer(:,2);
    mask_b = bayer(:,3);

    ref_bayer = uint16(zeros(row*col,3));
    ref_bayer(mask_r,1) = refWB(mask_r);
    ref_bayer(mask_g,2) = refWB(mask_g);
    ref_bayer(mask_b,3) = refWB(mask_b);
    refWB = reshape(ref_bayer,[row,col,3]);
end

end