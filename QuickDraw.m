%% Parameters
fileName = input('Enter file name or URL: ','s');
thicknessMult = 8;          % thickness multiplier when drawing figure

%% Calculations
tic
addpath(genpath(pwd));                      % add all subfolders to current path
data = readSwc(fileName);                   % select and load the data into Matlab
[cC, ~] = calculateConnections(data);      % represent the connections between compartments
fprintf('Time taken to calculate initial variables: %.2f seconds\n',toc);

%% Visualisation
tic
colours = getTypeColours(data(:,2));        % colour according to type
f = drawNeuron(cC, data, thicknessMult, colours, 1); % draws the full neuron and saves handles to each line
axis off
fprintf('Time taken to draw neuron for the first time: %.2f seconds\n',toc);