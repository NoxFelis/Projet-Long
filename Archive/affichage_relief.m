function affichage_relief(z_estime)

% Affichage du relief estimé :
h = surfl(fliplr(z_estime));
zdir = [1 0 0];
rotate(h,zdir,90);
zdir = [0 1 0];
rotate(h,zdir,180);
zdir = [1 0 0];
rotate(h,zdir,-90);
shading flat;
colormap gray;
axis equal;
axis off;

view(0,90);				% Direction d'éclairage
hc = camlight('headlight','infinite');
view(-44,0);				% Direction d'observation
rotate3d;
