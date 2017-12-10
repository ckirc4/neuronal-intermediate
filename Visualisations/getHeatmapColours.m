function colours = getHeatmapColours(valuesIn, map, scaled)
% outputs an RGB colour vector
% values must be a nC long vector

if nargin == 2
    scaled = false;
end
if ndims(valuesIn) == 3 % 3D input, when mapping firing rate values
    nC = size(valuesIn,3);
    values(1:nC) = valuesIn(:,:,:); % convert 3D input to 1D vector
elseif ndims(valuesIn) == 2
    nC = length(valuesIn);
    values(1:nC) = valuesIn(1:nC);
end

n = size(map,1);

if scaled
   % scale the input so that 0 is the lowest value, and 1 is the highest.
   m = min(values);
   range = max(values)-m;
   if range == 0
       values = ones(1,length(values));
   else
       for s = 1:nC
           values(s) = (values(s)-m)/range; % scaled to range of values
       end
   end
   sValues = round(values*(n-1))+1; % scale values to map
else
    sValues = ceil(values*n); % scale values to map
end



colours = zeros(length(values),3);

for i = 1:length(values)
    if isnan(sValues(i))
        colours(i,:) = [0.5 0.5 0.5]; % NaN = gray
    elseif sValues(i) == 0
        colours(i,:) = [0 0 0]; % 0 percent = black
    else
        colours(i,:) = map(sValues(i),:);
    end
end

end