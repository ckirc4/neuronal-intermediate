files = {'CentralSoma.swc', 'Funnel.swc', 'Convergence.swc', 'Layers.swc'};
nSim = [50 50 10000];

for i = 1:length(files)
    Times(1,:) = datetime;
    fileName = files{i};
    blindStats = BlindSimulationFunction(fileName, nSim(1));
    Times(2,:) = datetime;
    trackStats = TrackSimulationFunction(fileName, nSim(2));
    Times(3,:) = datetime;
    [firingRate, Delta] = FiringRateFunction(fileName, nSim(3));
    Times(4,:) = datetime;
    save(strcat(fileName(1:end-4), 'Results'), 'blindStats', 'trackStats', 'firingRate', 'Delta', 'Times');
    clear blindStats trackStats firingRate Delta Times
end