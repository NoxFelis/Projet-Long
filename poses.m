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
mat = permute(mat, [1 3 2]);
% what we should obtain here is a matrix K = [R | T] with G a rotation
% transformation and T a translation
