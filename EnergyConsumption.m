% Counts the number of dendritic spikes, and somatic spikes, over some
% period T. The ratio of those is the energy consumption.

%% Parameters
<<<<<<< HEAD
fileName = {'layer.swc', 'layer_small.swc', 'layer_close.swc'};
=======
fileName = {'tree.swc'}; 
>>>>>>> 49e979afcb1e85ddd92e8e1f44e12069f0365c81
nFiles = length(fileName);
T = 1000000; % time steps to simulate for
warmup = 100000; % time steps before tracking
state2duration = 5;
p_k = getPk(); % attenuation
% h = [0.00001, 0.00002, 0.00005, 0.0001, 0.0002, 0.0005, 0.001, 0.002, 0.005, 0.01, 0.02, 0.05, 0.1:0.1:0.9]; % excitatory input
[p_h, h] = calculatePh(-7:0.2:1);


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
    
 for k = p_k
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
            [states, aC, births] = simulateStep(states, state2duration, P_H, k, neighbours, rSoma, births);
        end
        
        
        for i = 1:T
            [states, aC, births] = simulateStep(states, state2duration, P_H, k, neighbours, rSoma, births);
            
            annihilations(trial) = annihilations(trial) + aC;
            if states(1) == 1 % somatic spike - first compartment is representative member for the whole of the soma
                somaticSpikes(trial) = somaticSpikes(trial) + 1;
            end
            % number of dendritic spikes: count the number of non-soma
            % compartments that are in state 1 (active)
            dendriticSpikes(trial) = dendriticSpikes(trial) + length(find(states(length(rSoma)+1:end)==1));
        end
        
        fprintf(['Calculated trial #%i/%i (for h = %.6f) in %.2f seconds at' datestr(datetime) '.\n'],trial, length(h), h(trial), toc)
    end
    
    energyConsumption = dendriticSpikes ./ somaticSpikes;
    
    %% Plot
    figure
    set(gcf,'pos',[0 0 1500 1500])
    subplot(1,3,1)
    semilogx(h,energyConsumption)
    title(sprintf('Energy consumption (P_k = %.8f)',k))
    axis square
    subplot(1,3,2)
    semilogx(h,somaticSpikes)
    title('Number of somatic spikes')
    axis square
    subplot(1,3,3)
    semilogx(h,dendriticSpikes)
    title('Number of dendritic spikes')
    axis square
    saveas(gcf,['Benchmarks/Energy_Plot' FILE '_inh0pk' num2str(k) '.png']);
    close
    
    %% Save
    save(['Benchmarks/Energy_Data_' FILE '_inh0pk' num2str(k) '.mat'],'T','k','p_h','h','energyConsumption','annihilations','dendriticSpikes','somaticSpikes','warmup')
    fprintf(['Finished calculation for ' FILE ' at ' datestr(datetime) '\n'])
 end
end