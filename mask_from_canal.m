function mask = mask_from_canal(img,infos, canal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[h,w] = size(img);
sensor_layout = infos.CFALayout;
mask = false(h,w);


if (sensor_layout == "BGGR")
    if (canal == "R")
        for i = 1:h
            for j = 1:w
                if (mod(i,2)==0 && mod(j,2)==0)
                    mask(i,j) = 1;
                end
            end
        end
    elseif (canal == "G")
        for i = 1:h
            for j = 1:w
                if ((mod(i,2)==1 && mod(j,2)==0) || (mod(i,2)==0 && mod(j,2)==1))
                    mask(i,j) = 1;
                end
            end
        end
    elseif (canal == "B")
        for i = 1:h
            for j = 1:w
                if (mod(i,2)==1 && mod(j,2)==1)
                    mask(i,j) = 1;
                end
            end
        end
    end
elseif (sensor_layout == "RGGB")
    if (canal == "R")
        for i = 1:h
            for j = 1:w
                if (mod(i,2)==1 && mod(j,2)==1)
                    mask(i,j) = 1;
                end
            end
        end
    elseif (canal == "G")
        for i = 1:h
            for j = 1:w
                if ((mod(i,2)==1 && mod(j,2)==0) || (mod(i,2)==0 && mod(j,2)==1))
                    mask(i,j) = 1;
                end
            end
        end
    elseif (canal == "B")
        for i = 1:h
            for j = 1:w
                if (mod(i,2)==0 && mod(j,2)==0)
                    mask(i,j) = 1;
                end
            end
        end
    end
elseif (sensor_layout == "GBRG")
    if (canal == "R")
        for i = 1:h
            for j = 1:w
                if (mod(i,2)==0 && mod(j,2)==1)
                    mask(i,j) = 1;
                end
            end
        end
    elseif (canal == "G")
        for i = 1:h
            for j = 1:w
                if ((mod(i,2)==1 && mod(j,2)==1) || (mod(i,2)==0 && mod(j,2)==0))
                    mask(i,j) = 1;
                end
            end
        end
    elseif (canal == "B")
        for i = 1:h
            for j = 1:w
                if (mod(i,2)==1 && mod(j,2)==0)
                    mask(i,j) = 1;
                end
            end
        end
    end
elseif (sensor_layout == "GRBG")
    if (canal == "R")
        for i = 1:h
            for j = 1:w
                if (mod(i,2)==1 && mod(j,2)==0)
                    mask(i,j) = 1;
                end
            end
        end
    elseif (canal == "G")
        for i = 1:h
            for j = 1:w
                if ((mod(i,2)==1 && mod(j,2)==1) || (mod(i,2)==0 && mod(j,2)==0))
                    mask(i,j) = 1;
                end
            end
        end
    elseif (canal == "B")
        for i = 1:h
            for j = 1:w
                if (mod(i,2)==0 && mod(j,2)==1)
                    mask(i,j) = 1;
                end
            end
        end
    end
end
