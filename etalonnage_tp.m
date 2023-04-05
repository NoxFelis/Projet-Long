function s = etalonnage_tp(spheres, masque_ext, centre, rayon)

    [row, col, m, k] = size(spheres);

    taille_noyau = round(rayon/20);
    triangle = @(n)(1+n-abs(-n:n))/n;
    image_filtree = zeros(size(spheres));
    for i = 1:m
	for j = 1:k
	    image_filtree(:, :, i, j) = conv2(triangle(taille_noyau), triangle(taille_noyau), spheres(:, :, i, j), 'same');
	end
    end
    
    s = zeros(3, m);
    n0 = [0; 0; 1];
    for i = 1:m
	for j = 1:k
	    [~, ind] = max(image_filtree(:, :, i, k), [], 'all');
	    [rowm, colm] = ind2sub([row, col], [ind]);
	    xn = centre(:, 1) - colm;
	    yn = rowm - centre(:, 2);
	    zn = sqrt(rayon^2 - xn^2 - yn^2); 
	    n = [xn; yn; zn];
	    n = n/rayon;
	    sk = 2*(n0'*n)*n - n0;
	    sk = sk/norm(sk);
	    s(:, i) = s(:, i) + sk/k;
	end
	s(:, i) = s(:, i)/norm(s(:,i));
    end
