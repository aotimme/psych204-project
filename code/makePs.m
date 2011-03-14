% this function makes the probability distribution of things given
% the variable and what it should be for the four cases where all top layer
% vars are equal
function Ps = makePs(V, cases)

%initialize Ps and other stuff
numTopLayer = length(V.parents);
Ps = (1/V.numVals)*ones(1,(V.numVals*(4^numTopLayer)));

%increasing orders of powers of 4 (used to index)
pows = (4*ones(1,numTopLayer)).^(0:(numTopLayer-1));
sumP = sum(pows);

%now, iterate through the 4 values and put them in the appropriate place
for i=1:4
    pos = V.numVals*(i-1)*sumP + 1;
    Ps(pos:(pos+V.numVals-1)) = ...
        cases(((i-1)*V.numVals+1):V.numVals*i);
end

end