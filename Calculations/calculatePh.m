function [P_h, H] = calculatePh(logH)

if nargin == 0
   seqMin = -5;
   seqMax = 2;
   seqStep = 025;
   logH = seqMin:seqMax:seqStep;
end

H = 10.^logH;
P_h = 1 - exp(-H);


end