%% this model makes a simple model with a fully connected top layer and stuff
%the top layer is fully connected with the mid-feature layer
%eliminates the connection between dim and rotation
%also, if the top layers are different classes, then the dist. is uniform
%over the mid-feature layer

%make top layer
epsilon = 0.05
numTopLayer = 4;
CPDs = [];

for i=1:numTopLayer
    
    P.probs = [0.35 0.35 0.2 0.1];
    P.name = 'class label';
    P.parents = [];
    P.numVals = 4;
    CPDs = [CPDs P];
    
end

%% put in mid-layer shit %%%%%%%%%%%%

% helper shit
ep10 = [(1-epsilon) epsilon];
ep01 = [epsilon (1-epsilon)];
%more helpers
ep100 = [(1-2*epsilon) epsilon epsilon];
ep011 = [epsilon (1-epsilon)/2 (1-epsilon)/2];
ep001 = [epsilon epsilon (1-2*epsilon)];
ep010 = [epsilon (1-2*epsilon) epsilon];


%set distribution for middle vars:
%   dimension, rotation, horizontal velocity, column correlation, and # of
%   objects

%dim.probs = p(D|horizonal), p(D|helix), etc...
%where p(D|x) goes in the order p(d=2|x) then p(d=3|x)
Dim.parents = 1:numTopLayer;
Dim.numVals = 2; %dim =2, dim=3
Dim.name = 'dimension';
Dim.probs = makePs(Dim, [ep10 ep01 ep01 ep10]);
CPDs = [CPDs Dim];

%rotation = p(R|class1),p(R|class2)......p(R|class4)

Rot.parents = 1:numTopLayer;
Rot.numVals = 3; %0(none) 1 2
Rot.name = 'rotation';
                        %does the wave have rotation????
Rot.probs = makePs(Rot, [ep100 ep100 ep011 ep100]);
CPDs = [CPDs Rot];

%horizontal velocity = P(H|class1)...p(H|class4)
HV.parents = 1:numTopLayer;
HV.numVals = 2; %0(none) 1(moving horizontally)
HV.name = 'horizontal velocity';
HV.probs = makePs(HV, [ep01 ep10 ep10 ep10]); %does the wave have HV?
CPDs = [CPDs HV];

%column correlation = P(C|class1)...P(C|class4)
CC.parents = 1:numTopLayer;
CC.numVals = 2; %no correlation, correlation
CC.name = 'column correlation';
CC.probs = makePs(CC, [ep01 ep01 ep01 ep10]);
CPDs = [CPDs CC];

%number of objects = P(O|class1)....P(O|class4)
NO.parents = 1:numTopLayer;
NO.numVals = 3; %1 2(for horizontal) 30(for dots moving up/down)
NO.name = 'number objects';
NO.probs = makePs(NO, [ep010 ep100 ep100 ep001]);
CPDs = [CPDs NO];

%% set the cpd for the bottom variable, WHAT A BITCH %%%%%%

%valid configs - 

OV.parents = (numTopLayer +1):(numTopLayer+5); %[2 3 4 5 6];
OV.numVals = 2; %off or on (in that order) - only valid configs are on
OV.name = 'observed stimulus';
    %each row: p(OV|dim2,rot0),
    %p(OV|dim3,rot0),p(OV|dim2,rot1).....p(OV|dim3,rot2)
OV.probs = [ep10 ep10 ep10 ep10 ep10 ep10... %hv = 0, cc = 0, #obj = 1 
            ep10 ep10 ep10 ep10 ep10 ep10... %hv = 1, cc=0, #obj = 1
            ep10 ep01 ep10 ep01 ep10 ep01... %hv = 0, cc=1, #obj = 1
            ep10 ep10 ep10 ep10 ep10 ep10... %hv = 1, cc=1, #obj = 1
            ep10 ep10 ep10 ep10 ep10 ep10... %hv = 0, cc=0, #obj = 2.5
            ep10 ep10 ep10 ep10 ep10 ep10... %hv = 1, cc=0, #obj = 2.5
            ep10 ep10 ep10 ep10 ep10 ep10... %hv = 0, cc=1, #obj = 2.5
            ep01 ep10 ep10 ep10 ep10 ep10... %hv = 1, cc=1, #obj = 2.5
            ep01 ep10 ep10 ep10 ep10 ep10... %hv = 0, cc=0, #obj = 30
            ep10 ep10 ep10 ep10 ep10 ep10... %hv = 1, cc=0, #obj = 30
            ep10 ep10 ep10 ep10 ep10 ep10... %hv = 0, cc=1, #obj = 30
            ep10 ep10 ep10 ep10 ep10 ep10... %hv = 1, cc=1, #obj = 30
            ];
CPDs = [CPDs OV];

%% now finally initialize the state %%%%%%%%%%%%%%

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

