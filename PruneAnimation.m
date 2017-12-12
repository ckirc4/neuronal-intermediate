fileName = 'Custom_Neuron.swc'; 
thicknessMult = 4;
data = readSwc(fileName);
done = false;

while ~isempty(data) && ~done
colours = getTypeColours(data(:,2)); 
[cC, ~] = calculateConnections(data);
f = drawNeuron(cC, data, thicknessMult, colours, 1);
[data, done] = pruneTree(data);
drawnow
pause(0.5);
end