%makes the simple model we first started with

% store probabilities in a struct
% noise parameter is epsilon

epsilon = 0.01
numTopLayer = 1;
CPDs = [];
%helpers:
ep01 = [epsilon (1-epsilon)];
ep10 = [(1-epsilon) epsilon];
%more helpers
ep100 = [(1-2*epsilon) epsilon epsilon];
ep011 = [epsilon (1-epsilon)/2 (1-epsilon)/2];
ep001 = [epsilon epsilon (1-2*epsilon)];
ep010 = [epsilon (1-2*epsilon) epsilon];


%set distribution for top var
%p.probs equals prob for horizontal moving objects, double helix, wave, and
%moving dots
P.probs = [0.35 0.35 0.2 0.1];
P.name = 'class label';
P.parents = [];
P.numVals = 4;
CPDs = [CPDs P];

%% set distribution for middle vars:
%   dimension, rotation, horizontal velocity, column correlation, and # of
%   objects

%dim.probs = p(D|horizonal), p(D|helix), etc...
%where p(D|x) goes in the order p(d=2|x) then p(d=3|x)
Dim.parents = [1];
Dim.numVals = 2; %dim =2, dim=3
Dim.name = 'dimension';
Dim.probs = [ep10 ep01 ep01 ep10];
CPDs = [CPDs Dim];

%rotation = p(R|class1,dim1),p(R|class2,dim1)......p(R|class4,dim2)

Rot.parents = [1 2];
Rot.numVals = 3; %0(none) 1 2
Rot.name = 'rotation';
                        %does the wave have rotation????
Rot.probs = [ep100 ep100 ep100 ep100 ep100 ep011 ep100 ep100];
CPDs = [CPDs Rot];

%horizontal velocity = P(H|class1)...p(H|class4)
HV.parents = [1];
HV.numVals = 2; %0(none) 1(moving horizontally)
HV.name = 'horizontal velocity';
HV.probs = [ep01 ep10 ep10 ep10]; %does the wave have HV?
CPDs = [CPDs HV];

%column correlation = P(C|class1)...P(C|class4)
CC.parents = [1];
CC.numVals = 2; %no correlation, correlation
CC.name = 'column correlation';
CC.probs = [ep01 ep01 ep01 ep10];
CPDs = [CPDs CC];

%number of objects = P(O|class1)....P(O|class4)
NO.parents = [1];
NO.numVals = 3; %1 2(for horizontal) 30(for dots moving up/down)
NO.name = 'number objects';
NO.probs = [ep010 ep100 ep100 ep001];
CPDs = [CPDs NO];

%% set the cpd for the bottom variable, WHAT A BITCH %%%%%%

%valid configs - 

OV.parents = [2 3 4 5 6];
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



