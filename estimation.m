function [rho_estime,N_estime] = estimation(I,S,masque)
% calcul de m en tout point de l'image pour ensuite déduire les estimations
% de l'albédo rho et la normale N (rappel : m = rho*N) 
% on a rho = norm(m) car norm(n) = 1

% I : (nb_images,n) : image vectorisée
% S : (nb_images,3) : éclairages
% masque : (p,q) : masque sur l'image (car le modèle ici ne prend pas toute
% l'image

% rho_estime : (p,q) : albédo de l'objet
% N_estime : (3,n) : normale en chaque point de l'image
[~,nbpixels] = size(I);
[a,b] = size(masque);
m = (S'*S)\S'*I;
%masque = masque(:);
masque = find(masque);

rho_estime = ones(1,nbpixels);
rho_estime(:,masque) = sqrt(sum(m(:,masque).^2));
N_estime = zeros(3,nbpixels);
N_estime(:,masque) = m(:,masque)./rho_estime(:,masque);
rho_estime = reshape(rho_estime,[a,b]);
end