%Problema do Caixeiro Viajante (Simétrico)
%desenvolvido utilizando Algoritmos Genéticos
%por Vinícius Azevedo Borges, 2015

clc
clear all

%Lista de arquivos a trabalhar
fileList={'burma14.tsp','att48.tsp','eil51.tsp','berlin52.tsp','st70.tsp',...
          'pr76.tsp','eil76.tsp','rat99.tsp','rd100.tsp','kroA100.tsp',...
          'kroB100.tsp','kroC100.tsp','kroD100.tsp','kroE100.tsp',...
          'eil101.tsp','pr107.tsp','pr124.tsp','bier127.tsp','ch130.tsp',...
          'pr136.tsp','pr144.tsp','ch150.tsp','pr152.tsp','kroA150.tsp',...
          'kroB150.tsp','rat195.tsp','kroA200.tsp','kroB200.tsp',...
          'ts225.tsp','pr226.tsp','gil262.tsp','pr264.tsp','pr299.tsp',...
          'pr439.tsp','att532.tsp','ali535.tsp'};
[~,fileListQt]=size(fileList);

for autoIfile=1:1
    %Carregar arquivo de dados
    filename='tspdata/';
    filename=strcat(filename,char(fileList(autoIfile)));
    [n_cities,positionMatrix,distanceMatrix]=file(filename);
    
    %Arquivos a serem salvos
    saveFilename1='resultados/';
    saveFilename1=strcat(saveFilename1,char(fileList(autoIfile)));
    saveFilename1=strcat(saveFilename1,char('-bestSolution.txt'));
    saveFilename2='resultados/';
    saveFilename2=strcat(saveFilename2,char(fileList(autoIfile)));
    for autoIxMethod=1:1
        for autoIpopulationSize=1:1
            for autoIpersistence=1:1
                for autoIxSizeLimit=5:5
                    for autoI=1:1
                        %Definindo parâmetros iniciais
                        populationSize=10*autoIpopulationSize;
                        populationCtrl=2*populationSize;
                        persistence=1*autoIpersistence;
                        bestSelections=ceil(populationSize*0.05);
                        newRandPopulation=ceil(populationSize*0.05);
                        newSpecialPopulation=ceil(populationSize*0.01);
                        crossoverSizeLimit=ceil(n_cities/(autoIxSizeLimit));
                        crossoverMethod=autoIxMethod; % 0 = Aleatório; 1 = PMX; 2 = OX
                        mutAbility=[2,2,2,2]; %Proporção das mutações (Swap, Inversão, Rotação, Deslocamento)
                        mutRate=0.5; %Taxa de mutação geral
                        mutRateSwap=0.2; %Taxa de mutação de Swap
                        mutRateInversion=0.3; %Taxa de mutação de Inversão
                        mutRateRotation=0.05; %Taxa de mutação de Rotação
                        mutRateDisplacement=0.05; %Taxa de mutação de Deslocamento
                        
                        %Criando a 1ª geração aleatória
                        populationMatrix=randomGeneration(populationSize-newSpecialPopulation,n_cities);
                        
                        %Criando a 1ª população especial
                        populationMatrix(populationSize-newSpecialPopulation+1:populationSize,:)=specialPopulation(newSpecialPopulation,distanceMatrix,n_cities);
                        
                        %Manipulando população
                        ipersistence=0;
                        iteraction=0;
                        processingTime=cputime;
                        popSize=populationSize;
                        mutAbility=ability(mutAbility,4);
                        
                        %Somando rotas dos indivíduos da população
                        for i=1:populationSize
                        	populationMatrix(i,:,2)=routeSum(populationMatrix(i,:),distanceMatrix,n_cities);
                            populationSum(i)=sum(populationMatrix(i,:,2));
                        end
                        
                        while ipersistence<persistence
                            iteraction=iteraction+1;
                            iNewPopulation=0;
                            
                            %Controle populacional (Elitismo)
                            if popSize>populationCtrl
                                TMPpopMatrix=populationControl(populationMatrix,populationSum,populationSize);
                                popSize=populationSize;
                                clearvars populationMatrix populationSum
                                populationMatrix=TMPpopMatrix;
                                clearvars TMPpopMatrix
                                popSize=populationSize;
                                for i=1:popSize
                                    populationMatrix(i,:,2)=routeSum(populationMatrix(i,:),distanceMatrix,n_cities);
                                    populationSum(i)=sum(populationMatrix(i,:,2));
                                end
                            end
                            
                            %Aproveitando melhores indivíduos na geração seguinte (Elitismo)
                            TMPselection=populationSum;
                            for i=1:bestSelections
                                iNewPopulation=iNewPopulation+1;
                                [~,TMPbestLoc]=min(TMPselection);
                                newPopulation(iNewPopulation,:)=populationMatrix(TMPbestLoc,:,1);
                                TMPselection(TMPbestLoc)=max(TMPselection);
                            end
                            clearvars TMPselection TMPbestLoc
                            
                            %"Adotando" novos filhos aleatórios
                            for i=1:newRandPopulation
                                iNewPopulation=iNewPopulation+1;
                                newPopulation(iNewPopulation,:)=randperm(n_cities);
                            end
                            
                            %"Adotando" novos filhos especiais
                            iNewPopulation=iNewPopulation+newSpecialPopulation;
                            newPopulation(iNewPopulation-newSpecialPopulation+1:iNewPopulation,:)=specialPopulation(newSpecialPopulation,distanceMatrix,n_cities);
                            
                            while iNewPopulation<popSize
                                mutReference=iNewPopulation+1;
                                
                                %Testando aptidão dos indivíduos da população
                                TMPpopAbility=100./populationSum;
                                populationAbility=ability(TMPpopAbility,popSize);
                                clearvars TMPpopAbility
                                
                                %Selecionando pais por aptidão
                                for i=1:2
                                    TMPselection(i)=roulette(populationAbility);
                                end
                                
                                %Realizando crossover com pontos de corte e método de correção de duplicidade selecionados na roleta
                                [TMPnewPop,TMPcrossQt]=crossover(populationMatrix(TMPselection,:,:),crossoverSizeLimit,n_cities,crossoverMethod);
                                for i=1:TMPcrossQt
                                    iNewPopulation=iNewPopulation+1;
                                    newPopulation(iNewPopulation,:)=TMPnewPop(i,:);
                                end
                                clearvars TMPcrossPoints TMPcrossQt TMPnewPop TMPselection
                                
                                %Realizando mutações aleatórias segundo a taxa de mutação e roleta
                                for i=mutReference:iNewPopulation
                                    while rand<mutRate
                                        TMPmutMethod=roulette(mutAbility);
                                        switch TMPmutMethod
                                            case 1 %Swap
                                                iNewPopulation=iNewPopulation+1;
                                                newPopulation(iNewPopulation,:)=mutationSwap(newPopulation(i,:),distanceMatrix,mutRateSwap,n_cities);
                                            case 2 %Inversão
                                                iNewPopulation=iNewPopulation+1;
                                                newPopulation(iNewPopulation,:)=mutationInversion(newPopulation(i,:),distanceMatrix,mutRateInversion,n_cities);
                                            case 3 %Rotação
                                                iNewPopulation=iNewPopulation+1;
                                                newPopulation(iNewPopulation,:)=mutationRotation(newPopulation(i,:),distanceMatrix,mutRateRotation,n_cities);
                                            case 4 %Deslocamento
                                                iNewPopulation=iNewPopulation+1;
                                                newPopulation(iNewPopulation,:)=mutationRotation(newPopulation(i,:),distanceMatrix,mutRateDisplacement,n_cities);
                                        end
                                    end
                                end
                                clearvars TMPmutMethod
                            end
                            popSize=iNewPopulation;
                            clearvars populationMatrix
                            populationMatrix=newPopulation;
                            clearvars newPopulation
                            
                            %Somando rotas dos indivíduos da população
                            for i=1:popSize
                                populationMatrix(i,:,2)=routeSum(populationMatrix(i,:),distanceMatrix,n_cities);
                                populationSum(i)=sum(populationMatrix(i,:,2));
                            end
                            
                            %Testando persistência
                            [~,TMPminLoc]=min(populationSum);
                            if TMPminLoc<=bestSelections
                                ipersistence=ipersistence+1;
                            else
                                ipersistence=0;
                            end
                            
                            %Está executando?
                            if mod(iteraction,1)==0
                                iteraction
                                ipersistence
                                popSize;
                                [~,TMPminLoc]=min(populationSum);
                                minRoute=populationSum(TMPminLoc);
                            end
                            clearvars TMPminLoc
                        end
                        
                        [~,minLoc]=min(populationSum);
                        bestSolution=populationMatrix(minLoc,:,1);
                        for i=1:n_cities
                            bestSolution(2,i)=positionMatrix(bestSolution(1,i),2);
                            bestSolution(3,i)=positionMatrix(bestSolution(1,i),3);
                        end
                        bestSolution(2,n_cities+1)=positionMatrix(bestSolution(1,1),2);
                        bestSolution(3,n_cities+1)=positionMatrix(bestSolution(1,1),3);
                        minRoute=populationSum(minLoc);
                        processingTime=cputime-processingTime;
                        clearvars minLoc
                        
                        bestSolution
                        processingTime
                        iteraction
                        minRoute
                        plot(bestSolution(2,:),bestSolution(3,:))
                        hold;
                        plot(positionMatrix(:,2),positionMatrix(:,3),'o','MarkerSize',3,'MarkerEdgeColor','k','MarkerFaceColor','r');
                        %fid=fopen(saveFilename1,'a');
                        %fprintf(fid,'%s\n','#############################################')
                        %fprintf(fid,'%s','Método de Crossover: ');
                        %switch crossoverMethod
                        %    case 0
                        %        fprintf(fid,'%s\n','Aleatório');
                        %    case 1
                        %        fprintf(fid,'%s\n','PMX');
                        %    case 2
                        %        fprintf(fid,'%s\n','OX');
                        %end
                        %fprintf(fid,'%s','Tamanho da População: ');
                        %fprintf(fid,'%i\n',populationSize);
                        %fprintf(fid,'%s','Persistência: ');
                        %fprintf(fid,'%i\n',persistence);
                        %fprintf(fid,'%s','Distância da Rota: ');
                        %fprintf(fid,'%i\n',minRoute);
                        %fprintf(fid,'%s','Tempo de Processamento: ');
                        %fprintf(fid,'%i\n',processingTime);
                        %fprintf(fid,'%s','Iterações: ');
                        %fprintf(fid,'%i\n',iteraction);
                        %fprintf(fid,'%i\t%f\t%f\n\n',bestSolution);
                        %fclose(fid);
                        %fid=fopen(saveFilename2,'a');
                        %fprintf(fid,'%f\t%f\t%i\n',minRoute,processingTime,iteraction);
                        %fclose(fid);
                        %clearvars ans populationMatrix populationSum bestSolution minRoute
                        %fileList(autoIfile)
                        %autoIxMethod
                        %autoIpopulationSize
                        %autoIpersistence
                        %autoIxSizeLimit
                        %autoI
                    end
                end
            end
        end
    end
    clearvars distanceMatrix positionMatrix
end