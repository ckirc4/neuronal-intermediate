function closestNeighbour = findLowestNeighbour(t, c, n)
% returns the compartment numbers that are closest to soma, relative to
% the given compartment c.

neighbours = n(c,:);
neighbours(find(neighbours==0)) = []; %#ok<*FNDSB>
neighbourDist = t(neighbours);
closest = min(t(neighbours));

closestNeighbour = neighbours(find(neighbourDist==closest));

if length(closestNeighbour) > 1
    if ~closest == 0 % closest neighbour is not soma
            warning('Something went wrong when finding the neighbour that was closest. Attempting to continue')
    end
    closestNeighbour = closestNeighbour(1);
end

end