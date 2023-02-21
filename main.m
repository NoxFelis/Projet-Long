close all
clear all
load eclairages_sernin_mono.mat

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% zone de reconstruction:
figure
ref = imread(source_path + "DSC_0012.JPG");
ref = rot90(ref);
imshow(ref);
zone = getrect;
zone = round(zone);
dame_mask = true(zone(4)+1,zone(3)+1);
hold on
rectangle('Position',zone,'EdgeColor','b','LineWidth',1.5);

I = [];
for i=1:size(name_pics,1)-1
    image = imread(source_path+name_pics(i));
    image = rot90(image);
    image = rgb2gray(image);
    image = imcrop(image,zone);
    I = [I; image(:)'];
end

%% Affichage des eclairages
% plot(theta,phi,'o','Color','r','LineWidth',4,'MarkerSize',10);
% xlabel('$\theta$','Interpreter','Latex','FontSize',20);
% ylabel('$\phi$','Interpreter','Latex','FontSize',20);
% axis([0,pi/2,-pi,pi]);

% [x,y,z] = sph2cart(theta,phi,1);
% theta2 = linspace(0,2*pi);
% phi2 = linspace(-pi/2,pi/2);
% [theta2,phi2] = meshgrid(theta2,phi2);
% [x2,y2,z2] = sph2cart(theta2,phi2,1);
% surf(x2,y2,z2);
% hold on
% plot3(x,y,z, '*r')

%% STEREOPHOTOMETRIE EN NIVEAU DE GRIS

% Les données contiennent :
%	* I (n x p) : matrice des niveaux de gris (transpose(I(i,:)) est l'image numéro i vectorisée)
%	* N (3 x p) : vérité terrain des normales (si elles sont connues)
%	* S (n x 3) : matrice des éclairages (transpose(S(i,:)) est le vecteur d'éclairage numéro i)
%	* Z (nb_lignes x nb_colonnes) : vérité terrain de la profondeur (si elle est connue)
%	* masque (nb_lignes x nb_colonnes) : masque de l'objet à reconstruire
%	* rho (nb_lignes x nb_colonnes) : vérité terrain de l'albédo (s'il est connu)

[nb_lignes,nb_colonnes] = size(dame_mask);
interieur = find(dame_mask>0);		% Intérieur du domaine de reconstruction
exterieur = find(dame_mask==0);		% Extérieur du domaine de reconstruction
[n,p] = size(I);			% n = nombre d'images, p = nombre de pixels
I = cast(I,'double');
% Estimation de M, rho et N :
%dame_mask = dame_mask(:);
[rho_estime,N_estime] = estimation(I,s,dame_mask);

% Intégration du champ de normales :
N_estime(3,exterieur) = 1;			% Pour éviter les divisions par 0
p_estime = reshape(-N_estime(1,:)./N_estime(3,:),size(dame_mask));
p_estime(exterieur) = 0;
q_estime = reshape(-N_estime(2,:)./N_estime(3,:),size(dame_mask));
q_estime(exterieur) = 0;
z_estime = integration_SCS(q_estime,p_estime);

% Ambiguïté concave/convexe :
if (z_estime(floor(nb_lignes/2),floor(nb_colonnes/2))<z_estime(1,1))
	z_estime = -z_estime;
end
z_estime(exterieur) = NaN;

% Affichage de l'albédo et du relief :
figure('Name','Albedo et relief','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief(rho_estime,z_estime);

