%% Create video

nFrames = 1800;
fps = 15;
res = [1280 720]; % resolution (in pixels) [width height]

fileName = 'tree.swc';
state2duration = 5;         % how many steps the refractory period lasts for
thicknessMult = 4;          % thickness multiplier when drawing figure
p_h = 0.00001;                 % probability that an impulse appears
p_k = 0.00000005;                 % probability that an impulse disappears

%% Calculations
tic
addpath(genpath(pwd));                      % add all subfolders to current path
data = readSwc(fileName);                   % select and load the data into Matlab
m = size(data,1);                           % m = # POINTS, not COMPARTMENTS
[cC, cP] = calculateConnections(data);      % represent the connections between compartments
neighbours = findNeighbours(cC,cP);         % stores the neighbours of each compartment
[t, rSoma, data] = timeToReachSoma(data);   % measures the number of steps it takes for a signal starting at each compartment to reach the soma
fprintf('Time taken to calculate initial variables: %.2f seconds\n',toc);
states = zeros(m-1,1); % keeps track of the state of each compartment


%% Visualisation
tic
colours = getTypeColours(data(:,2));        % colour according to type
f = drawNeuron(cC, data, thicknessMult, colours, 1); % draws the full neuron and saves handles to each line
set(gcf,'pos',[0 0 res(1) res(2)])
fprintf('Time taken to draw neuron for the first time: %.2f seconds\n',toc);

clear frames;

%% Simulate
tic
for i = 1:nFrames
    [states] = simulateStep(states, state2duration, p_h, p_k, neighbours, rSoma);
    f = updatePlot(states, f, colours);
    set(gca,'visible','off'); % hide axes
    frames(i) = getframe(gcf);
end
close
fprintf('Time taken to do simulation: %.2f seconds\n',toc);

%% Create video file
tic
video = VideoWriter(['Videos/' fileName '.avi'], 'Uncompressed AVI');
video.FrameRate = fps;
video.Quality = 100;
open(video)
video.writeVideo(frames);
close(video);
fprintf('Time taken to construct video: %.2f seconds\n',toc)