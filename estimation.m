function [rho_estime,N_estime] = estimation(I,S,masque)

if rank(S)<3
	disp('Attention : rang(S)<3 !');
	exit;
end

% Estimation simultanée de l'ensemble des vecteurs m :
M_estime = S\I;
rho_estime = sqrt(sum(M_estime.^2));
exterieur = find(masque==0);			% Extérieur du domaine de reconstruction
rho_estime(exterieur) = 1;			% Pour éviter les divisions par 0
N_estime = M_estime./(ones(3,1)*rho_estime);
rho_estime = reshape(rho_estime,size(masque));
rho_estime(exterieur) = 0;
