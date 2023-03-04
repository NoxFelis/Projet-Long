function mask = mask_from_canal(img, canal)
% creation d'un masque selon la couleur
% la forme suit [bleu vert; vert rouge]

[h,w,~] = size(img);
mask = false(h,w);

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
            if (mod(i,2)==1 && mod(j,2)==0) || (mod(i,2)==0 && mod(j,2)==1)
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
