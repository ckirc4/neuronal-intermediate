function Delta = calculateDynamicRange(firingRate,p_h)
% returns a nC*length(P_k) matrix that store the dynamic range for every
% compartment, for every value of q

[nP, nQ, nC] = size(firingRate);
Delta = zeros(nC,nQ);

for k = 1:nQ
    for c = 1:nC
        f = firingRate(:,k,c);
        f0 = f(1);
        f100 = f(end);
        fRange = f100-f0;
        f90 = fRange*0.9+f0;
        f10 = fRange*0.1+f0;
        
        % find the indeces in p_h that enclose the f10 and f90 values
        hPair10 = 0;
        hPair90 = 0;
        for h = 1:nP
            if f(h) > f10 && isequal(hPair10,0) % first pair
                hPair10 = [h h-1];
            elseif f(h) > f90 && isequal(hPair90,0)
                hPair90 = [h h-1];
            end
        end
        
        % linearly interpolate to approximate h10 and h90 values
        h10 = lint([p_h(hPair10(1)),f(hPair10(1))],...
            [p_h(hPair10(2)),f(hPair10(2))], ...
            f10);
        h90 = lint([p_h(hPair90(1)),f(hPair90(1))], ... point A
            [p_h(hPair90(2)),f(hPair90(2))], ... point B
            f90); % y
        
        Delta(c,k) = calculateDelta(h10,h90);
    end
end





end

function delta = calculateDelta(h10,h90)
delta = 10*log10(h90/h10);
end

function x = lint(A,B,y)
% Linearly interpolates between the points A and B in order to match an x
% to the given y value.
xa = A(1);
ya = A(2);
xb = B(1);
yb = B(2);

x = ((y - ya)*(xb - xa))/(yb - ya) + xa;
end