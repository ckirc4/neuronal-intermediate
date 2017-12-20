% Counts the number of dendritic spikes, and somatic spikes, over some
% period T. The ratio of those is the energy consumption.

%% Parameters
fileName = {'MI.CNG.swc', 'Custom_Neuron.swc', 'tree.swc', 'flower.swc', 'arch.swc', 'central.swc', 'sapling.swc', 'pattern.swc'};
nFiles = length(fileName);
T = 500000; % time steps to simulate for
warmup = 50000; % time steps before tracking
state2duration = 5;
p_k = 0.005; % attenuation
% h = [0.00001, 0.00002, 0.00005, 0.0001, 0.0002, 0.0005, 0.001, 0.002, 0.005, 0.01, 0.02, 0.05, 0.1:0.1:0.9]; % excitatory input
[p_h, h] = calculatePh(-8:0.2:3);


for n = 1:nFiles
    FILE = fileName{n};
    %% Calculations
    tic
    addpath(genpath(pwd));                      % add all subfolders to current path
    data = readSwc(FILE);                   % select and load the data into Matlab
    m = size(data,1);                           % m = # POINTS, not COMPARTMENTS
    [cC, cP] = calculateConnections(data);      % represent the connections between compartments
    neighbours = findNeighbours(cC,cP);         % stores the neighbours of each compartment
    [t, rSoma, data] = timeToReachSoma(data);   % measures the number of steps it takes for a signal starting at each compartment to reach the soma
    fprintf('Time taken to calculate initial variables: %.2f seconds\n',toc);
    
    %% Simulation
    trial = 0; % index of h
    annihilations = zeros(length(h),1);
    dendriticSpikes = annihilations;
    somaticSpikes = annihilations;
    
    for P_H = p_h
        tic
        states = zeros(m-1,1); % keeps track of the state of each compartment
        births = zeros(size(states,1),1);
        trial = trial + 1;
        
        for i = 1:warmup
            [states, aC, births] = simulateStep(states, state2duration, P_H, p_k, neighbours, rSoma, births);
        end
        
        
        for i = 1:T
            [states, aC, births] = simulateStep(states, state2duration, P_H, p_k, neighbours, rSoma, births);
            
            annihilations(trial) = annihilations(trial) + aC;
            if states(1) == 1 % somatic spike - first compartment is representative member for the whole of the soma
                somaticSpikes(trial) = somaticSpikes(trial) + 1;
            end
            % number of dendritic spikes: count the number of non-soma
            % compartments that are in state 1 (active)
            dendriticSpikes(trial) = dendriticSpikes(trial) + length(find(states(length(rSoma)+1:end)==1));
        end
        
        fprintf('Calculated trial #%i/%i (for h = %.6f) in %.2f seconds.\n',trial, length(h), h(trial), toc)
    end
    
    energyConsumption = dendriticSpikes ./ somaticSpikes;
    
    %% Plot
    figure
    set(gcf,'pos',[0 0 1500 1500])
    subplot(1,3,1)
    semilogx(h,energyConsumption)
    title('Energy consumption')
    axis square
    subplot(1,3,2)
    semilogx(h,somaticSpikes)
    title('Number of somatic spikes')
    axis square
    subplot(1,3,3)
    semilogx(h,dendriticSpikes)
    title('Number of dendritic spikes')
    axis square
    saveas(gcf,['Benchmarks/Energy_Plot' FILE '_' num2str(min(h)) '-' num2str(max(h)) '.png']);
    
    %% Save
    save(['Benchmarks/Energy_Data_' FILE '_' num2str(min(h)) '-' num2str(max(h)) '.mat'],'T','p_k','p_h','h','energyConsumption','annihilations','dendriticSpikes','somaticSpikes')
    fprintf(['Finished calculation for ' FILE ' at ' datestr(datetime) '\n'])
end