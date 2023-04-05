clear all;
close all;

path = '../image_test/';
path_suite = '/images/Face_A/rti/';
list_dir = dir(path);
nb_ecl = 35;
nb_expo = 4;
taille = 1000;

%Images_mosaic = zeros(nb_ecl, nb_expo, taille, taille);
Images_mosaic = 0;
Images_gray = zeros(nb_ecl, nb_expo, taille, taille);
ExposureTime = zeros(nb_ecl, nb_expo);
Eclairage = zeros(3, nb_ecl);
num_dir = 1;

for j = 1:size(list_dir, 1)
    if list_dir(j).name(1) == 'H'
	num_image = 1;
	directory = strcat(path, list_dir(j).name);
	list_image = dir(strcat(directory, path_suite));
	for i = 1:size(list_image, 1)
	    name = strcat(strcat(directory, path_suite), list_image(i).name);
	    if list_image(i).name(end) == 'F'
		%raw = rawread(name);
		info = rawinfo(name);
		%Images_mosaic(num_image, num_dir, :, :) = raw(3001:3500, 3001:3500);
		%image_grise = rgb2gray(demosaic(raw, info.CFALayout));
		%Images_gray(num_image, num_dir, :, :) = image_grise(3001:3500, 3001:3500);
		ExposureTime(num_image, num_dir) = info.ExifTags.ExposureTime;
	    elseif list_image(i).name(end) == 'G'
		image = imread(name);
		image_grise = rgb2gray(image);
		Images_gray(num_image, num_dir, :, :) = image_grise(3001:3001+taille-1, 3001:3001+taille-1, :);
		num_image = num_image + 1;
	    end
	end
	num_dir = num_dir + 1;
    elseif list_dir(j).name(1) == 'R'
	name = strcat(path, list_dir(j).name);
	fid = fopen(name);
	raw = fread(fid, inf); % Reading the contents
	str = char(raw'); % Transformation
	fclose(fid); % Closing the file
	data = jsondecode(str); % Using the jsondecode function to parse JSON from string
	fields = cell2mat(fieldnames(data.lights));
	for i = 1:size(fields, 1)
	    nb = str2num(fields(i, 2:end));
	    sub = getfield(data.lights, fields(i, :));
	    Intensite = str2double(sub.intensity(1));
	    for k = 1:3
		Eclairage(k, nb) = Intensite * str2double(cell2mat(sub.direction(k)));
	    end
	end
    end
end



save CHEVAUX_JPG Images_mosaic Images_gray ExposureTime Eclairage -v7.3;
