function trackS = calculateTrackStats(t, neighbours, rSoma, state2duration, P, Q, nSim)

nH = length(P); % number of h values
nK = length(Q); % numbber of k values
nC = length(t); % number of compartments
trackS = zeros(nH,nK,nC); % separate probability layer for each compartment

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
            thisScenarioSuccess = ones(nSim,1);
            
            for i = 1:nSim % simulate each scenario many times
                stepsToGo = t(com);
                states = initialStates;
                
                N = com;
                while stepsToGo >= 1 % i.e. signal hasn't reached soma yet             
                    if ~isempty(find(rSoma == N,1)) % if neighbour is soma, and in state 1
                        warning('Inconsistent distances. Attempting to continue')
                        break
                    end
                    
                    N = findLowestNeighbour(t, N, neighbours);
                    states = simulateStep(states, state2duration, p, q, neighbours, rSoma);
                    
                    if isempty(N) || states(N) ~= 1 % make sure that the neighbour closest to the soma has fired - if not, failure!
                        thisScenarioSuccess(i) = 0;
                        break
                    end
                                        
                    stepsToGo = stepsToGo - 1;
                end
            end
            
            trackS(h,k,com) = sum(thisScenarioSuccess)/nSim;
        end
    end
end

end