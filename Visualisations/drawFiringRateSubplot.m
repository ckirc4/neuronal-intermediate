function drawFiringRateSubplot(firingRate, parula, true, cC, data, thicknessMult, fig, nh, p_h, nk, p_k, dim)
% To hold p constant while varying q, input nk = 0 and np = the entry of
% P_h that is to be used. Same goes for the other way around

if length(p_k) ~= 8
    error('p_k has unexpected length');
end
tic
f = figure(fig);
hold on;
if nk == 0 && nh ~= 0 % i.e. q is variable, p constant
    qVar = true;
    f.Name = sprintf('P_h = %.8f',p_h(nh));
elseif nh == 0 && nk ~= 0 % i.e. p is variable, q constant
    qVar = false;
    f.Name = sprintf('P_k = %.8f',p_k(nk));
else
    error('Either p or q must be held constant - check input')
end

n = 0;
for r = 1:dim(1)
    for c = 1:dim(2)
        n = n + 1;
        subplot(dim(1),dim(2),n);
        
        % draw the neuron
        if qVar == true
            colours = getHeatmapColours(firingRate(nh,n,:), parula, true);
            drawNeuron(cC, data, thicknessMult, colours);
            colorbar;
            
            minF = min(firingRate(nh,n,:));
            maxF = max(firingRate(nh,n,:));
            title(sprintf('P_k = %.8f\n',p_k(n)),'FontSize',11);
        else
            colours = getHeatmapColours(firingRate(n,nk,:), parula, true);
            drawNeuron(cC, data, thicknessMult, colours);
            colorbar;
            
            minF = min(firingRate(n,nk,:));
            maxF = max(firingRate(n,nk,:));
            title(sprintf('P_h = %.8f\n',p_h(n)),'FontSize',11);
        end
        
        % scale the colour bar
        if minF ~= maxF
            caxis([minF, maxF])
        else
            caxis([minF - 0.1, maxF])
        end
        axis off;
    end
end

if qVar == true
    fprintf('Showing heatmap for P_h = %.8f\n',p_h(nh));
else
  sprintf('Showing heatmap for P_k = %.8f\n',p_k(nk));
end

hold off;
fprintf('Time taken to generate plot: %.2f seconds\n',toc);
end