function WL=computeWorkload(nFirIntersec, nAirwaysIntersec, nTransfer, LengthAirways,...
                                TotalFirIntersec,TotalAWYIntersec,TotalnTransfer,TotalLengthAWY)
           
                        
% Weight for each cost
a1 = 11/TotalFirIntersec; a2 = 14/TotalAWYIntersec;
a3 = 10/TotalnTransfer;   a4 = 8/TotalLengthAWY;          % THINK OF RELATIVE WEIGHT OF THESE COSTS AND FIX!

% Weighted sum of complexity of each sector (airspace-based workload)
                   
WL = 1/(a1+a2+a3+a4)*(a1 * nFirIntersec + a2 * nAirwaysIntersec + a3 * nTransfer + ...
                       a4 * LengthAirways);
                   
end

