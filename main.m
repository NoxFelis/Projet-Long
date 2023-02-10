clear;
close all;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% récupération des données
source_path = "../SERNIN/";
% source_path = "../SOULAGES/";

% parcourir toutes les images
% trouver où se situe la/les boules
% estimer l'éclairage
% comparer avec estimation déjà obtenue
% faire la stéréophotométrie
% voir résultats