%this function returns the probability distribution
%P(V|rest of var assignments (given by curState) )
function newPs = resampleVar(CPDs, curState, V)

%get all parents and children of V
%pars = CPDs(V).parents;
children = getChildren(CPDs, V);

%start off with a vectoring containing P(V|paV)
newPs = observeEvidence(CPDs, curState,V);

%cycle through all values of V
for i=1:CPDs(V).numVals
   %cycle through all children
   for cc=1:length(children)
      c = children(cc);
      
      %get P(child = curState(c)|V=i)
      tempState = curState;
      tempState(V) = i;
      tempPs = observeEvidence(CPDs,tempState,c);
      %multiply P(child = curState(c)|V=i) by P(V=i|paV)
      newPs(i) = newPs(i)*tempPs(curState(c));
   
   end
    
end

%now, normalize
newPs = newPs./(sum(newPs));

end