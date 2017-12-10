function states = unitiseSoma(states, rSoma)
% takes the current states and ensures that the soma is treated as a single
% entity rather than individual compartments.

somaStates = states(rSoma);

if ~isempty(find(somaStates==1,1)) % at least one soma compartment is 1
    states(rSoma) = 1;
end % the soma now behaves as a single unit 

end