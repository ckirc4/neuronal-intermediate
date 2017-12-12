function statesN = simulateStep(statesO, dur, p, q, neighbours, rSoma)
% Updates all states and keeps track of all births

n = length(statesO); % Number of COMPARTMENTS
deltaState = 1/dur; % intermediate value between 0 and 1
epsilon = 0.0001; % accounts for computational rounding
Random = rand(n,2); % each compartment is assigned two random values to check p and q against
statesN = statesO; % keep track of changes in states between each step

for i = 1:n
    if statesO(i) >= 1 - epsilon % i.e. if it is in state 1
        statesN(i) = 1 - deltaState;
        if Random(i,2) <= q
            continue; % code won't move on, hence impulse will not propagate
        end
        % go through neighbours
        for N = neighbours(i,:)
            if N == 0
                continue
            end
            if statesO(N) <= epsilon && statesN(N) <= epsilon % i.e. if neighbour is in state 0
                statesN(N) = 1;
            end
        end
        
    elseif statesO(i) <= epsilon % i.e. if it is in state 0
        if Random(i,1) <= p && statesN(i) <= epsilon % && sum(i == rSoma) == 0 % signal can't originate in soma
            statesN(i) = 1; 
        end
        
    else % i.e. it must be in state 2
        statesN(i) = statesO(i) - deltaState;
    end
    
end
    statesN = unitiseSoma(statesN, rSoma);
    
end
