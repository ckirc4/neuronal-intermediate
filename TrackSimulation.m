%% Parameters
fileName = 'Custom_Neuron.swc';    % leave blank to open dialog box
state2duration = 5;         % how many steps the refractory period lasts for
thicknessMult = 4;          % thickness multiplier when drawing figure
nSim = 500;                 % number of simulations per scenario

%% Calculations
tic
addpath(genpath(pwd));                      % add all subfolders to current path
data = readSwc(fileName);                   % select and load the data into Matlab
[cC, cP] = calculateConnections(data);      % represent the connections between compartments
neighbours = findNeighbours(cC,cP);         % stores the neighbours of each compartment
[t, rSoma, data] = timeToReachSoma(data);   % measures the number of steps it takes for a signal starting at each compartment to reach the soma
p_k = getPkReduced();             % probability that an impulse disappears
[p_h, logh] = calculatePhReduced();                % probability that an impulse appears
fprintf('Time taken to calculate initial variables: %.2f seconds\n',toc);

%% Simulation
tic
trackStats = calculateTrackStats(t, neighbours, rSoma, state2duration, p_h, p_k, nSim);
fprintf('Time taken to simulate trackStats: %.2f seconds\n',toc);

%% Visualisation
nh = 2;
nk = 3;
tic
colours = getHeatmapColours(trackStats(nh,nk,:), parula); % map is a global variable; https://au.mathworks.com/help/matlab/ref/colormap.html
drawNeuron(cC, data, thicknessMult, colours, 2);
title(sprintf('Showing heatmap for P_h = %.8f, and P_k = %.8f\n',p_h(nh),p_k(nk)));
colorbar;
fprintf('Time taken to generate plot: %.2f seconds\n',toc);