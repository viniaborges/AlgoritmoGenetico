function result=validity(sequence,n_cities)
    result=1;
    for i=1:n_cities
        if max(sequence(i)==sequence(i+1:n_cities))~=0
            result=0;
        end
    end
    if sequence(1)~=sequence(n_cities+1)
        result=0;
    end
end