close all; clear all;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

load SOULAGES;

[nb_groupe, ~, row, col] = size(Images);

image_hdr = zeros(nb_groupe, row, col);
temps_expo = zeros(nb_groupe, row, col);
masque = ones(row, col);
exterieur = find(masque==0);

for i = 1:nb_groupe
    [image_hdr(i, :, :), temps_expo(i, :, :)] = hdr(squeeze(Images(i, :, :, :)), ExposureTime(i, :));
    figure,
    imshow(squeeze(image_hdr(i, :, :)));
end
[rho, N] = estimation_HDR(image_hdr(:, :), temps_expo(:, :), Eclairage', masque(:));

% Intégration du champ de normales :
N(3,exterieur) = 1;			% Pour éviter les divisions par 0
p_estime = reshape(-N(1,:)./N(3,:),size(masque));
p_estime(exterieur) = 0;
q_estime = reshape(-N(2,:)./N(3,:),size(masque));
q_estime(exterieur) = 0;
z_estime_gray = integration_SCS(q_estime,p_estime);

% Ambiguïté concave/convexe :
if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
	z_estime_gray = z_estime_gray;
end
z_estime_gray(exterieur) = NaN;

% Affichage de l'albédo et du relief :
figure('Name','Albedo et relief','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(rho,z_estime_gray);


[rho, N] = estimation_HDR(image_hdr(:, :), temps_expo(:, :), Eclairage', masque(:));

% Intégration du champ de normales :
N(3,exterieur) = 1;			% Pour éviter les divisions par 0
p_estime = reshape(-N(1,:)./N(3,:),size(masque));
p_estime(exterieur) = 0;
q_estime = reshape(-N(2,:)./N(3,:),size(masque));
q_estime(exterieur) = 0;
z_estime_gray = integration_SCS(q_estime,p_estime);

% Ambiguïté concave/convexe :
if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
	z_estime_gray = z_estime_gray;
end
z_estime_gray(exterieur) = NaN;

% Affichage de l'albédo et du relief :
figure('Name','Albedo et relief','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(rho,z_estime_gray);
