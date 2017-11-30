function Airspace= CreateAirspace(fNavWpts,fAirways,fFir,fAC)

% Returns a structure : Airspace = struct('InterFIR',intercoordfir,'OccureFIR',realoccurencefir,'InterArw',intercoord,...
%    'OccureArw',realoccurence,'Airways',arw, 'AxisBounds',axisbounds,'ExtremeVor',extremeVor);
% where: 
%   intercoordfir: intersection points between airways and FIR, in [km]
%   realoccurencefir: number of intersection points between airways and FIR
%   intercoord: intersection points between airways, in [km]
%   realoccurence: number of intersection points between airways
%   arw: structure of segments forming the airways
%   axisbounds: [minx, maxx, miny, maxy] in [km] of the domain
%   extremeVor: 4 fiction points (depending on axisbounds) for the
%               construction of the Voronoi diagram

%% READ THE WAYPOINTS
[fileID,er] = fopen(fNavWpts, 'r');

k=1;
lon0 = 2; 
%figure
while (~feof(fileID))
    tline = fgetl(fileID);
  i=1;
  while(tline(i)~=' ')
   i=i+1;
  end
  id=tline(1:i-1);
  i=i+1;
  j=i;
  while(tline(i)~=' ')
   i=i+1;
  end
  lat=tline(j:i-1);
  i=i+1;
  sizetline=size(tline);
  lon=tline(i:sizetline(2));

  latn=extractLatLon(lat);
  lonn=extractLatLon(lon);
  [x,y] = mercatorProjection([latn,lonn],lon0);
  hold on
  %%plot(x,y,'r.','MarkerSize',12);
  text(x+8,y,id,'HorizontalAlignment','left','fontsize',8)
  axis equal
  wpt=struct('id',id,'pos',[round(x*1e3)/1e3,round(y*1e3)/1e3]);
  wpts(k)=wpt;  
  
  k=k+1;
end

fclose(fileID);

%% READ THE AIRWAYS AND CREATE THE SEGMENTS

[fileID,er] = fopen(fAirways, 'r');

k=1;
while (~feof(fileID))
    tline = fgetl(fileID);
  i=1;
  while(tline(i)~=' ')
   i=i+1;
  end
  origin=tline(1:i-1);
  i=i+1;
  j=i;
  sizetline=size(tline);
  destination=tline(j:sizetline(2));

  seg=createSegment(origin,destination,wpts);
  hold on
  if(seg.A(1)~=0 && seg.B(1)~=0)  
    %%plot([seg.A(1),seg.B(1)], [seg.A(2), seg.B(2)],'c-','MarkerSize',12)
  else
    disp(origin);
    disp(destination);
  end
  arw(k) = seg;
  k=k+1;
end

fclose(fileID);

%% CALCULATE INTERSECTIONS BETWEEN AIRWAYS

intervec = [];
for i = 1:size(arw,2)
    for j = 1:i
        if i ~= j
            inter = intersectSegments(arw(1,i),arw(1,j));
            if size(inter,2)==2;
                %plot(inter(1),inter(2),'bx','MarkerSize',8)
                intervec = [intervec; inter];
            end
        end
    end
end

[intercoord,realoccurence,totaloccurence] = simplifyrepeatedcomponents(intervec);

%% READ THE FIR AND CREATE THE SEGMENTS

[fileID,er] = fopen(fFir, 'r');

k=1;
while (~feof(fileID))
    tline = fgetl(fileID);
  i=1;
  while(tline(i)~=' ')
   i=i+1;
  end
  origin=tline(1:i-1);
  i=i+1;
  j=i;
  sizetline=size(tline);
  destination=tline(j:sizetline(2));

  seg=createSegment(origin,destination,wpts);
  hold on
  if(seg.A(1)~=0 && seg.B(1)~=0)  
    %plot([seg.A(1),seg.B(1)], [seg.A(2), seg.B(2)],'k-')
  else
    disp(origin);
    disp(destination);
  end
  fir(k) = seg;
  firpoly(k,1:2) = [seg.A(1),seg.A(2)];
  k=k+1;
end

fclose(fileID);

%% READ THE AIRCRAFT POSITIONS In this file the coordinates are already in the degrees format
[fileID,er] = fopen(fAC, 'r');

k=1;
lon0 = 2; 
while (~feof(fileID))
    tline = fgetl(fileID);
  i=1;
  while(tline(i)~=' ')
   i=i+1;
  end
  id=tline(1:i-1);
  i=i+1;
  j=i;
  while(tline(i)~=' ')
   i=i+1;
  end
  latn=str2num(tline(j:i-1));
  i=i+1;
  sizetline=size(tline);
  lonn=str2num(tline(i:sizetline(2)));

  [x,y] = mercatorProjection([latn,lonn],lon0);
  %hold on
  %%plot(x,y,'m+','MarkerSize',12);
  %text(x+8,y,id,'HorizontalAlignment','left','fontsize',8)
  %axis equal
  ACs(k, 1:2)=[x,y];  
  
  k=k+1;
end

fclose(fileID);
ACs=round(ACs*1e3)./1e3;
IN=inpolygon(ACs(:,1),ACs(:,2),firpoly(:,1),firpoly(:,2));
I=find(IN);
ACs1=ACs(I,:);
%plot(ACs1(:,1),ACs1(:,2),'r+','MarkerSize',14);

%% CALCULATE THE BOUNDARIES OF YOUR DOMAIN AND THE FICTION POINTS FOR VORONOI
for i = 1:size(fir,2)
    dataFir(2*i-1:2*i,:) = cell2mat(struct2cell(fir(:,i)));
end

minx = round(min(dataFir(:,1)))-100;
maxx = round(max(dataFir(:,1)))+100;
miny = round(min(dataFir(:,2)))-100;
maxy = round(max(dataFir(:,2)))+100;
axisbounds = [minx, maxx, miny, maxy];
extremeVor = [minx-1000, (maxy+miny)/2; maxx+1000, (maxy+miny)/2; (maxx+minx)/2, miny-1000; (maxx+minx)/2, maxy+1000];

%% CALCULATE INTERSECTIONS BETWEEN AIRWAYS AND FIR
interfir = [];
for i = 1:size(fir,2)
    for j = 1:size(arw,2)
        int= intersectSegments(fir(1,i),arw(1,j));
        if size(int,2)==2;
           %plot(int(1),int(2),'ms','MarkerSize',5)
           interfir = [interfir; int];
        end
    end
end

[intercoordfir,realoccurencefir,totaloccurencefir] = simplifyrepeatedcomponentsfir(interfir);

%% OUTPUT OF THE FUNCTION: A STRUCTURE AIRSPACE
Airspace = struct('InterFIR',intercoordfir,'OccureFIR',realoccurencefir,'InterArw',intercoord,...
   'OccureArw',realoccurence,'Airways',arw, 'AxisBounds',axisbounds,'ExtremeVor',extremeVor, 'AircraftCount', ACs1);
