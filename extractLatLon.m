% Function that form the latitude or longitude in a string mode converts it to an angle in radians
% Input: Latitudes in the form: ddmmss.sP where P is N or S
%        Longitude in the form: dddmmss.sP wher P is W or E
% Output: Angle in radians, if E or S then angle in negative value.
% 
%
%

function ang = extractLatLon(angStr)

nelems=size(angStr,2);
ofset=0;
if(nelems==9)
  degrees=str2num(angStr(1:2));
else
  degrees=str2num(angStr(1:3));
  ofset=1;
end

min=str2num(angStr(3+ofset:4+ofset));
seg=str2num(angStr(5+ofset:8+ofset));

cardPoint=angStr(9+ofset);

ang=degrees+(min/60)+(seg/3600);

if(cardPoint=='W' || cardPoint=='S')
  ang=-ang;
end

%ang=ang*pi/180;

end
