function result=routeSum(route,distanceMatrix,n_cities)
    for i=1:n_cities-1
        result(i)=distanceMatrix(route(i),route(i+1));
    end
    result(n_cities)=distanceMatrix(route(n_cities),route(1));
end