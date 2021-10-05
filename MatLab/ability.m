function result=ability(routes,populationSize)
    routes=routes.^10;
    TMPtotal=sum(routes);
    for i=1:populationSize
        TMPresult(i)=routes(i)/TMPtotal;
        result(i)=sum(TMPresult(1:i));
    end
end