function z_estime = integration(N, masque);

    exterieur = find(masque==0);
    [row, col] = size(masque);

    % Intégration du champ de normales :
    N(3,exterieur) = 1;			% Pour éviter les divisions par 0
    p_estime = reshape(-N(1,:)./N(3,:),size(masque));
    p_estime(exterieur) = 0;
    q_estime = reshape(-N(2,:)./N(3,:),size(masque));
    q_estime(exterieur) = 0;
    z_estime = integration_SCS(q_estime,p_estime);

    % Ambiguïté concave/convexe :
    if (z_estime(floor(row/2),floor(col/2))<z_estime(1,1))
	z_estime = z_estime;
    end
    z_estime(exterieur) = NaN;

end
