% this function makes the probability distribution of things given
% the variable and what it should be for the four cases where all top layer
% vars are equal
function Ps = makePs(V, cases)

%initialize Ps and other stuff
numTopLayer = length(V.parents);
Ps = zeros(1,(V.numVals*(4^numTopLayer)));

%increasing orders of powers of 4 (used to index)
pows = (4*ones(1,numTopLayer)).^(0:(numTopLayer-1));
% sumP = sum(pows);

for i=0:(4^numTopLayer -1)
   %get numbers that contribute
   toContrib = floor(i./pows);
   toContrib = mod(toContrib,4) + 1;
   
   %now, add that shit up mang!
   toAdd = zeros(1,V.numVals);
   for j = 1:numTopLayer
      toAdd = toAdd + cases(toContrib(j),:);
   end
   
   %dont forget to normalize!
   toAdd = toAdd./numTopLayer;
   
   %now, add toAdd at the appropriate place in Ps
   Ps((i*V.numVals +1):((i+1)*V.numVals)) = toAdd;
end

%iterate through all 

% %now, iterate through the 4 values and put them in the appropriate place
% for i=1:4
%     pos = V.numVals*(i-1)*sumP + 1;
%     Ps(pos:(pos+V.numVals-1)) = ...
%         cases(((i-1)*V.numVals+1):V.numVals*i);
% end

end