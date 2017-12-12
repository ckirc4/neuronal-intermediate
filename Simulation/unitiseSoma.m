function states = unitiseSoma(states, rSoma)
% takes the current states and ensures that the soma is treated as a single
% entity rather than individual compartments.

states(rSoma) = states(1);
% the soma now behaves as a single unit 

end