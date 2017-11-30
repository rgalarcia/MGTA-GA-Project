% Computes the mercator Projection
%
% Input -->
%   latlon(1) -> latitude in �
%   latlon(2) -> longitude in �
%   lon0 -> longitude in � where x=0 you can consider 2� (roughly in
%   the middle of the map we consider)
%
% Output -->
%  [x,y] -> the mercator projection of the point at (lat,lon) in km with lon0 as longitude where x=0 
%

function [x,y] = mercatorProjection(latlon,lon0)
    R = 6378.1; % [km]
    x = (latlon(2)-lon0)*pi/180*R;
    y = log(tan(pi/4 + 1/2*latlon(1)*pi/180))*R;
end
