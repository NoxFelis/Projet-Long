close all
clear all   
load eclairages_sernin_mono_raw.mat

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

%% Emplacement des données
dame_mask_path = "Dame_mask.png";

%% récupération des données du fichiers raw
ref = rawread(source_path + "DSC_0012.NEF");
[row,col] = size(ref);
ref_info = rawinfo(source_path + "DSC_0012.NEF");

%% affichage simple avec raw2rgb
figure;
title("image avec raw2rgb")
ref_jpg = raw2rgb(source_path + "DSC_0012.NEF");
ref_jpg = rot90(ref_jpg,3);
imshow(ref_jpg);


% %% Plot with the bayer pattern
% ref_bayer = rawprocessing(source_path + "DSC_0012.NEF",[],bayer);
% figure
% title("picture with bayer pattern");
% imshow(ref_bayer);

%% Selection de la zone de reconstruction
%zone = getrect;
%zone = round(zone);
zone = [4885,1149,888,1032]; % x y
%dame_mask = imread(dame_mask_path);
mask = true(zone(4)+1,zone(3)+1);

nb_images = size(name_pics,1)-1;
[nb_lignes,nb_colonnes] = size(mask);
interieur = find(mask>0);		% Intérieur du domaine de reconstruction
exterieur = find(mask==0);		% Extérieur du domaine de reconstruction

%affichage de la zone de reconstruction
hold on
rectangle('Position',zone,'EdgeColor','b','LineWidth',1.5);

%% Construction des matrices images
I_mosaic = []; %% mosaiquée mais dans un seul canal
I_gray = []; %% avec raw2rgb --> puis 2 gray
for i=1:nb_images
    image_gray = raw2rgb(source_path + name_pics(i) + ".NEF");
    image_gray = rot90(image_gray,3);
    image_gray = imcrop(image_gray,zone);
    image_gray = rgb2gray(image_gray);
    I_gray = [I_gray; image_gray(:)'];

    image_mosaic = rawprocessing(source_path + name_pics(i) + ".NEF",[],[]);
    image_mosaic = imcrop(image_mosaic,zone);
    I_mosaic = [I_mosaic; image_mosaic(:)'];
end

[n,p] = size(I_gray);			% n = nombre d'images, p = nombre de pixels


%% STEREOPHOTOMETRIE EN NIVEAUX DE GRIS
% Estimation de M, rho et N :
%dame_mask = dame_mask(:);
I_gray = cast(I_gray,'double');
[rho_estime_gray,N_estime_gray] = estimation(I_gray,s,mask);

% Intégration du champ de normales :
N_estime_gray(3,exterieur) = 1;			% Pour éviter les divisions par 0
p_estime = reshape(-N_estime_gray(1,:)./N_estime_gray(3,:),size(mask));
p_estime(exterieur) = 0;
q_estime = reshape(-N_estime_gray(2,:)./N_estime_gray(3,:),size(mask));
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

%% STEREOPHOTOMETRIE SANS DEMOSAIQUAGE
% Estimation de M, rho et N :
%dame_mask = dame_mask(:);
I_mosaic = cast(I_mosaic,'double');
[rho_estime_mosaic,N_estime_mosaic] = estimation(I_mosaic,s,mask);

% Intégration du champ de normales :
N_estime_mosaic(3,exterieur) = 1;			% Pour éviter les divisions par 0
p_estime = reshape(-N_estime_mosaic(1,:)./N_estime_mosaic(3,:),size(mask));
p_estime(exterieur) = 0;
q_estime = reshape(-N_estime_mosaic(2,:)./N_estime_mosaic(3,:),size(mask));
q_estime(exterieur) = 0;
z_estime_mosaic = integration_SCS(q_estime,p_estime);

% Ambiguïté concave/convexe :
if (z_estime_mosaic(floor(nb_lignes/2),floor(nb_colonnes/2))<z_estime_mosaic(1,1))
	z_estime_mosaic = z_estime_mosaic;
end
z_estime_mosaic(exterieur) = NaN;

% Affichage de l'albédo et du relief :
figure('Name','Albedo et relief','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(rho_estime_mosaic,z_estime_mosaic);
