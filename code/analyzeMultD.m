%This function analyzes percept that has multiple Ds - hahah

numS = 0;
lengthS = 0;
lastSwitchPos = 1;
switches = [];

%multidimensional stuff
sumPercepts = zeros(4,numGibbsIters);
for i=1:4
   sumPercepts(i,:) = sum(percepts(1:numTopLayer,:) == i,1); 
end

%the cutoff for saying something is an 'overall' perceptual switch
% - the number of top layer units that have to be on for it to be percieved
% as 'on'
switchCutoff = floor(numTopLayer*.75);

%initalize counter - first max is simply the percept that has the most
[~,curMax] = max(sumPercepts(:,1));

for i=1:(numGibbsIters)
    
    [maxV,maxI] = max(sumPercepts(:,i));
    
    if(maxI ~= curMax && (maxV >= switchCutoff))
       
        curMax = maxI;
        
        lengthThisSwitch = i-lastSwitchPos;
        numS = numS + 1;
        lastSwitchPos = i;
        switches = [switches lengthThisSwitch];
        
    end
end

%plot switches prettily
sumS = zeros(1,floor(numGibbsIters^.5));
for i=1:floor(numGibbsIters^.5)
     sumS(i) = sum(switches==i);
end

sumS = sumS./(sum(sumS));

plot(sumS(1:100));