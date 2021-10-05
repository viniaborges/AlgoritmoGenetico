function [n_cities,positionMatrix,distanceMatrix]=file(filename)
    %Carregando arquivos *.txt para matriz de valores de distâncias
    file=fopen(filename);
    positionMatrix=fscanf(file,'%f',[3,Inf]);
    positionMatrix=positionMatrix';
    [n_cities,~]=size(positionMatrix); %número de cidades
    fclose(file);
    %Gerando matriz de distâncias
    for i=1:n_cities
        for j=1:n_cities
            x1=positionMatrix(i,2);
            x2=positionMatrix(j,2);
            y1=positionMatrix(i,3);
            y2=positionMatrix(j,3);
            distanceMatrix(i,j)=sqrt((x2-x1)^2+(y2-y1)^2);
        end
    end
end