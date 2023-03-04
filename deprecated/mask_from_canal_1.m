function mask = mask_from_canal(path_img, canal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[h,w] = size(rawread(path_img));
infos = rawinfo(path_img);
sensor_layout = infos.CFALayout;
mask = false(h,w);

% Chaque condition du if correspond à un des 4 possibles photosites du schéma 2x2 de Bayer, en commençant par le coin haut-gauche:
if ((canal == "B" && sensor_layout =="BGGR") || (canal == "G" && (sensor_layout == "GBRG" || sensor_layout == "GRBG")) || (canal == "R" && sensor_layout =="RGGB"))
    for i = 1:h
        for j = 1:w
            if (mod(i,2)==0 && mod(j,2)==0)
                mask(i,j) = 1;
            end
        end
    end

% Coin haut-droit
elseif ((canal == "G" && (sensor_layout =="BGGR" || sensor_layout =="RGGB")) || (canal == "B" && sensor_layout == "GBRG") || (canal == "R" && sensor_layout =="GRBG"))
    for i = 1:h
        for j = 1:w
            if (mod(i,2)==1 && mod(j,2)==0)
                mask(i,j) = 1;
            end
        end
    end

% Coin bas-gauche
elseif ((canal == "G" && (sensor_layout =="BGGR" || sensor_layout =="RGGB")) || (canal == "R" && sensor_layout == "GBRG") || (canal == "B" && sensor_layout =="GRBG"))
    for i = 1:h
        for j = 1:w
            if (mod(i,2)==0 && mod(j,2)==1)
                mask(i,j) = 1;
            end
        end
    end

% Coin bas-droit
elseif ((canal == "R" && sensor_layout =="BGGR") || (canal == "G" && (sensor_layout == "GBRG" || sensor_layout == "GRBG")) || (canal == "B" && sensor_layout =="RGGB"))
    for i = 1:h
        for j = 1:w
            if (mod(i,2)==1 && mod(j,2)==1)
                mask(i,j) = 1;
            end
        end
    end
end
