%% first, populate probabilities %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%makeSimpleModel;
makeVarSizeTopModel;


%% now, perform gibbs sampling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize the state
state = ones(1,6+numTopLayer);

%sample top layer
for i=1:numTopLayer
    state(i) = find(mnrnd(1,CPDs(i).probs));
end
%sample 2nd level vars from the class
for i=(numTopLayer+1):(length(CPDs)-1)
    Ps = observeEvidence(CPDs, state, i);
    state(i) = find(mnrnd(1,Ps));
end


%now, GIBBS SAMPLE OMG!!!!!!!!!!
numGibbsIters = 1000000;
burnInTime = 10000;
percepts = zeros(numTopLayer, numGibbsIters);
lastStateSampled = 1;

for g=1:(numGibbsIters + burnInTime)
    
    if(mod(g,10000) == 0)
        fprintf('on %d iteration of gibbs\n', g);
    end
    
    %choose a state at random to sample
    toSample = ceil(rand(1,1)*(length(CPDs)-2));
    if(toSample >= lastStateSampled) toSample = toSample + 1; end
    
    Ps = resampleVar(CPDs, state, toSample);
    state(toSample) = find(mnrnd(1,Ps));
        
    
    %wait until after burn in time to take samples
    if(g > burnInTime)
        percepts(:,g-burnInTime) = state(1:numTopLayer)';
    end
    
    lastStateSampled = toSample;
end

%% analytics -- this could prolly be in a new script/file %%

% show sampling's estimates of probability
probEstimates = zeros(1,4);
for i=1:4
   probEstimates(i) = sum(sum(percepts == i))/(numGibbsIters*numTopLayer); 
end
probEstimates


%choose a function to use to analyze
if(numTopLayer == 1)
    analyze1d;
else
    analyzeMultD;
end


