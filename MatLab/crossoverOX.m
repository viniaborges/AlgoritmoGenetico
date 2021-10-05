function newPop=crossoverOX(parents,crossPoints,n_cities)
    
    %Realizando o crossover
    for i=1:2
        newPop(i,min(crossPoints):max(crossPoints))=parents(mod(i,2)+1,min(crossPoints):max(crossPoints));
    end
    
    %Corrigindo as duplicidades
    for i=1:2
        j=max(crossPoints)+1;
        if j>n_cities
            j=1;
        end
        k=j;
        while j~=min(crossPoints)
            %se o valor da posição k não está presente na sequencia de
            %crossover, então a posição j será preenchida pelo conteúdo de j.
            if max(parents(i,k)==newPop(i,:))==0
                newPop(i,j)=parents(i,k);
                j=j+1;
                k=k+1;
            else
                k=k+1;
            end
            if j>n_cities
                j=1;
            end
            if k>n_cities
                k=1;
            end
        end
    end
end