%compute lengths for switching percepts
numS = 0;
lengthS = 0;
lastSwitchPos = 1;
switches = [];

for i=1:(numGibbsIters-1)
    if(percepts(1,i) ~= percepts(1,i+1))
       
        lengthThisSwitch = i+1-lastSwitchPos;
        numS = numS + 1;
        lastSwitchPos = i+1;
        switches = [switches lengthThisSwitch];
        
    end
end

%plot switches prettily
sumS = zeros(1,floor(numGibbsIters^.5) -1);
for i=2:floor(numGibbsIters^.5)
     sumS(i-1) = sum(switches==i);
end

plot(sumS(1:75));