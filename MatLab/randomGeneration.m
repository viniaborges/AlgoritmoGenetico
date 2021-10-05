function populationMatrix=randomGeneration(populationSize,n_cities)
    for i=1:populationSize
        populationMatrix(i,:)=randperm(n_cities);
    end
end