function result=mutationSwap(subject,distanceMatrix,mutRate,n_cities)
    mutationRate=ceil(rand*mutRate*n_cities);
    for k=1:mutationRate
        subjectDist=routeSum(subject,distanceMatrix,n_cities);
        subjectAbility=ability(subjectDist,n_cities);
    	swapPoints=[1,1];
        while max(swapPoints)-min(swapPoints)<2
            for i=1:2
                swapPoints(i)=roulette(subjectAbility);
            end
        end
        result=subject;
        result(swapPoints(1))=subject(swapPoints(2));
        result(swapPoints(2))=subject(swapPoints(1));
        subject=result;
    end
end