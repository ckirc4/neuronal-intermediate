function [data, done] = pruneTree(data)
% removes the outermost layer (terminal branches) of the dendritic tree

children = data(:,7);
nParents = zeros(length(children),1);
for i = 2:length(children)
   nParents(children(i)) = nParents(children(i)) + 1;
end

% remove compartments that have no parents and are not part of the
% soma
remove = [];
for i = 1:length(nParents)
    if nParents(i) == 0 % compartment has 0 parents
        if data(i,2) ~= 1 % compartment is not soma
           remove(end+1) = i; 
        end
    end
end

if isempty(remove)
    done = true;
else
    data(remove,:) = [];
    data = organiseData(data);
    done = false;
end
end

function data = organiseData(data)
% makes sure nodes are numbered sequentially, etc.

reordered = []; % for each node that is changed: [old_id, new_id]

for i = 1:size(data,1)
   if data(i,1) == i
       continue % this entry is not affected
   end
   reordered(end+1,:) = [data(i,1), i];   
   data(i,1) = i;
end

for i = 1:size(reordered,1)
   old_id = reordered(i,1);
   new_id = reordered(i,2);
   % new_id <= old_id, so there won't be any duplication problems if going
   % from lowest id to highest
   data(find(data(:,7) == old_id),7) = new_id; % replace old with new
end

end
