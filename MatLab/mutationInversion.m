function result=mutationInversion(subject,distanceMatrix,mutRate,n_cities)
    mutationRate=ceil(rand*mutRate*n_cities);
    for k=1:mutationRate
        subjectDist=routeSum(subject,distanceMatrix,n_cities);
        subjectAbility=ability(subjectDist,n_cities);
        inversionPoint=roulette(subjectAbility);
        result=subject;
        if inversionPoint<n_cities
            result(inversionPoint)=subject(inversionPoint+1);
            result(inversionPoint+1)=subject(inversionPoint);
        else
            result(n_cities)=subject(1);
            result(1)=subject(n_cities);
        end
        subject=result;
    end
end