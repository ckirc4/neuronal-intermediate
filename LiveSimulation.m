%% Parameters
fileName = 'http://neuromorpho.org/dableFiles/rainnie/CNG%20version/P07-R2040910.CNG.swc';    % leave blank to open dialog box
deltaT = 0.1;             % minimum time between frames (seconds)
state2duration = 5;         % how many steps the refractory period lasts for
thicknessMult = 4;          % thickness multiplier when drawing figure
p_h = 0.0001;                 % probability that an impulse appears
p_k = 0.01;                 % probability that an impulse disappears

%% Calculations
tic
addpath(genpath(pwd));                      % add all subfolders to current path
data = readSwc(fileName);                   % select and load the data into Matlab
m = size(data,1);                           % m = # POINTS, not COMPARTMENTS
[cC, cP] = calculateConnections(data);      % represent the connections between compartments
neighbours = findNeighbours(cC,cP);         % stores the neighbours of each compartment
[t, rSoma, data] = timeToReachSoma(data);   % measures the number of steps it takes for a signal starting at each compartment to reach the soma
fprintf('Time taken to calculate initial variables: %.2f seconds\n',toc);

%% Visualisation
tic
colours = getTypeColours(data(:,2));        % colour according to type
f = drawNeuron(cC, data, thicknessMult, colours, 1); % draws the full neuron and saves handles to each line
fprintf('Time taken to draw neuron for the first time: %.2f seconds\n',toc);

%% Simulation
states = zeros(m-1,1); % keeps track of the state of each compartment
runSimulation(states, f, colours, state2duration, p_h, p_k, neighbours, deltaT, rSoma); % simulates the progression of signals within the neuron