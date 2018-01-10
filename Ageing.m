fileName = 'Custom_Neuron.swc'; 
thicknessMult = 4;

data = readSwc(fileName);
done = false;
A = 0; % age



while ~isempty(data) && ~done
colours = getTypeColours(data(:,2)); 
[cC, ~] = calculateConnections(data);
[data, done] = pruneTree(data);
[m, ~] = size(data);

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
    
end