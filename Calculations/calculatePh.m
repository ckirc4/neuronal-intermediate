function [P_h, H] = calculatePh()

logH = -5:0.25:2;
H = 10.^logH;
P_h = 1 - exp(-H);


end