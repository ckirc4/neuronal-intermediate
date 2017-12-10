function [firingRate, Delta] = FiringRateFunction(fileName, nSim)

%% Parameters
state2duration = 5;         % how many steps the refractory period lasts for

%% Calculations
tic
addpath(genpath(pwd));                      % add all subfolders to current path
data = readSwc(fileName);                   % select and load the data into Matlab
[cC, cP] = calculateConnections(data);      % represent the connections between compartments
neighbours = findNeighbours(cC,cP);         % stores the neighbours of each compartment
[t, rSoma, data] = timeToReachSoma(data);   % measures the number of steps it takes for a signal starting at each compartment to reach the soma
p_k = getPk();         % probability that an impulse fails to propogate
[p_h, H] = calculatePh();                % probability that a compartment fires
fprintf('Time taken to calculate initial variables: %.2f seconds\n',toc);

%% Simulation
tic
% how many times each compartment fires per 1 second (1000 steps)
firingRate = calculateFiringRate(t, neighbours, rSoma, state2duration, p_h, p_k, nSim);
Delta = calculateDynamicRange(firingRate,p_h);
fprintf('Time taken to simulate firingRate: %.2f seconds\n',toc);

end