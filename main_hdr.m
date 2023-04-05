close all; clear all;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

load SOULAGES;
encodage = 0;
%encodage = 8; 
%encodage = 16;
%Images_gray_double = Images_gray/2^16;
Images_gray_double = Images_gray/max(Images_gray(:));
%Images_gray_double = Images_gray;
Images_mosaic = Images_mosaic/max(squeeze(Images_mosaic(:)));
%(2^16 - 1);

[nb_eclairage, nb_exposition, row, col] = size(Images_gray);

image_hdr_mosaic = zeros(nb_eclairage, row, col);
%temps_expo_mosaic = zeros(nb_eclairage, row, col);
image_hdr_gray = zeros(nb_eclairage, row, col);
%temps_expo_gray = zeros(nb_eclairage, row, col);
image_true_HDR = zeros(nb_eclairage, row, col);


masque = ones(row, col);
exterieur = find(masque==0);

for i = 1:nb_eclairage
    %[image_hdr_mosaic(i, :, :), temps_expo_mosaic(i, :, :)] = hdr(squeeze(Images_mosaic(i, :, :, :)), ExposureTime(i, :), 16);
    %[image_hdr_gray(i, :, :), temps_expo_gray(i, :, :)] = hdr(squeeze(Images_gray_double(i, :, :, :)), ExposureTime(i, :), encodage);
    image_hdr_mosaic(i, :, :) = hdr2(squeeze(Images_mosaic(i, :, :, :)), ExposureTime(i, :), encodage);
    image_hdr_gray(i, :, :) = hdr2(squeeze(Images_gray_double(i, :, :, :)), ExposureTime(i, :), encodage);
    %cell = mat2cell(squeeze(Images_gray(i, :, :, :)), ones(1, nb_exposition));
    %im = squeeze(Images_gray(i, :, :, :));
    cell = cell(1, nb_exposition);
    for j = 1:nb_exposition
	cell_tmp = mat2cell(squeeze(uint16(Images_gray(i, j, :, :))), [row 0], [col 0]);
	cell(1, j) = cell_tmp(1, 1);
    end
    image_true_HDR(i, :, :) = makehdr(cell, 'ExposureValues', squeeze(ExposureTime(i, :)));
end

image_true_HDR = image_true_HDR/max(image_true_HDR(:));

%tmp = Eclairage(1, :);
%Eclairage(1, :) = Eclairage(2, :);
%Eclairage(2, :) = tmp;

%[rho_mosaic, N_mosaic] = estimation_HDR(image_hdr_mosaic(:, :), temps_expo_mosaic(:, :), Eclairage', masque(:));
%[rho_gray, N_gray] = estimation_HDR(image_hdr_gray(:, :), temps_expo_gray(:, :), Eclairage', masque(:));
[rho_mosaic, N_mosaic] = estimation(image_hdr_mosaic(:, :), Eclairage', masque(:));
[rho_gray, N_gray] = estimation(image_hdr_gray(:, :), Eclairage', masque(:));
[rho_HDR, N_HDR] = estimation(image_true_HDR(:, :), Eclairage', masque(:)); 
[rho_1, N_1] = estimation(squeeze(Images_gray_double(:, 1, :)), Eclairage', masque(:));
[rho_2, N_2] = estimation(squeeze(Images_gray_double(:, 2, :)), Eclairage', masque(:));
[rho_3, N_3] = estimation(squeeze(Images_gray_double(:, 3, :)), Eclairage', masque(:));
[rho_4, N_4] = estimation(squeeze(Images_gray_double(:, 4, :)), Eclairage', masque(:));


%%% Image grise sans HDR 1
%rho_1 = reshape(rho_1, [row col]);
%% Intégration du champ de normales :
%N_1(3,exterieur) = 1;			% Pour éviter les divisions par 0
%p_estime = reshape(-N_1(1,:)./N_1(3,:),size(masque));
%p_estime(exterieur) = 0;
%q_estime = reshape(-N_1(2,:)./N_1(3,:),size(masque));
%q_estime(exterieur) = 0;
%z_estime_gray = integration_SCS(q_estime,p_estime);
%
%% Ambiguïté concave/convexe :
%if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
%	z_estime_gray = z_estime_gray;
%end
%z_estime_gray(exterieur) = NaN;
%
%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'off','Name',strcat('Stéréophotométrie sur images démosaïquées Dt = ', num2str(ExposureTime(1,1))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_1,z_estime_gray, [min(rho_1(:)) max(rho_1(:))]);
%saveas(f, './output/Stereo_demo_1.jpg');
%
%%% Image grise sans HDR 2
%rho_2 = reshape(rho_2, [row col]);
%% Intégration du champ de normales :
%N_2(3,exterieur) = 1;			% Pour éviter les divisions par 0
%p_estime = reshape(-N_2(1,:)./N_2(3,:),size(masque));
%p_estime(exterieur) = 0;
%q_estime = reshape(-N_2(2,:)./N_2(3,:),size(masque));
%q_estime(exterieur) = 0;
%z_estime_gray = integration_SCS(q_estime,p_estime);
%
%% Ambiguïté concave/convexe :
%if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
%	z_estime_gray = z_estime_gray;
%end
%z_estime_gray(exterieur) = NaN;
%
%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'off','Name',strcat('Stéréophotométrie sur images démosaïquées Dt = ', num2str(ExposureTime(1,2))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_2,z_estime_gray, [min(rho_2(:)) max(rho_2(:))]);
%saveas(f, './output/Stereo_demo_2.jpg');
%
%%% Image grise sans HDR 3
%rho_3 = reshape(rho_3, [row col]);
%% Intégration du champ de normales :
%N_3(3,exterieur) = 1;			% Pour éviter les divisions par 0
%p_estime = reshape(-N_3(1,:)./N_3(3,:),size(masque));
%p_estime(exterieur) = 0;
%q_estime = reshape(-N_3(2,:)./N_3(3,:),size(masque));
%q_estime(exterieur) = 0;
%z_estime_gray = integration_SCS(q_estime,p_estime);
%
%% Ambiguïté concave/convexe :
%if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
%	z_estime_gray = z_estime_gray;
%end
%z_estime_gray(exterieur) = NaN;
%
%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'off','Name',strcat('Stéréophotométrie sur images démosaïquées Dt = ', num2str(ExposureTime(1,3))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_3,z_estime_gray, [min(rho_3(:)) max(rho_3(:))]);
%saveas(f, './output/Stereo_demo_3.jpg')
%
%%% Image grise sans HDR 4
%rho_4 = reshape(rho_4, [row col]);
%% Intégration du champ de normales :
%N_4(3,exterieur) = 1;			% Pour éviter les divisions par 0
%p_estime = reshape(-N_4(1,:)./N_4(3,:),size(masque));
%p_estime(exterieur) = 0;
%q_estime = reshape(-N_4(2,:)./N_4(3,:),size(masque));
%q_estime(exterieur) = 0;
%z_estime_gray = integration_SCS(q_estime,p_estime);
%
%% Ambiguïté concave/convexe :
%if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
%	z_estime_gray = z_estime_gray;
%end
%z_estime_gray(exterieur) = NaN;
%
%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'off','Name',strcat('Stéréophotométrie sur images démosaïquées Dt = ', num2str(ExposureTime(1,4))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_4,z_estime_gray, [min(rho_4(:)) max(rho_4(:))]);
%saveas(f, './output/Stereo_demo_4.jpg');

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
f = figure('Visible', 'on','Name','Stéréophotométrie HDR sur images démosaïquées','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(rho_gray, z_estime_gray, [min(rho_gray(:)) max(rho_gray(:))]);
saveas(f, './output/Stereo_hdr.jpg')

%%% Image TRUE HDR
%rho_HDR = reshape(rho_HDR, [row col]);
%% Intégration du champ de normales :
%N_HDR(3,exterieur) = 1;			% Pour éviter les divisions par 0
%p_estime = reshape(-N_HDR(1,:)./N_HDR(3,:),size(masque));
%p_estime(exterieur) = 0;
%q_estime = reshape(-N_HDR(2,:)./N_HDR(3,:),size(masque));
%q_estime(exterieur) = 0;
%z_estime_gray = integration_SCS(q_estime,p_estime);
%
%% Ambiguïté concave/convexe :
%if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
%	z_estime_gray = z_estime_gray;
%end
%z_estime_gray(exterieur) = NaN;
%
%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'off','Name','Stéréophotométrie avec VRAIE HDR sur images démosaïquées','Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_HDR, z_estime_gray, [min(rho_HDR(:)) max(rho_HDR(:))]);
%saveas(f, './output/Stereo_true_hdr.jpg')

%%% Image mosaic sans HDR
%rho_m = reshape(rho_m, [row col]);
%% Intégration du champ de normales :
%N_m(3,exterieur) = 1;			% Pour éviter les divisions par 0
%p_estime = reshape(-N_m(1,:)./N_m(3,:),size(masque));
%p_estime(exterieur) = 0;
%q_estime = reshape(-N_m(2,:)./N_m(3,:),size(masque));
%q_estime(exterieur) = 0;
%z_estime_gray = integration_SCS(q_estime,p_estime);
%
%% Ambiguïté concave/convexe :
%if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
%	z_estime_gray = z_estime_gray;
%end
%z_estime_gray(exterieur) = NaN;
%
%% Affichage de l'albédo et du relief :
%figure('Visible', 'off','Name','Stéréophotométrie sur images non-démosaïquées','Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(uint16(rho_m),z_estime_gray);

%%% Image mosaiquée
%rho_mosaic = reshape(rho_mosaic, [row col]);
%% Intégration du champ de normales :
%N_mosaic(3,exterieur) = 1;			% Pour éviter les divisions par 0
%p_estime = reshape(-N_mosaic(1,:)./N_mosaic(3,:),size(masque));
%p_estime(exterieur) = 0;
%q_estime = reshape(-N_mosaic(2,:)./N_mosaic(3,:),size(masque));
%q_estime(exterieur) = 0;
%z_estime_gray = integration_SCS(q_estime,p_estime);
%
%% Ambiguïté concave/convexe :
%if (z_estime_gray(floor(row/2),floor(col/2))<z_estime_gray(1,1))
%	z_estime_gray = z_estime_gray;
%end
%z_estime_gray(exterieur) = NaN;
%
%% Affichage de l'albédo et du relief :
%figure('Visible', 'off','Name','Stéréophotométrie HDR sur images non-démosaïquées','Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_mosaic, z_estime_gray, [min(rho_demo(:)) max(rho_demo(:))]);



ecarts
