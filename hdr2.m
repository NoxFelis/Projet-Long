function image_out = hdr2(images, temps, encod)

    [nb, row, col] = size(images);
    images_plat = reshape(images, [nb row*col]);
    %ecart = abs(images-2^15*ones(nb, row, col));
    ecart = abs(images_plat-2^(encod-1)*ones(nb, row*col));

    [~, ind] = min(ecart, [], 1);
    %[image_out, ind] = min(ecart, [], 1);
    ind = squeeze(ind);
    %image_out = squeeze(image_out);

    image_out = zeros(row*col, 1);
    for i = 1:row*col
	image_out(i) = images_plat(ind(i), i)/temps(1, ind(i));
	%[~, ind] = min(ecart(:, i));
	%image_out(i) = images(ind, i)/temps(1, ind);
    end

    image_out = reshape(image_out, [row col]);
end
