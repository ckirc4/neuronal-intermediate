fileName = 'tree.swc'; 
thicknessMult = 4;
data = readSwc(fileName);
done = false;
age = 1;
figure(1)

while ~isempty(data) && ~done
colours = getTypeColours(data(:,2)); 
[cC, ~] = calculateConnections(data);
f = drawNeuron(cC, data, thicknessMult, colours, 1);
ylim([0, 100])
xlim([-50, 80])
title(sprintf('Age = %i',age));
saveas(1,['tree_age_' num2str(age) '.png']);
[data, done] = pruneTree(data);
age = age + 1;
drawnow
pause(0.5);
end