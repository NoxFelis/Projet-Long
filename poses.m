clear all;
close all;

% source locations
source_file = "../SERNIN/sernin_camera.xml";
source_pics = "../SERNIN/JPEG_BRUT/";

% read through the xml file and create a struct from it
S = readstruct(source_file);

% extraction of the picture names (but we don't need 'DSC_0013' we'll need
% to add .JPG
name_pics = [S.chunk.cameras.camera.labelAttribute];
name_pics = name_pics(2:end);

% extraction of the transformation matrices to a usable format
transform_pics = [S.chunk.cameras.camera.transform];
transform_pics = transform_pics(2:end);
% right now it's a vector with each string all values
mat = split(transform_pics," ");
mat = str2double(mat);
mat = reshape(mat,size(name_pics,2),4,4);
trans = permute(mat, [1 3 2]);
% what we should obtain here is a matrix K = [R | T] with G a rotation
% transformation and T a translation


%% TEST PHASE pas fini!!!!
% we remind that a point Q is so :
% q1 = R1*Q + T1
% and so to obtain q2 from q1
% Q = (q1 - T1)\R1
% q2 = R2*Q + T2

im1 = rot90(imread(source_pics + name_pics(1) + ".JPG"));
im2 = rot90(imread(source_pics + name_pics(2) + ".JPG"));
trans1 = squeeze(trans(1,:,:));
R1 = trans1(:,1:3)';
T1 = trans1(:,4);
trans2 = squeeze(trans(2,:,:));
R2 = trans2(:,1:3)';
T2 = trans2(:,4);


figure;
imshow(im1);

zone = getrect;
zone = round(zone);

% show the box
hold on
rectangle('Position', zone, 'EdgeColor','b', 'LineWidth',2);

%in order: top left, top right, bottom right, bottom left'
box1 = [zone(1) zone(2) 1 1; zone(1)+zone(3) zone(2) 1 1; zone(1)+zone(3) zone(2)+zone(4) 1 1; zone(1) zone(2)+zone(4) 1 1]' ;
box_world = (box1 - T1)\R1;
box2 = R2*box_world + T2;

figure;
imshow(im2);

