clear all;
close all;

%% Emplacements des données
source_path = "../SERNIN/FACE/";
boule_mask_path = "Boule_mask.png";
list_path = "list.txt";

%% Récupération des données
boule_mask = imread(boule_mask_path);
boule_mask_3 = repmat(boule_mask,[1,1,3]);
name_pics = readlines(list_path);

%% Position de la sphère
rect = [6021 4684  424 424];
rayon = 425/2;

%% processing pour verification
% ref = rawread(source_path + "DSC_0012.NEF");
% ref_info = rawinfo(source_path + "DSC_0012.NEF");
% mask_r = mask_from_canal(ref,ref_info, "R");
% mask_g = mask_from_canal(ref,ref_info, "G");
% mask_b = mask_from_canal(ref,ref_info, "B");
% bayer = [mask_r(:) mask_g(:) mask_b(:)];

% refWB = rawprocessing(source_path + "DSC_0012.NEF",[]);

%% Préparation des sphères pour l'étalonnage de l'éclairage
spheres = [];
for i=1:size(name_pics,1)-1
% trouver où se situe la/les boules
    image = rawprocessing(source_path+name_pics(i) + ".NEF",[],[]);
    boule = imcrop(image,rect);
    boule(~boule_mask) = 0;
    spheres = cat(3,spheres,boule);
end

%% Etalonnage de l'éclairage
s = etalonnage(spheres,~boule_mask,[rayon rayon],rayon)';
[theta,phi] = conversion(s);

%% Création des masques de mosaique
img = rawread(source_path + "DSC_0012.NEF");
img_info = rawinfo(source_path + "DSC_0012.NEF");
mask_r = mask_from_canal(img,img_info,"R");
mask_g = mask_from_canal(img,img_info,"G");
mask_b = mask_from_canal(img,img_info,"B");
bayer = [mask_r(:) mask_g(:) mask_b(:)];

%% Sauvegarde des données

save eclairages_sernin_mono_raw s source_path name_pics bayer