function blindP = calculateBlindStats(t, neighbours, rSoma, state2duration, P, Q, nSim, warmup)

nH = length(P); % number of h values
nK = length(Q); % numbber of k values
nC = length(t); % number of compartments
blindP = nan(nH,nK,nC); % separate probability layer for each compartment

itC = 1:nC;
itC(rSoma) = []; % iterate only through non-soma compartments

for com = itC 
    fprintf('Now simulating compartment #%i\n',com)
    initialStates = zeros(nC,1);
    
    for h = 1:nH
        for k = 1:nK
            p = P(h);
            q = Q(k);
            thisScenarioSuccess = zeros(nSim,1);
            
            for i = 1:nSim % simulate each scenario many times
                
                states = initialStates;
                for w = 1:warmup
                    states = simulateStep(states, state2duration, p, q, neighbours, rSoma);
                end
                
                states(com) = 1; % inject current into compartment
                expectedArrival = t(com);
                
                while expectedArrival >= 1
                    states = simulateStep(states, state2duration, p, q, neighbours, rSoma);
                    expectedArrival = expectedArrival - 1;
                end
                
                % check if soma has fired
                if states(1) == 1
                    thisScenarioSuccess(i) = 1;
                end
            end
            
            blindP(h,k,com) = sum(thisScenarioSuccess)/nSim;
        end
    end
end

end