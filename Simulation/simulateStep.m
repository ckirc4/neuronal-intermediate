function [statesN, annihilationCount, births] = simulateStep(statesO, dur, p, q, neighbours, rSoma, births)
% Updates all states and keeps track of all births
% births(i) == 1 implies that the signal in i'th compartment was born in
% previous step
% - if two signals annihilate each other head-on, # annihilation = 1
% - if two signals combine (merge) into one, # annihilation = 1. This is
% because the signal travelling from one active compartment to the other
% active compartment technically gets annihilated (even if it's from the
% same "birth" event), which is an intrinsic shortcoming that cannot be
% avoided.

if nargout < 1 || nargout > 3
    error('Incorrect number of output variables.')
elseif nargout == 2
    error('Must output both annihilationCount and births.')
elseif nargin == 3 && nargin ~= 7
    error('When tracking annihilation events, must input the births variable from the previous step.')
elseif nargin == 6
    births = zeros(length(statesO),1);
end

n = length(statesO); % Number of COMPARTMENTS
deltaState = 1/dur; % intermediate value between 0 and 1
epsilon = 0.0001; % accounts for computational rounding
Random = rand(n,3); % each compartment is assigned three random values to check p, q and the inhibitory probability against
statesN = statesO; % keep track of changes in states between each step
annihilationCount = 0;

for i = [1 rSoma(end)+1:n] % consider soma as a single entity, i.e. somas comprised of a higher number of compartments won't have a higher chance of receiving signal. Point of contact to rest of dendritic tree is at first point
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
            else % neighbour is in state 1 or 2
                if N ~= 1 && ~isempty(find(rSoma == N,1)) % neighbour is part of soma, but not representative soma compartment (#1) - ignore collisions
                    continue
                end
                if statesN(N) == 1 
                    continue % signal will merge with neighbour's; don't annihilate
                end
                annihilationCount = annihilationCount + 1;
            end
        end
        if births(i) == 1
            % was born in previous step
            births(i) = 0;
        elseif births(i) == 0
            annihilationCount = annihilationCount - 1; % remove collision caused by signal colliding with its own trail - always happens except step after it's born
        end
        
    elseif statesO(i) <= epsilon % i.e. if it is in state 0
        if Random(i,1) <= p && statesN(i) <= epsilon % excitatory
            statesN(i) = 1; 
            births(i) = 1;
        end
        
        % inhibitory
        if Random(i,3) <= 0.2*p
            % statesN(i) = 1 - deltaState;
        end
                
    else % i.e. it must be in state 2
        statesN(i) = statesO(i) - deltaState;
    end
    
end
    statesN = unitiseSoma(statesN, rSoma);
    
end
