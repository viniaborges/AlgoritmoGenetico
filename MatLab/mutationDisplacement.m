function result=mutationDisplacement(subject,distanceMatrix,mutRate,n_cities)
    mutationRate=max(ceil(rand*mutRate*n_cities),3);
    subjectDist=routeSum(subject,distanceMatrix,n_cities);
    subjectAbility=ability(subjectDist,n_cities);
	dispPoints(1:mutationRate-1)=1;
    dispPoints(mutationRate)=n_cities;
    dupTest=1;
    while dupTest==1
    	for i=2:mutationRate-1
        	dispPoints(i)=roulette(subjectAbility);
        end
        dispPoints=sort(dispPoints);
        dupTest=0;
        for i=1:mutationRate
            for j=i+1:mutationRate
                if dispPoints(i)==dispPoints(j);
                    dupTest=1;
                end
            end
        end
    end
    newSeq=randPerm(mutationRate-1);
    if newSeq(1)==1
        result=subject(dispPoints(newSeq(1)):dispPoints(newSeq(1)+1));
    else
        result=subject(dispPoints(newSeq(1))+1:dispPoints(newSeq(1)+1));
    end
    for i=2:mutationRate-1
        if newSeq(i)==1
            result=cat(2,result,subject(dispPoints(newSeq(i)):dispPoints(newSeq(i)+1)));
        else
            result=cat(2,result,subject(dispPoints(newSeq(i))+1:dispPoints(newSeq(i)+1)));
        end
    end
end