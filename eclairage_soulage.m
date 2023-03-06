clear all;
close all;

path = '../SOULAGES/';
list_dir = dir(path);
nb_raw = 0;
nb_im = 0;
for i = 1:size(list_dir, 1)
    if list_dir(i).name(end) == 'F'
	nb_raw = nb_raw + 1;
    end
    if list_dir(i).name(end) == 'G'
	nb_im = nb_im + 1;
    end
end

%masque = imread('./masque_soulage_blanche.png');
masque = imread('./mask_soulage_2.png');
masque = ~masque;
diametre = size(masque,1);


Image_eclairage = zeros(diametre, diametre, nb_im/7);
Images_mosaic = zeros(nb_raw/7, 7, 500, 500);
Images_gray = zeros(nb_raw/7, 7, 500, 500);
ExposureTime = zeros(nb_raw/7, 7);
raw_count = 1;
im_count = 1;
groupe_count = 1;

for i = 1:size(list_dir, 1)
    name = strcat(path, list_dir(i).name);
    if list_dir(i).name(end) == 'F'
	raw = rawread(name);
	info = rawinfo(name);
	place = mod(raw_count, 7)+1;
	Images_mosaic(groupe_count, place, :, :) = raw(2500:2999, 5000:5499);
	image_grise = rgb2gray(demosaic(raw, info.CFALayout));
	Images_gray(groupe_count, place, :, :) = image_grise(2500:2999, 5000:5499);
	ExposureTime(groupe_count, place) = info.ExifTags.ExposureTime;
        raw_count = raw_count + 1
	if mod(raw_count, 7) == 1
	    groupe_count = groupe_count + 1
	end
    end
    if list_dir(i).name(end) == 'G'
	if mod(im_count, 7) == 1
	    image = imread(name);
	    num = 5555 + im_count - 1;
	    if num < 5611
		list_x = 2943:2943+diametre-1;
		list_y = 317:317+diametre-1;
	    elseif num >= 5611 && num < 5625
		list_x = 2956:2956+diametre-1;
		list_y = 134:134+diametre-1;
	    else
		list_x = 2965:2965+diametre-1;
		list_y = 352:352+diametre-1;
	    end
	    %imshow(image(list_x, list_y));hold on;
	    %Eclairage = etalonnage(image(list_x, list_y), masque, [diametre/2 diametre/2], diametre/2);
	    %pause(1);
	    Image_eclairage(:, :, groupe_count) = image(list_x, list_y);
	end
        im_count = im_count + 1;
    end
end

Eclairage = etalonnage(Image_eclairage, masque, [diametre/2 diametre/2], diametre/2);
%zero = zeros(1, size(Eclairage, 2));
%figure,
%quiver3(zero, zero, zero, Eclairage(1, :), Eclairage(2, :), Eclairage(3, :));


save SOULAGES Images_mosaic Images_gray ExposureTime Eclairage ;
