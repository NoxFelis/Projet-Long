close all; clear all;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

load SOULAGES;


[nb_groupe, ~, row, col] = size(Images_mosaic);

image_hdr_mosaic = zeros(nb_groupe, row, col);
image_hdr_gray = zeros(nb_groupe, row, col);
temps_expo_mosaic = zeros(nb_groupe, row, col);
temps_expo_gray = zeros(nb_groupe, row, col);
masque = ones(row, col);
exterieur = find(masque==0);

for i = 1:nb_groupe
    [image_hdr_mosaic(i, :, :), temps_expo_mosaic(i, :, :)] = hdr(squeeze(Images_mosaic(i, :, :, :)), ExposureTime(i, :));
    [image_hdr_gray(i, :, :), temps_expo_gray(i, :, :)] = hdr(squeeze(Images_gray(i, :, :, :)), ExposureTime(i, :));
end
[rho_mosaic, N_mosaic] = estimation_HDR(image_hdr_mosaic(:, :), temps_expo_mosaic(:, :), Eclairage', masque(:));
[rho_gray, N_gray] = estimation_HDR(image_hdr_gray(:, :), temps_expo_gray(:, :), Eclairage', masque(:));

%% Image mosaiquée
rho_mosaic = reshape(rho_mosaic, [row col]);
% Intégration du champ de normales :
N_mosaic(3,exterieur) = 1;			% Pour éviter les divisions par 0
p_estime = reshape(-N_mosaic(1,:)./N_mosaic(3,:),size(masque));
p_estime(exterieur) = 0;
q_estime = reshape(-N_mosaic(2,:)./N_mosaic(3,:),size(masque));
q_estime(exterieur) = 0;
z_estime_gray = integration_SCS(q_estime,p_estime);

% Ambiguïté concave/convexe :
if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
	z_estime_gray = z_estime_gray;
end
z_estime_gray(exterieur) = NaN;

% Affichage de l'albédo et du relief :
figure('Name','Albedo et relief','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(uint16(rho_mosaic),z_estime_gray);

%% Image grise
rho_gray = reshape(rho_gray, [row col]);
% Intégration du champ de normales :
N_gray(3,exterieur) = 1;			% Pour éviter les divisions par 0
p_estime = reshape(-N_gray(1,:)./N_gray(3,:),size(masque));
p_estime(exterieur) = 0;
q_estime = reshape(-N_gray(2,:)./N_gray(3,:),size(masque));
q_estime(exterieur) = 0;
z_estime_gray = integration_SCS(q_estime,p_estime);

% Ambiguïté concave/convexe :
if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
	z_estime_gray = z_estime_gray;
end
z_estime_gray(exterieur) = NaN;

% Affichage de l'albédo et du relief :
figure('Name','Albedo et relief','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(uint16(rho_gray),z_estime_gray);
