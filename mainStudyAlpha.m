%SECTION 1: clear workspace and data
profile on
clc
clear all
close all
addpath gatoolbox
% addpath data

%alpha = 0;
dA = 0.025;

valuesAlpha = [];
valuesObj = [];
valuesObj1 = [];
valuesObj2 = [];

steps = (1/dA)*130;
t = cputime;

numpoints = (1/dA);
parfor i = 1:numpoints+1
    [valuesObj(i), valuesObj1(i), valuesObj2(i)] = studyAlpha((i-1)*dA,dA,steps,cputime);
    valuesAlpha(i) = (i-1)*dA;
end
plots (valuesAlpha,valuesObj1,valuesObj2)

function [valueObj, valueObj1, valueObj2] = studyAlpha(alpha, dA, steps, t) 
    %SECTION 2: CREATE THE AIRSPACE: output: airways, int points of arw, int points arw/FIR
    fNavWpts='NavWpts.dat'; % airspace waypoints
    fAirways='Airways.dat'; % definition of airways
    fFir='FIR.dat'; % definition of FIR
    fAC='LatLon-FIR-FL300up-filt-1155-1210.dat'; % traffic data
    Airspace= CreateAirspace(fNavWpts,fAirways,fFir,fAC);
    NAC = size(Airspace.AircraftCount,1);

    %SECTION 3: GENETIC ALGORITHM SOLUTION
    % Parameters of the Genetic Algorithm
    NIND = 50;                  % Number of individuals per subpopulations          !!FIX!!
    MAXGEN = 130;                % maximum Number of generations                     !!FIX!!
    GGAP = 0.8;                  % Generation gap, how many new individuals are created !!FIX!!
    NSECT = max(2,ceil(NAC/15));   	         % Number of sectors                                 !!FIX!!
    NVAR = NSECT*2;               % Number of variables                               !!FIX!!
    PRECI = 20;              % Precision of binary representation              

    % Build field descriptor

       FieldD = repmat([PRECI,PRECI;Airspace.AxisBounds(1),Airspace.AxisBounds(3);...
           Airspace.AxisBounds(2),Airspace.AxisBounds(4);1,1;0,0;1,1;1,1],[1,NVAR/2]);   
       %!!FIX!!
    % Initialise population
       Chrom = crtbp(NIND, NVAR*PRECI);

    % Reset counters
       Best = NaN*ones(MAXGEN,1);	% best in current population
       gen = 0;			% generational counter

    % Evaluate initial population
       ObjV = objFunctionWorkloadSectoring(bs2rv(Chrom,FieldD),Airspace, alpha);       % open and check

    % Track best individual and display convergence
       Best(gen+1) = min(ObjV);

    % Generational loop
       while gen < MAXGEN

        % Assign fitness-value to entire population
           FitnV = ranking(ObjV);       

        % Select individuals for breeding
           SelCh = select('sus', Chrom, FitnV, GGAP);

        % Recombine selected individuals (crossover)
           SelCh = recombin('xovsh',SelCh,0.7);

        % Perform mutation on offspring
           SelCh = mut(SelCh);

        % Evaluate offspring, call objective function
           ObjVSel = objFunctionWorkloadSectoring(bs2rv(SelCh,FieldD),Airspace, alpha);

        % Reinsert offspring into current population
           [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);

        % Increment generational counter
           gen = gen+1;

        % Update display and record current best individual
           Best(gen+1) = min(ObjV);
           %semilogy(Best,'ro'); xlabel('Number of generations'); ylabel('Objective function value (Best)');
           %text(0.5,0.95,['Best = ', num2str(Best(gen+1))],'Units','normalized');
           %drawnow;
         %disp('END GENERATION')
         
         sprintf('Alpha: %.3f / Generation number: %d / Progress: %.1f / Time: %d s', alpha, gen, (gen/MAXGEN)*100, int16(cputime-t))
       end 
    % End of GA
    
    [x,i]=min(ObjV);
    BestPheno=bs2rv(Chrom(i,:),FieldD);

    % Plot the final sectorization
    CreateAirspace(fNavWpts,fAirways,fFir,fAC);k=1;
    for j=1:2:size(BestPheno,2)
     vorx(k)=BestPheno(j);
     vory(k)=BestPheno(j+1);
     k=k+1;
    end

    vorfinal = [[vorx',vory']; Airspace.ExtremeVor];

    finalcomplexity = ComplexityFunction(vorfinal,Airspace);

    voronoi(vorfinal(:,1), vorfinal(:,2));

    for i=1:size(vorx',1)
        id = num2str(i);
    end

    [ObjV, Obj1, Obj2] = objFunctionWorkloadSectoring(BestPheno,Airspace, alpha);
    valueObj = ObjV;
    valueObj1 = Obj1;
    valueObj2 = Obj2;
end