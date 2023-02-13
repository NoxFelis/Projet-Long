function [theta,phi] = conversion(s)
% déduit les couples d'angles à partir de chaque vecteur s
% s = (3xp) vecteurs direction par image
p = size(s,2);
theta = zeros(p,1);
phi = zeros(p,1);
for i=1:p
    [azimuth,elevation,~] = cart2sph(s(1,i),s(2,i),s(3,i));
    theta(i) = pi/2 - elevation;
    phi(i) = azimuth;
%     phi(i) = atan2(s(2,i),s(1,i));
%     theta(i) = acos(s(3,i)/norm(s(:,i)));
end

end