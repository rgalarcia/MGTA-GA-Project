function [ObjV, Obj1, Obj2] = objFunctionWorkloadSectoring(Pheno,Airspace, alpha)
  ObjV=zeros(size(Pheno,1),1);
  for i=1:size(Pheno,1)
     indiv=Pheno(i,:);
     k=1;
     vor=zeros((size(indiv,2)/2)+size(Airspace.ExtremeVor,1),2);
     for j=1:2:size(indiv,2)
         vor(k,:)=[indiv(j) indiv(j+1)];
         k=k+1;
     end

     for j=1:size(Airspace.ExtremeVor,1)
         vor(k,:)=Airspace.ExtremeVor(j,:);
         k=k+1;
     end
     
     % Compute the complexity of each sector     
     comp = ComplexityFunction(vor,Airspace);
     
     % Compute the airspace related workload for each sector 
     workloadSectors=zeros(size(comp.FirIntersec,1),1);
     for m=1:size(comp.FirIntersec,1)
        workloadSectors(m)=computeWorkload(comp.FirIntersec(m),comp.AirwaysIntersec(m),comp.TransferNumber(m),comp.LengthAirwaysSector(m),...
                        sum(comp.FirIntersec(:)),sum(comp.AirwaysIntersec(:)),sum(comp.TransferNumber(:)),sum(comp.LengthAirwaysSector(:)));
     end

     % Define single objective functions
     Obj1=var(workloadSectors);          % Airspace related workload variance
     Obj2=var(comp.AircraftPerSector);   % Number of aircraft/sector, traffic related workload variance
     
     % Define globale objective function
     
     ObjV(i,1) = alpha*Obj1+ (1-alpha)*Obj2 ;           % Weighted sum of both objective function
     clear vor;
  end
end