function bruh = affichage_image(Image, ind)

    [nb_ecl, nb_exp, row, col] = size(Image);
    for i = 1:nb_exp
	imagesc(squeeze(Image(ind, i, :, :)));
	colorbar;
	pause();
    end
    bruh = 0;

end
