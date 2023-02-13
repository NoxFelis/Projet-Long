function s = etalonnage(spheres,exterieur_masque,centre,rayon)
% renvoie les vecteurs correspondant aux différents éclairage, de norme 1
% sphere : (mxnxqxp) : mxn dimension de l'image de sphère, q le nombre
% d'images et p le nombres de sphère par image
% exterieur_masques : (mxn) masque de l'exterieur de la sphère
% centre : (1x2) coordonées du centre de la sphère
% rayon : (1x1) rayon de la sphère (en pixel)
% s : (3xp) vecteurs direction lumière pour chaque image
taille_noyau = round(rayon/20);
triangle = @(n)(1+n-abs(-n:n))/n;
[~,~,p,nb_sphere] = size(spheres);
s = zeros(3,p);
observation = [0;0;1];

% pour chaque image
for i=1:p
    direction = [];
    % pour chaque sphère
    for k=1:nb_sphere
        image_sphere = spheres(:,:,i,k);    % on récupère une image de sphère
        image_sphere(exterieur_masque) = 0; % on lui applique le masque
        % on lui applique un filtre afin de mettre en évidence le point
        % brillant
        image_filtree = conv2(triangle(taille_noyau),triangle(taille_noyau),image_sphere,'same');
        brillant = max(max(image_filtree));
        [y,x] = find(image_filtree==brillant);
        coord = [y,x] - centre;
        z = sqrt(rayon^2 - coord(1)^2 - coord(2)^2);
        valeur = real(2*[coord(2);coord(1);z])-observation;
        direction = [direction valeur/norm(valeur)];
        
    end
    s(:,i) = mean(direction,2);
    
end

end