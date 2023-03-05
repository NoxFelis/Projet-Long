function [image_out, temps_out] = hdr(images, temps)

    [nb, row, col] = size(images);
    ecart = abs(images-2^15*ones(nb, row, col));

    [image_out, ind] = min(ecart, [], 1);
    ind = squeeze(ind);
    image_out = squeeze(image_out);

    temps_out = zeros(row, col);
    for i = 1:row
	for j = 1:col
	    temps_out(i, j) = temps(1, ind(i, j));
	end
    end
end
