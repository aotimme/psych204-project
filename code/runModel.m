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

%set any states you wanna hold constant!!!!!!!! %%%%%%%%%%%%%%%%%%
% doNotSample = [length(state)]; %the observation that I=1
doNotSample = [];

doNotSample = [doNotSample numTopLayer+5]; %NO
state(numTopLayer+5) = 3; %NO = 2.5
% doNotSample = [doNotSample numTopLayer+3]; %HV
% state(numTopLayer+3) = 2; %HV is on
% doNotSample = [doNotSample numTopLayer+1]; %D
% state(numTopLayer+1) = 2; %D = 3
% doNotSample = [doNotSample numTopLayer+2]; %R
% state(numTopLayer+2) = 1; %R = on
doNotSample = [doNotSample numTopLayer+4]; %CC
state(numTopLayer+4) = 1; %CC = 0


sampleFrom = 1:5+numTopLayer;
for i = 1:length(doNotSample)
   sampleFrom(doNotSample(i)) = 0; 
end

%now, GIBBS SAMPLE OMG!!!!!!!!!!
numGibbsIters = 200000;
burnInTime = 10000;
percepts = zeros(length(CPDs)-1, numGibbsIters);
lastStateSampled = 1;

for g=1:(numGibbsIters + burnInTime)
    
    if(mod(g,10000) == 0)
        fprintf('on %d iteration of gibbs\n', g);
    end
    
    %choose a state at random to sample
    sampleFrom(lastStateSampled) = 0;
    toSample = 0;
    while(toSample == 0)
        toSample = sampleFrom(ceil(rand(1,1)*length(sampleFrom)));
    end
    sampleFrom(lastStateSampled) = lastStateSampled;
    
    %sample!
    Ps = resampleVar(CPDs, state, toSample);
    state(toSample) = find(mnrnd(1,Ps));
        
    
    %wait until after burn in time to take samples
    if(g > burnInTime)
        percepts(:,g-burnInTime) = state(1:numTopLayer+5)';
    end
    
    lastStateSampled = toSample;
end

%% analytics -- this could prolly be in a new script/file %%

% show sampling's estimates of probability
probEstimates = zeros(1,4);
for i=1:4
   probEstimates(i) = sum(sum(percepts(1:numTopLayer,:) == i))/(numGibbsIters*numTopLayer); 
end
probEstimates


%choose a function to use to analyze
if(numTopLayer == 1)
    analyze1d;
else
    analyzeMultD;
end


