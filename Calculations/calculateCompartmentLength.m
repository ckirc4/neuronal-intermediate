function l = calculateCompartmentLength(data)
% calculates the distance between each successive parent-child pair of
% points.

[m,~] = size(data);
coords = data(:,3:5); % isolate coordinates in data
parents = data(:,7);

l = zeros(m-1,1);

for i = 1:m-1
    parent = parents(i+1);
    dx = coords(i+1,1) - coords(parent,1);
    dy = coords(i+1,2) - coords(parent,2);
    dz = coords(i+1,3) - coords(parent,3);
    
    l(i) = sqrt(dx^2 + dy^2 + dz^2);
end

end