function result=specialPopulation(popSize,distMatrix,n_cities)
    for i=1:n_cities
        distMatrix(i,i)=max(max(distMatrix))^3;
    end
    for i=1:popSize
        result(i,1:n_cities)=0;
        result(i,1)=ceil(rand*n_cities);
        for j=2:n_cities
            for k=1:n_cities
                if max(k==result(i,1:j))~=0
                    distArray(k)=distMatrix(1,1);
                else
                    distArray(k)=distMatrix(result(i,j-1),k);
                end
            end
            distArray=1./distArray;
            nextCitieAbility=ability(distArray,n_cities);
            nextCitie=result(i,j-1);
            while max(nextCitie==result(i,1:j))~=0
                nextCitie=roulette(nextCitieAbility);
            end
            result(i,j)=nextCitie;
        end
    end
end