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
Images_mosaic = Images_mosaic/max(Images_mosaic(:));
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


%% Image grise sans HDR 1
rho_1 = reshape(rho_1, [row col]);
z_estime_1 = integration(N_1, masque);

%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'on','Name',strcat('Stéréophotométrie sur images démosaïquées Dt = ', num2str(ExposureTime(1,1))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_1,z_estime_1, [min(rho_1(:)) max(rho_1(:))]);
%saveas(f, './output/Stereo_demo_1.jpg');
coupe_col_1 = squeeze(z_estime_1(:, col/2));
coupe_row_1 = squeeze(z_estime_1(row/2, :));

%% Image grise sans HDR 2
rho_2 = reshape(rho_2, [row col]);
z_estime_2 = integration(N_2, masque);

%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'on','Name',strcat('Stéréophotométrie sur images démosaïquées Dt = ', num2str(ExposureTime(1,2))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_2,z_estime_2, [min(rho_2(:)) max(rho_2(:))]);
%saveas(f, './output/Stereo_demo_2.jpg');
coupe_col_2 = squeeze(z_estime_2(:, col/2));
coupe_row_2 = squeeze(z_estime_2(row/2, :));

%% Image grise sans HDR 3
rho_3 = reshape(rho_3, [row col]);
z_estime_3 = integration(N_3, masque);

%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'on','Name',strcat('Stéréophotométrie sur images démosaïquées Dt = ', num2str(ExposureTime(1,3))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_3,z_estime_3, [min(rho_3(:)) max(rho_3(:))]);
%saveas(f, './output/Stereo_demo_3.jpg')
coupe_col_3 = squeeze(z_estime_3(:, col/2));
coupe_row_3 = squeeze(z_estime_3(row/2, :));

%% Image grise sans HDR 4
rho_4 = reshape(rho_4, [row col]);
z_estime_4 = integration(N_4, masque);

%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'on','Name',strcat('Stéréophotométrie sur images démosaïquées Dt = ', num2str(ExposureTime(1,4))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_4,z_estime_4, [min(rho_4(:)) max(rho_4(:))]);
%saveas(f, './output/Stereo_demo_4.jpg');
coupe_col_4 = squeeze(z_estime_4(:, col/2));
coupe_row_4 = squeeze(z_estime_4(row/2, :));

%% Image grise
rho_gray = reshape(rho_gray, [row col]);
z_estime_gray = integration(N_gray, masque);

% Affichage de l'albédo et du relief :
f = figure('Visible', 'on','Name','Stéréophotométrie HDR sur images démosaïquées','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(rho_gray, z_estime_gray, [min(rho_gray(:)) max(rho_gray(:))]);
saveas(f, './output/Stereo_hdr.jpg')
coupe_col_gray = squeeze(z_estime_gray(:, col/2));
coupe_row_gray = squeeze(z_estime_gray(row/2, :));

%% Image TRUE HDR
rho_HDR = reshape(rho_HDR, [row col]);
z_estime_HDR = integration(N_HDR, masque);

% Affichage de l'albédo et du relief :
f = figure('Visible', 'on','Name','Stéréophotométrie avec VRAIE HDR sur images démosaïquées','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(rho_HDR, z_estime_HDR, [min(rho_HDR(:)) max(rho_HDR(:))]);
saveas(f, './output/Stereo_true_hdr.jpg')
coupe_col_HDR = squeeze(z_estime_HDR(:, col/2));
coupe_row_HDR = squeeze(z_estime_HDR(row/2, :));


%% Image mosaiquée
rho_mosaic = reshape(rho_mosaic, [row col]);
z_estime_mosaic = integration(N_mosaic, masque);

% Affichage de l'albédo et du relief :
figure('Visible', 'on','Name','Stéréophotométrie HDR sur images non-démosaïquées','Position',[0.6*L,0,0.2*L,0.7*H]);
affichage_albedo_relief_tp(rho_mosaic, z_estime_mosaic, [min(rho_mosaic(:)) max(rho_mosaic(:))]);
coupe_col_mosaic = squeeze(z_estime_mosaic(:, col/2));
coupe_row_mosaic = squeeze(z_estime_mosaic(row/2, :));

[rho_1m, N_1m] = estimation(squeeze(Images_mosaic(:, 1, :)), Eclairage', masque(:));
[rho_2m, N_2m] = estimation(squeeze(Images_mosaic(:, 2, :)), Eclairage', masque(:));
[rho_3m, N_3m] = estimation(squeeze(Images_mosaic(:, 3, :)), Eclairage', masque(:));
[rho_4m, N_4m] = estimation(squeeze(Images_mosaic(:, 4, :)), Eclairage', masque(:));

%% Image mosaic sans HDR 1
rho_1m = reshape(rho_1m, [row col]);
z_estime_1m = integration(N_1m, masque);

%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'on','Name',strcat('Stéréophotométrie sur images non-démosaïquées Dt = ', num2str(ExposureTime(1,1))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_1m,z_estime_1m, [min(rho_1m(:)) max(rho_1m(:))]);
%saveas(f, './output/Stereo_demo_1.jpg');
coupe_col_1m = squeeze(z_estime_1m(:, col/2));
coupe_row_1m = squeeze(z_estime_1m(row/2, :));

%% Image mosaic sans HDR 2
rho_2m = reshape(rho_2m, [row col]);
z_estime_2m = integration(N_2m, masque);

%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'on','Name',strcat('Stéréophotométrie sur images non-démosaïquées Dt = ', num2str(ExposureTime(1,2))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_2m,z_estime_2m, [min(rho_2m(:)) max(rho_2m(:))]);
%saveas(f, './output/Stereo_demo_1.jpg');
coupe_col_2m = squeeze(z_estime_2m(:, col/2));
coupe_row_2m = squeeze(z_estime_2m(row/2, :));

%% Image mosaic sans HDR 3
rho_3m = reshape(rho_3m, [row col]);
z_estime_3m = integration(N_3m, masque);

%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'on','Name',strcat('Stéréophotométrie sur images non-démosaïquées Dt = ', num2str(ExposureTime(1,3))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_3m,z_estime_3m, [min(rho_3m(:)) max(rho_3m(:))]);
%saveas(f, './output/Stereo_demo_1.jpg');
coupe_col_3m = squeeze(z_estime_3m(:, col/2));
coupe_row_3m = squeeze(z_estime_3m(row/2, :));

%% Image mosaic sans HDR 4
rho_4m = reshape(rho_4m, [row col]);
z_estime_4m = integration(N_4m, masque);

%% Affichage de l'albédo et du relief :
%f = figure('Visible', 'on','Name',strcat('Stéréophotométrie sur images non-démosaïquées Dt = ', num2str(ExposureTime(1,4))),'Position',[0.6*L,0,0.2*L,0.7*H]);
%affichage_albedo_relief_tp(rho_4m,z_estime_4m, [min(rho_4m(:)) max(rho_4m(:))]);
%saveas(f, './output/Stereo_demo_1.jpg');
coupe_col_4m = squeeze(z_estime_4m(:, col/2));
coupe_row_4m = squeeze(z_estime_4m(row/2, :));

%%% Affichage coupe grise
x = 1:row;
figure('Name', 'Coupe suivant une colonne de la reconstruction'),
plot(x, coupe_col_1, 'LineWidth', 2); hold on;
plot(x, coupe_col_2, 'LineWidth', 2); hold on;
plot(x, coupe_col_3, 'LineWidth', 2); hold on;
plot(x, coupe_col_4, 'LineWidth', 2); hold on;
plot(x, coupe_col_gray, 'LineWidth', 2); hold on;
plot(x, coupe_col_HDR, 'LineWidth', 2);
lgd = legend(strcat('Dt = ', num2str(ExposureTime(1,1))), strcat('Dt = ', num2str(ExposureTime(1,2))), strcat('Dt = ', num2str(ExposureTime(1,3))), strcat('Dt = ', num2str(ExposureTime(1,4))), 'HDR', 'TRUE HDR');
lgd.FontSize = 14;

figure('Name', 'Coupe suivant une colonne de la recosntruction avec min = 0'),
plot(x, coupe_col_1-min(coupe_col_1), 'LineWidth', 2); hold on;
plot(x, coupe_col_2-min(coupe_col_2), 'LineWidth', 2); hold on;
plot(x, coupe_col_3-min(coupe_col_3), 'LineWidth', 2); hold on;
plot(x, coupe_col_4-min(coupe_col_4), 'LineWidth', 2); hold on;
plot(x, coupe_col_gray-min(coupe_col_gray), 'LineWidth', 2); hold on;
plot(x, coupe_col_HDR-min(coupe_col_HDR), 'LineWidth', 2);
lgd = legend(strcat('Dt = ', num2str(ExposureTime(1,1))), strcat('Dt = ', num2str(ExposureTime(1,2))), strcat('Dt = ', num2str(ExposureTime(1,3))), strcat('Dt = ', num2str(ExposureTime(1,4))), 'HDR', 'TRUE HDR');
lgd.FontSize = 14;

x = 1:col;
figure('Name', 'Coupe suivant une ligne de la reconstruction'),
plot(x, coupe_row_1, 'LineWidth', 2); hold on;
plot(x, coupe_row_2, 'LineWidth', 2); hold on;
plot(x, coupe_row_3, 'LineWidth', 2); hold on;
plot(x, coupe_row_4, 'LineWidth', 2); hold on;
plot(x, coupe_row_gray, 'LineWidth', 2); hold on;
plot(x, coupe_row_HDR, 'LineWidth', 2);
lgd = legend(strcat('Dt = ', num2str(ExposureTime(1,1))), strcat('Dt = ', num2str(ExposureTime(1,2))), strcat('Dt = ', num2str(ExposureTime(1,3))), strcat('Dt = ', num2str(ExposureTime(1,4))), 'HDR', 'TRUE HDR');
lgd.FontSize = 14;

figure('Name', 'Coupe suivant une ligne de la recosntruction avec min = 0'),
plot(x, coupe_row_1-min(coupe_row_1), 'LineWidth', 2); hold on;
plot(x, coupe_row_2-min(coupe_row_2), 'LineWidth', 2); hold on;
plot(x, coupe_row_3-min(coupe_row_3), 'LineWidth', 2); hold on;
plot(x, coupe_row_4-min(coupe_row_4), 'LineWidth', 2); hold on;
plot(x, coupe_row_gray-min(coupe_row_gray), 'LineWidth', 2); hold on;
plot(x, coupe_row_HDR-min(coupe_row_HDR), 'LineWidth', 2);
lgd = legend(strcat('Dt = ', num2str(ExposureTime(1,1))), strcat('Dt = ', num2str(ExposureTime(1,2))), strcat('Dt = ', num2str(ExposureTime(1,3))), strcat('Dt = ', num2str(ExposureTime(1,4))), 'HDR', 'TRUE HDR');
lgd.FontSize = 14;

%%% Affichage coupe mosaic
x = 1:row;
figure('Name', 'Coupe suivant une colonne de la reconstruction pour la mosaic'),
plot(x, coupe_col_1, 'LineWidth', 2); hold on;
plot(x, coupe_col_2, 'LineWidth', 2); hold on;
plot(x, coupe_col_3, 'LineWidth', 2); hold on;
plot(x, coupe_col_4, 'LineWidth', 2); hold on;
plot(x, coupe_col_1m, 'LineWidth', 2); hold on;
plot(x, coupe_col_2m, 'LineWidth', 2); hold on;
plot(x, coupe_col_3m, 'LineWidth', 2); hold on;
plot(x, coupe_col_4m, 'LineWidth', 2); hold on;
lgd = legend(strcat('Dt = ', num2str(ExposureTime(1,1))), strcat('Dt = ', num2str(ExposureTime(1,2))), strcat('Dt = ', num2str(ExposureTime(1,3))), strcat('Dt = ', num2str(ExposureTime(1,4))), strcat('m Dt = ', num2str(ExposureTime(1,1))), strcat('m Dt = ', num2str(ExposureTime(1,2))), strcat('m Dt = ', num2str(ExposureTime(1,3))), strcat('m Dt = ', num2str(ExposureTime(1,4))));
lgd.FontSize = 14;

figure('Name', 'Coupe suivant une colonne de la recosntruction avec min = 0 pour la mosaic'),
plot(x, coupe_col_1-min(coupe_col_1), 'LineWidth', 2); hold on;
plot(x, coupe_col_2-min(coupe_col_2), 'LineWidth', 2); hold on;
plot(x, coupe_col_3-min(coupe_col_3), 'LineWidth', 2); hold on;
plot(x, coupe_col_4-min(coupe_col_4), 'LineWidth', 2); hold on;
plot(x, coupe_col_1m-min(coupe_col_1m), 'LineWidth', 2); hold on;
plot(x, coupe_col_2m-min(coupe_col_2m), 'LineWidth', 2); hold on;
plot(x, coupe_col_3m-min(coupe_col_3m), 'LineWidth', 2); hold on;
plot(x, coupe_col_4m-min(coupe_col_4m), 'LineWidth', 2); hold on;
lgd = legend(strcat('Dt = ', num2str(ExposureTime(1,1))), strcat('Dt = ', num2str(ExposureTime(1,2))), strcat('Dt = ', num2str(ExposureTime(1,3))), strcat('Dt = ', num2str(ExposureTime(1,4))), strcat('m Dt = ', num2str(ExposureTime(1,1))), strcat('m Dt = ', num2str(ExposureTime(1,2))), strcat('m Dt = ', num2str(ExposureTime(1,3))), strcat('m Dt = ', num2str(ExposureTime(1,4))));
lgd.FontSize = 14;

x = 1:col;
figure('Name', 'Coupe suivant une ligne de la reconstruction pour la mosaic'),
plot(x, coupe_row_1, 'LineWidth', 2); hold on;
plot(x, coupe_row_2, 'LineWidth', 2); hold on;
plot(x, coupe_row_3, 'LineWidth', 2); hold on;
plot(x, coupe_row_4, 'LineWidth', 2); hold on;
plot(x, coupe_row_1m, 'LineWidth', 2); hold on;
plot(x, coupe_row_2m, 'LineWidth', 2); hold on;
plot(x, coupe_row_3m, 'LineWidth', 2); hold on;
plot(x, coupe_row_4m, 'LineWidth', 2); hold on;
lgd = legend(strcat('Dt = ', num2str(ExposureTime(1,1))), strcat('Dt = ', num2str(ExposureTime(1,2))), strcat('Dt = ', num2str(ExposureTime(1,3))), strcat('Dt = ', num2str(ExposureTime(1,4))), strcat('m Dt = ', num2str(ExposureTime(1,1))), strcat('m Dt = ', num2str(ExposureTime(1,2))), strcat('m Dt = ', num2str(ExposureTime(1,3))), strcat('m Dt = ', num2str(ExposureTime(1,4))));
lgd.FontSize = 14;

figure('Name', 'Coupe suivant une ligne de la recosntruction avec min = 0'),
plot(x, coupe_row_1-min(coupe_row_1), 'LineWidth', 2); hold on;
plot(x, coupe_row_2-min(coupe_row_2), 'LineWidth', 2); hold on;
plot(x, coupe_row_3-min(coupe_row_3), 'LineWidth', 2); hold on;
plot(x, coupe_row_4-min(coupe_row_4), 'LineWidth', 2); hold on;
plot(x, coupe_row_1m-min(coupe_row_1m), 'LineWidth', 2); hold on;
plot(x, coupe_row_2m-min(coupe_row_2m), 'LineWidth', 2); hold on;
plot(x, coupe_row_3m-min(coupe_row_3m), 'LineWidth', 2); hold on;
plot(x, coupe_row_4m-min(coupe_row_4m), 'LineWidth', 2); hold on;
lgd = legend(strcat('Dt = ', num2str(ExposureTime(1,1))), strcat('Dt = ', num2str(ExposureTime(1,2))), strcat('Dt = ', num2str(ExposureTime(1,3))), strcat('Dt = ', num2str(ExposureTime(1,4))), strcat('m Dt = ', num2str(ExposureTime(1,1))), strcat('m Dt = ', num2str(ExposureTime(1,2))), strcat('m Dt = ', num2str(ExposureTime(1,3))), strcat('m Dt = ', num2str(ExposureTime(1,4))));
lgd.FontSize = 14;

ecarts
