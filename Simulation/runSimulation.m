function runSimulation(states, f, colours, state2duration, p_h, p_k, neighbours, deltaT, rSoma)

try    
    births = zeros(size(states,1),1);
    while 1
        tic
        
        [states, aC, births] = simulateStep(states, state2duration, p_h, p_k, neighbours, rSoma, births);
        f = updatePlot(states, f, colours);
        title(sprintf('Births: %i \nAnnihilations: %i',sum(births),aC));
        if toc < deltaT
            pause(deltaT - toc + 0.01); % for simple data sets, won't need much time
        else
            pause(0.035) % this pause is necessary to allow Matlab enough time to draw/update the frame in real time
        end

        if ~ishandle(1) 
            error(''); % figure closed
        end
    end
catch
    fclose('all');
    fprintf('Program terminated.\n');
end

end