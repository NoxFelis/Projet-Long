clear all;
close all;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% récupération des données
source_path = "../SERNIN/FACE/";
% source_path = "../SOULAGES/";
path_boule_mask_full = "Boule_mask_rot2.png";
path_boule_mask = "Boule2.png";

mask_3 = repmat(imread(path_boule_mask_full),[1 1 3]);
mask = repmat(imread(path_boule_mask),[1 1 3]);
% position of mask:
%rect = [6013 4682 442 442]; % x y
%center = [6235 4904]; %x y

rect = [6024 4695 424 424];
center = [6237 4908];

% parcourir toutes les images
A = readlines(source_path + "list.txt");


for i=1:size(A,1)
% trouver où se situe la/les boules
    image = imread(source_path+A(i));
    boule = imcrop(image,rect);
    boule(~mask) = 0;
    imshow(boule)

% estimer l'éclairage
% comparer avec estimation déjà obtenue
% faire la stéréophotométrie
% voir résultats
end