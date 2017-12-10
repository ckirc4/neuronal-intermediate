function blindP = calculateBlindStats(t, neighbours, rSoma, state2duration, P, Q, nSim)

nH = length(P); % number of h values
nK = length(Q); % numbber of k values
nC = length(t); % number of compartments
blindP = zeros(nH,nK,nC); % separate probability layer for each compartment

itC = 1:nC;
itC(rSoma) = []; % iterate only through non-soma compartments

for com = itC 
    fprintf('Now simulating compartment #%i\n',com)
    initialStates = zeros(nC,1);
    initialStates(com) = 1;
    
    for h = 1:nH
        for k = 1:nK
            p = P(h);
            q = Q(k);
            thisScenarioSuccess = zeros(nSim,1);
            
            for i = 1:nSim % simulate each scenario many times
                expectedArrival = t(com);
                states = initialStates;
                
                while expectedArrival >= 1
                    states = simulateStep(states, state2duration, p, q, neighbours, rSoma);
                    expectedArrival = expectedArrival - 1;
                end
                
                % check if arrived
                for s = rSoma
                    if states(s) == 1
                        thisScenarioSuccess(i) = 1;
                        break;
                    end
                end
            end
            
            blindP(h,k,com) = sum(thisScenarioSuccess)/nSim;
        end
    end
end

end