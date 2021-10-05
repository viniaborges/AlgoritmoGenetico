function result=mutationDisplacement(subject,distanceMatrix,mutRate,n_cities)
    mutationRate=ceil(rand*mutRate*n_cities);
    for k=1:mutationRate
        subjectDist=routeSum(subject,distanceMatrix,n_cities);
        subjectAbility=ability(subjectDist,n_cities);
    	rotationPoints=[1,1];
        while max(rotationPoints)-min(rotationPoints)<3
            for i=1:2
                rotationPoints(i)=roulette(subjectAbility);
            end
            rotationPoints=sort(rotationPoints);
            rotationPoints(1)=rotationPoints(1)+1;
        end
        result=subject;
        difRotation=rotationPoints(2)-rotationPoints(1);
        for i=1:difRotation
            result(rotationPoints(1)+i)=subject(rotationPoints(2)-i+1);
        end
        subject=result;
    end
end