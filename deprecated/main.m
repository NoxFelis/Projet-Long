close all
clear all
load eclairages_sernin_mono.mat
source_path = "../../SERNIN/FACE/";
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% zone de reconstruction:
figure
ref = imread(source_path + "DSC_0012.JPG");
ref = rot90(ref);
imshow(ref);
% zone = getrect;
% zone = round(zone);
zone = [1168, 2575, 960, 684];
dame_mask = true(zone(4)+1,zone(3)+1);
nb_images = size(name_pics,1)-1;
[nb_lignes,nb_colonnes] = size(dame_mask); 

hold on
rectangle('Position',zone,'EdgeColor','b','LineWidth',1.5);

I_gray = [];
I = [];
I_colour = [];
for i=1:nb_images
    image = imread(source_path+name_pics(i));
    image = rot90(image);
    image = imcrop(image,zone);
    image_gray = rgb2gray(image);
    I_gray = [I_gray; image_gray(:)'];
    
    image_colour = image(:,:,1);
    I_colour = [I_colour;  image_colour(:)'];

    image =  reshape(image,[nb_lignes*nb_colonnes,3]);
    image = permute(image,[3 1 2]);
    I = [I; image];
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


interieur = find(dame_mask>0);		% Intérieur du domaine de reconstruction
exterieur = find(dame_mask==0);		% Extérieur du domaine de reconstruction
[n,p] = size(I_gray);			% n = nombre d'images, p = nombre de pixels
I_gray = cast(I_gray,'double');

% Estimation de M, rho et N :
%dame_mask = dame_mask(:);
[rho_estime_gray,N_estime_gray] = estimation(I_gray,s,dame_mask);

% Intégration du champ de normales :
N_estime_gray(3,exterieur) = 1;			% Pour éviter les divisions par 0
p_estime = reshape(-N_estime_gray(1,:)./N_estime_gray(3,:),size(dame_mask));
p_estime(exterieur) = 0;
q_estime = reshape(-N_estime_gray(2,:)./N_estime_gray(3,:),size(dame_mask));
q_estime(exterieur) = 0;
z_estime_gray = integration_SCS(q_estime,p_estime);

% Ambiguïté concave/convexe :
if (z_estime_gray(floor(nb_lignes/2),floor(nb_colonnes/2))<z_estime_gray(1,1))
	z_estime_gray = z_estime_gray;
end
z_estime_gray(exterieur) = NaN;

% Affichage de l'albédo et du relief :
figure('Name','Albedo et relief','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(rho_estime_gray,z_estime_gray);

%% STEREOPHOTOMETRIE EN COULEUR

% Les données contiennent :
%	* I (n x p) : matrice des niveaux de gris (transpose(I(i,:)) est l'image numéro i vectorisée)
%	* N (3 x p) : vérité terrain des normales (si elles sont connues)
%	* S (n x 3) : matrice des éclairages (transpose(S(i,:)) est le vecteur d'éclairage numéro i)
%	* Z (nb_lignes x nb_colonnes) : vérité terrain de la profondeur (si elle est connue)
%	* masque (nb_lignes x nb_colonnes) : masque de l'objet à reconstruire
%	* rho (nb_lignes x nb_colonnes) : vérité terrain de l'albédo (s'il est connu)

I_colour = cast(I_colour,'double');

% Estimation de M, rho et N 
%dame_mask = dame_mask(:);
[rho_estime_colour,N_estime_colour] = estimation(I_colour,s,dame_mask);

% Intégration du champ de normales :
N_estime_colour(3,exterieur) = 1;			% Pour éviter les divisions par 0
p_estime = reshape(-N_estime_colour(1,:)./N_estime_colour(3,:),size(dame_mask));
p_estime(exterieur) = 0;
q_estime = reshape(-N_estime_colour(2,:)./N_estime_colour(3,:),size(dame_mask));
q_estime(exterieur) = 0;
z_estime_colour = integration_SCS(q_estime,p_estime);

% Ambiguïté concave/convexe :
if (z_estime_colour(floor(nb_lignes/2),floor(nb_colonnes/2))<z_estime_colour(1,1))
	z_estime_colour = z_estime_colour;
end
z_estime_colour(exterieur) = NaN;

% Affichage de l'albédo et du relief :
figure('Name','Albedo et relief','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(rho_estime_colour,z_estime_colour);


%% AFFICHAGE DIFFERENCE 
diff = abs(z_estime_gray - z_estime_colour);
figure;
surf(diff);
colormap cool

% %% ESTIMATION SANS DEMOSAICAGE
% mask_r_crop = imcrop(mask_r,zone);
% mask_g_crop = imcrop(mask_g,zone);
% mask_b_crop = imcrop(mask_r,zone);
% I_mosaique = zeros(nb_images,nb_lignes*nb_colonnes);
% I_mosaique(:,mask_r_crop(:)) = I(:,mask_r_crop(:),1);
% I_mosaique(:,mask_g_crop(:)) = I(:,mask_g_crop(:),2);
% I_mosaique(:,mask_b_crop(:)) = I(:,mask_b_crop(:),3);
% test = reshape(I_mosaique(1,:),[nb_lignes,nb_colonnes]);
% figure;
% imshow(cast(test,"uint8"))
% 
% 
% interieur = find(dame_mask>0);		% Intérieur du domaine de reconstruction
% exterieur = find(dame_mask==0);		% Extérieur du domaine de reconstruction
% [n,p] = size(I_mosaique);			% n = nombre d'images, p = nombre de pixels
% I_mosaique = cast(I_mosaique,'double');
% 
% [rho_estime,N_estime] = estimation(I_mosaique,s,dame_mask);
% % Intégration du champ de normales :
% N_estime(3,exterieur) = 1;			% Pour éviter les divisions par 0
% p_estime = reshape(-N_estime(1,:)./N_estime(3,:),size(dame_mask));
% p_estime(exterieur) = 0;
% q_estime = reshape(-N_estime(2,:)./N_estime(3,:),size(dame_mask));
% q_estime(exterieur) = 0;
% z_estime = integration_SCS(q_estime,p_estime);
% 
% % Ambiguïté concave/convexe :
% if (z_estime(floor(nb_lignes/2),floor(nb_colonnes/2))<z_estime(1,1))
% 	z_estime = z_estime;
% end
% z_estime(exterieur) = NaN;
% 
% % Affichage de l'albédo et du relief :
% figure('Name','Albedo et relief','Position',[0.6*L,0,0.2*L,0.7*H]);
% affichage_albedo_relief_tp(rho_estime,z_estime);
% 
