function [image_out, temps_out] = hdr(images, temps, encod)

    [nb, row, col] = size(images);
    %ecart = abs(images-2^15*ones(nb, row, col));
    ecart = abs(images-2^(encod-1)*ones(nb, row, col));

    [~, ind] = min(ecart, [], 1);
    %[image_out, ind] = min(ecart, [], 1);
    ind = squeeze(ind);
    %image_out = squeeze(image_out);

    temps_out = zeros(row, col);
    image_out = zeros(row, col);
    for i = 1:row
	for j = 1:col
	    temps_out(i, j) = temps(1, ind(i, j));
	    image_out(i, j) = images(1, ind(i, j));
	    %[~, ind] = min(ecart(:, i, j));
	    %temps_out(i, j) = temps(1, ind);
	    %image_out(i, j) = images(1, ind);
	end
    end
end
