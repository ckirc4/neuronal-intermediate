%% Parameters
fileName = 'Custom_Neuron.swc';    % leave blank to open dialog box
state2duration = 5;         % how many steps the refractory period lasts for
thicknessMult = 4;          % thickness multiplier when drawing figure
nSim = 10000;                 % number of steps to simulate for each scenario (number of ms)

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

%% Firing Rate Heatmap Visualisation
close
fig = 2;
np = 15;
nk = 1;

% drawFiringRateSubplot(firingRate, parula, true, cC, data, thicknessMult, fig, np, p_h, nk, p_k, [3 4]);
drawFiringRatePlot(firingRate, parula, cC, data, thicknessMult, fig, np, p_h, nk, p_k);

%% F-h plot
figure(1)
s = find(data(:,2) == 1,1); % find first soma point
for q = length(p_k):-1:1
F = firingRate(:,q,s); % extract the firing rates at the soma
c(q,:) = [((length(p_k)+1-q)/(length(p_k))+0.5)/1.5 0 0]; % colour
semilogx(H,F,'s-','Color',c(q,:),'MarkerSize',5,'MarkerFaceColor',c(q,:));
hold on
end
xlabel('h')
ylabel('F (Hz)')
title('Response function of the soma of Neuron C, for various values of P_k')
cb = colorbar;
cb.Ticks = 0+1/(2*length(p_k)):1/length(p_k):1-1/(2*length(p_k));
cb.TickLabels = flip(p_k);
colormap(flip(c));
hold off


%% Dynamic Range Heatmap Visualisation
fig = 2;
q = 6;
colours = getHeatmapColours(Delta(:,q), parula, true);
drawNeuron(cC, data, thicknessMult, colours,fig);
colorbar;
caxis([min(Delta(:,q)),max(Delta(:,q))])
title(sprintf('Dynamic range for q = %.8f',p_k(q)),'FontSize',11);
axis off