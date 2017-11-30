function Complex = ComplexityFunction(vor,Airspace)

% returns a structure of vectors of cost : 
% Complex = struct('FirIntersec',FIRint, 'AirwaysIntersec',Arwint, 'TransferNumber', TransferNumber,...
%    'LengthAirwaysSector',LengthAirwaysSector, 'AircraftPerSector',countAC );% where:
%   FIRint: vector of number of intersection points between airways and FIR
%           for each sector
%   Arwint: vector of number of intersection points between airways
%           for each sector
%   TransferNumber: vector of number of intersection points between airways
%           and sector for each sector
%   LengthAirwaysSector: vector of lengths of the airways 
%           within each sector
%   countAC: vector of number of aircraft (flights) inside each sector

[V,newc] = VoronoiCells(vor);
FIRint=zeros(size(newc,1),1);
Arwint=zeros(size(newc,1),1);
TransferNumber=zeros(size(newc,1),1);
LengthAirwaysSector=zeros(size(newc,1),1);
for i=1:size(newc,1) % loop in all voronoi cells
    polycoord = [V(newc{i,:},1),V(newc{i,:},2)];
    
    % Aircraft counts
    IN= inpolygon(Airspace.AircraftCount(:,1),Airspace.AircraftCount(:,2),V(newc{i,:},1),V(newc{i,:},2));
    I=find(IN);
    countAC(i)=size(I,1);
    
    % FIR intersection points
    FIRint(i)=Airspace.OccureFIR'*inpolygon(Airspace.InterFIR(:,1),Airspace.InterFIR(:,2),V(newc{i,:},1),V(newc{i,:},2));
    
    % airways intersection points
    inpo = inpolygon(Airspace.InterArw(:,1),Airspace.InterArw(:,2),V(newc{i,:},1),V(newc{i,:},2));
    Arwint(i) = Airspace.OccureArw'*inpo;
     
    % airways/sector intersection (transfert points) 
    % + length of airways within each sector
    counttransfer = 0;
    LengthAirways = 0;
    for j=1:size(Airspace.Airways,2) %loop in airways
        inters = intersectSegmentConvPolygon(Airspace.Airways(j), [V(newc{i,:},1),V(newc{i,:},2)]);
        if inters.n ~= -1
            counttransfer = counttransfer+inters.n;
            LengthAirways = LengthAirways + segmentLength(inters);
        end
    end
    TransferNumber(i) = counttransfer; % number of transfer points 
    LengthAirwaysSector(i) = LengthAirways; % lengths of inner airways
end

Complex = struct('FirIntersec',FIRint, 'AirwaysIntersec',Arwint, 'TransferNumber', TransferNumber,...
    'LengthAirwaysSector',LengthAirwaysSector, 'AircraftPerSector',countAC );
