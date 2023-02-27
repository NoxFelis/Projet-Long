clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Sous-images correspondant au rectangle englobant de la sphère :
masque = imread('Donnees/masque.bmp');
masque = masque(:,:,1);
[i_interieur,j_interieur] = ind2sub(size(masque),find(masque>0));
i_min = min(i_interieur);
i_max = max(i_interieur);
j_min = min(j_interieur);
j_max = max(j_interieur);
masque = masque(i_min:i_max,j_min:j_max);
masque = masque>0;
interieur = find(masque>0);
exterieur = find(masque==0);
[nb_lignes,nb_colonnes] = size(masque);
nb_pixels = nb_lignes*nb_colonnes;

% Lecture de l'image prise sans éclairage :
I0 = imread('Donnees/I0.png');

% Stockage des images dans une matrice de taille nb_images x nb_pixels :
I = [];
k = 1;
nom_fichier = ['Donnees/I' num2str(k) '.png'];
while exist(nom_fichier)
	Ik = imread(nom_fichier);
	Ik = Ik-I0;
	Ik = double(rgb2gray(Ik(i_min:i_max,j_min:j_max,:)));
	I = [I ; transpose(Ik(:))];
	k = k+1;
	nom_fichier = ['Donnees/I' num2str(k) '.png'];
end	
nb_images = size(I,1);

% Affichage des images :
figure('Name','Images','Position',[0,0,0.5*L,0.5*H]);
for k = 1:nb_images
	subplot(2,4,k);
	Ik = reshape(I(k,:),nb_lignes,nb_colonnes);
	imagesc(Ik);
	axis equal;
	axis off;
	colormap gray;
end
drawnow;

% Calcul des normales dans une matrice de taille 3 x nb_pixels :
x_0 = nb_colonnes/2;
y_0 = nb_lignes/2;
R = min(nb_lignes,nb_colonnes)/2;
N = zeros(3,nb_pixels);
for i = 1:nb_lignes
	y = i-y_0;
	for j = 1:nb_colonnes
		x = j-x_0;
		r = sqrt(x^2+y^2);
		if r <= R
			masque(i,j) = 1;
			z = sqrt(R^2-r^2);
			n = [x ; y ; z]/R;
		else
			masque(i,j) = 0;
			n = [0 ; 0 ; 1];
		end
		N(:,sub2ind(size(masque),i,j)) = n;
	end
end

% Estimation des éclairages dans une matrice de taille nb_images x 3 :
S = zeros(nb_images,3);
pixels_OK = zeros(nb_images,nb_pixels);
for k = 1:nb_images
	Ik = transpose(I(k,:));
	Ik_max = max(Ik);
	p_OK = (masque(:) & Ik>0.2*Ik_max & Ik<0.85*Ik_max); 	% Elimination des ombres et des taches brillantes
	Ik_OK = Ik(p_OK);
	pixels_OK(k,:) = p_OK;
	N_OK = N(:,p_OK);
	sk = transpose(N_OK)\Ik_OK;
	S(k,:) = sk;
end
S

% Affichage des pixels OK :
figure('Name','Pixels OK','Position',[0.5*L,0,0.5*L,0.5*H]);
for k = 1:nb_images
	subplot(2,4,k);
	p_OK = reshape(pixels_OK(k,:),nb_lignes,nb_colonnes);
	imagesc(p_OK);
	axis equal;
	axis off;
	colormap gray;
end
drawnow;

% Estimation des normales dans une matrice de taille 3 x nb_pixels :
[~,N_estime] = estimation(I,S,masque);

% Estimation du gradient de profondeur :
N_estime(3,exterieur) = 1;			% Pour éviter les divisions par 0
p_estime = reshape(-N_estime(1,:)./N_estime(3,:),size(masque));
q_estime = reshape(-N_estime(2,:)./N_estime(3,:),size(masque));

% Intégration du gradient de profondeur estimé :
z_estime = integration_SCS(q_estime,p_estime);
z_estime(exterieur) = NaN;

% Affichage du relief estimé :
figure('Name','Reconstruction 3D','Position',[0.5*L,0,0.5*L,0.5*H]);
affichage_relief(z_estime);

% Ecriture des fichiers :
Phi = sqrt(sum(S.^2,2));
S_normalise = S./repmat(Phi,1,3);
save etalonnage_JD.mat S Phi S_normalise;
