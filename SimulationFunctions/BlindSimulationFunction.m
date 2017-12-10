function blindStats = BlindSimulationFunction(fileName, nSim)

%% Parameters
state2duration = 5;         % how many steps the refractory period lasts for

%% Calculations
tic
addpath(genpath(pwd));                      % add all subfolders to current path
data = readSwc(fileName);                   % select and load the data into Matlab
[cC, cP] = calculateConnections(data);      % represent the connections between compartments
neighbours = findNeighbours(cC,cP);         % stores the neighbours of each compartment
[t, rSoma, data] = timeToReachSoma(data);   % measures the number of steps it takes for a signal starting at each compartment to reach the soma
p_k = getPkReduced();            % probability that an impulse disappears
[p_h, H] = calculatePhReduced();                % probability that an impulse appears
fprintf('Time taken to calculate initial variables: %.2f seconds\n',toc);

%% Simulation
tic
blindStats = calculateBlindStats(t, neighbours, rSoma, state2duration, p_h, p_k, nSim);
fprintf('Time taken to simulate blindStats: %.2f seconds\n',toc);

end