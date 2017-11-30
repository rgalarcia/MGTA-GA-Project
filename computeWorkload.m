function WL=computeWorkload(nFirIntersec, nAirwaysIntersec, nTransfer, LengthAirways,...
                                TotalFirIntersec,TotalAWYIntersec,TotalnTransfer,TotalLengthAWY)
           
                        
% Weight for each cost
a1 = 6/TotalFirIntersec; a2 = 8/TotalAWYIntersec;
a3 = 5/TotalnTransfer;   a4 = 1/TotalLengthAWY;          % THINK OF RELATIVE WEIGHT OF THESE COSTS AND FIX!

% Weighted sum of complexity of each sector (airspace-based workload)
                   
WL = 1/(a1+a2+a3+a4)*(a1 * nFirIntersec + a2 * nAirwaysIntersec + a3 * nTransfer + ...
                       a4 * LengthAirways);
                   
end

