function [P_h, H] = calculatePhReduced()

logH = -2:1:1;
H = 10.^logH;
P_h = 1 - exp(-H);


end