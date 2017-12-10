function f = updatePlot(states, f, colours)
% Modifies the colour property of each compartment (line)

for i = 1:length(f)
    if states(i) == 1
        f(i).Color = [1,0,0];
    elseif states(i) <= 0.00001
        f(i).Color = colours(i);
    else
        f(i).Color = [1,165/255,0];
    end
end

drawnow;

end