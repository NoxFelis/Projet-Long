clear all;
close all;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

%% Récupération des données
source_path = "../../SERNIN/FACE/";
% source_path = "../SOULAGES/";
%path_boule_mask_full = "Boule_mask_rot2.png";
path_boule_mask = "Boule_vert.png";
path_dame_mask = "Dame_mask.png";

boule_mask = imread(path_boule_mask);
boule_mask_3 = repmat(boule_mask,[1 1 3]);
%dame_mask = imread(path_dame_mask);

% position of mask:
% % position horizontale : 
% % rect = [6024 4695 424 424]; % x y
% % centre = [6236.5 4907.5];

% position verticale  du masque de la boule:
rect = [4696 1808 424 424];
rayon = 425/2;

%zone = [2000 5000 1000 500];
%dame_mask = true(501,1001);

%% Estimation de l'eclairage
name_pics = readlines("../list.txt");

spheres = [];
for i=1:size(name_pics,1)-1
% trouver où se situe la/les boules
    image = imread(source_path+name_pics(i) + ".JPG");
    image = rot90(image);
    boule = imcrop(image,rect);
    boule(~boule_mask_3) = 0;
    spheres = cat(3,spheres,rgb2gray(boule));
end

% Estimer l'éclairage
s = etalonnage(spheres,~boule_mask,[rayon rayon],rayon)';
[theta,phi] = conversion(s);

%% Création des masques de mosaiquage
% ATTENTION: le motif est [vert rouge; bleu vert]
% ce pour l'image dans le bon sens (vertical)
% pour une image horizontale [bleu vert; vert rouge]
image = imread(source_path + "DSC_0012.JPG");
mask_r = rot90(mask_from_canal(image,"R"));
mask_b = rot90(mask_from_canal(image,"B"));
mask_g = rot90(mask_from_canal(image,"G"));

save eclairages_sernin_mono s source_path name_pics mask_r mask_g mask_b