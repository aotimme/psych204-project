%this function gets the children of a var -
%assumes that children only come after the var
function children = getChildren(CPDs, V)

children = zeros(1,(length(CPDs) - V));
idx = 1;

for i = V+1:length(CPDs)
    if(any(CPDs(i).parents == V))
       children(idx) = i;
       idx = idx + 1;
    end
end

children = children(children ~= 0);
end