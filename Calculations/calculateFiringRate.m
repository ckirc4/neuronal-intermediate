function firingRate = calculateFiringRate(t, neighbours, rSoma, state2duration, P, Q, nSim, warmup)

nH = length(P); % number of h values
nK = length(Q); % numbber of k values
nC = length(t); % number of compartments
firingRate = zeros(nH,nK,nC); % separate probability layer for each compartment

initialStates = zeros(nC,1);

for h = 1:nH
    for k = 1:nK
        p = P(h);
        q = Q(k);
        thisScenarioCounter = zeros(nC,1);
        states = initialStates;
        
        fprintf('Now simulating p=%.8f, q=%.8f\n',p,q)
        for w = 1:warmup
            states = simulateStep(states, state2duration, p, q, neighbours, rSoma);
        end
        
        for i = 1:nSim % simulate many steps for each scenario
            
            states = simulateStep(states, state2duration, p, q, neighbours, rSoma);
            thisScenarioCounter = thisScenarioCounter + floor(states);
            
        end
        
        firingRate(h,k,:) = thisScenarioCounter/(nSim/1000); % how many times the compartment fires per 1 second (1000 steps)
    end
end

end