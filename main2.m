close all
clear all   
load eclairages_sernin_mono.mat

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

%% récupération des données du fichiers raw
ref = rawread(source_path + "DSC_0012.NEF");
[row,col] = size(ref);
ref_info = rawinfo(source_path + "DSC_0012.NEF");
mask_r = mask_from_canal(source_path + "DSC_0012.NEF",'R');
mask_g = mask_from_canal(source_path + "DSC_0012.NEF",'G');
mask_b = mask_from_canal(source_path + "DSC_0012.NEF",'B');


%% affichage simple avec raw2rgb
figure;
title("image avec raw2rgb")
ref_jpg = raw2rgb(source_path + "DSC_0012.NEF");
imshow(ref_jpg);

%% pipeline à la main et affichage avec bayer
figure;
subplot(1,3,1);
title("affichage avant traitement");
imshow(ref);

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
maxValue = max(ref(:))
ref = ref ./ maxValue;


subplot(1,3,2);
title("with the black balance");
imshow(ref);


% adjust white balance
whiteBalance = colorInfo.CameraAsTakenWhiteBalance

gLoc = strfind(ref_info.CFALayout,"G"); 
gLoc = gLoc(1);
whiteBalance = whiteBalance/whiteBalance(gLoc);

whiteBalance = reshape(whiteBalance,[1 1 numel(whiteBalance)]);
whiteBalance = planar2raw(whiteBalance);

whiteBalance = repmat(whiteBalance,repeatDims);
refWB = ref .* whiteBalance;

refWB = im2uint16(refWB);

subplot(1,3,3);
title("with the black and white balance");
imshow(refWB);

%% Plot with the bayer pattern
figure
title("picture with bayer pattern");
ref_bayer = uint16(zeros(row*col,3));
ref_bayer(mask_r,1) = refWB(mask_r);
ref_bayer(mask_g,2) = refWB(mask_g);
ref_bayer(mask_b,3) = refWB(mask_b);
ref_bayer = reshape(ref_bayer,[row,col,3]);
imshow(ref_bayer);