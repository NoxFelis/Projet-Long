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

mask = imread(path_boule_mask);
mask_3 = repmat(mask,[1 1 3]);
% position of mask:
rect = [6024 4695 424 424];
centre = [6236.5 4907.5];
rayon = 425/2;

% parcourir toutes les images
A = readlines("list.txt");

spheres = [];
for i=1:size(A,1)-1
% trouver où se situe la/les boules
    image = imread(source_path+A(i));
    boule = imcrop(image,rect);
    boule(~mask_3) = 0;
    spheres = cat(3,spheres,rgb2gray(boule));
    %imshow(boule)

% estimer l'éclairage
% comparer avec estimation déjà obtenue
% faire la stéréophotométrie
% voir résultats
end

s = etalonnage(spheres,~mask,[rayon rayon],rayon);

[theta,phi] = conversion(s);
plot(theta,phi,'o','Color','r','LineWidth',4,'MarkerSize',10);
xlabel('$\theta$','Interpreter','Latex','FontSize',20);
ylabel('$\phi$','Interpreter','Latex','FontSize',20);
axis([0,pi/2,-pi,pi]);