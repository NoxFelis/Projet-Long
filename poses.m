clear all;
close all;

% source locations
source_file = "../SERNIN/sernin_camera.xml";
source_pics = "../SERNIN/JPEG_BRUT/";

% read through the xml file and create a struct from it
S = readstruct(source_file);
dame_mask = imread("Dame_mask.png");

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

% we try to create the calibration matrix
f = S.chunk.sensors.sensor.calibration.f;
k1 = S.chunk.sensors.sensor.calibration.k1;
k2 = S.chunk.sensors.sensor.calibration.k2;
k3 = S.chunk.sensors.sensor.calibration.k3;
u = S.chunk.sensors.sensor.calibration.cx;
v = S.chunk.sensors.sensor.calibration.cy;
K = [-f*k1 0 u; 0 -f*k2 v; 0 0 1];


%% TEST PHASE pas fini!!!!
% we remind that a point Q is so :
% q1 = R1*Q + T1
% and so to obtain q2 from q1
% Q = (q1 - T1)\R1
% q2 = R2*Q + T2

im1 = rot90(imread(source_pics + name_pics(1) + ".JPG"));
im2 = rot90(imread(source_pics + name_pics(2) + ".JPG"));
trans1 = squeeze(trans(1,:,:));
R1 = trans1(1:3,1:3)';
T1 = trans1(1:3,4);
trans2 = squeeze(trans(2,:,:));
R2 = trans2(1:3,1:3)';
T2 = trans2(1:3,4);


figure;
imshow(im1);

zone = getrect; % in format x y so j i
zone = round(zone);

% show the box
hold on
rectangle('Position', zone, 'EdgeColor','b', 'LineWidth',2);

%in order: top left, top right, bottom right, bottom left'
p1 = [zone(1) zone(2) 1; zone(1)+zone(3) zone(2) 1; zone(1)+zone(3) zone(2)+zone(4) 1; zone(1) zone(2)+zone(4) 1]';
w1 = K\p1;
Q1 = w1;
Q_world = R1\(Q1 - T1);

Q2 = R2*Q_world + T2;
w2 = Q2./Q2(3,:);
p2 = round(K*w2);
p2 = p2(1:2,:)';


figure;
imshow(im2);
hold on;
drawpolygon('Position',p2);


