function drawFiringRatePlot(firingRate, parula, cC, data, thicknessMult, fig, nh, p_h, nk, p_k)
tic
f = figure(fig);

% draw the neuron

colours = getHeatmapColours(firingRate(nh,nk,:), parula, true);
drawNeuron(cC, data, thicknessMult, colours);
colorbar;

minF = min(firingRate(nh,nk,:));
maxF = max(firingRate(nh,nk,:));
title(sprintf('P_h = %.8f, P_k = %.8f\n',p_h(nh),p_k(nk)));


% scale the colour bar
if minF ~= maxF
    caxis([minF, maxF])
else
    caxis([minF - 0.1, maxF])
end
axis off;

fprintf('Time taken to generate plot: %.2f seconds\n',toc);
end