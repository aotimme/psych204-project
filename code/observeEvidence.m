%this function assumes ALL other states of parent vars are observed
function Ps = observeEvidence(CPDs, curState, V)

pos = 0;
stepSize = CPDs(V).numVals;

%iterate through all parents of V
for pi = 1:length(CPDs(V).parents)
   par = CPDs(V).parents(pi);
   parNumVals = CPDs(par).numVals;
   
   pos = pos + stepSize*(curState(par) -1);
   stepSize = stepSize*parNumVals;
    
end

Ps = CPDs(V).probs((pos+1):(pos+CPDs(V).numVals));

end