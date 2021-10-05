function [newPop,crossQt]=crossover(parents,crosSizeLimit,n_cities,crossMethod)
    xMethod=crossMethod;
    
    %Selecionando pontos de corte pela roleta
    for i=1:2
        xPointsAbility(i,:)=ability(parents(i,:,2),n_cities);
        crossPoints(i)=roulette(xPointsAbility(i,:));
    end
    while min(crossPoints)+crosSizeLimit>=max(crossPoints) || max(crossPoints)-min(crossPoints)>n_cities-crosSizeLimit
        for i=1:2
            crossPoints(i)=roulette(xPointsAbility(i,:));
        end
    end
    crossPoints=sort(crossPoints);
    crossPoints(1)=crossPoints(1)+1;
    
    %Crossover de um ponto (quatro novos filhos)
    crossQt=0;
	for i=1:2
        crossQt=crossQt+2;
        TMPcrossPoints=[crossPoints(i),n_cities];
        if crossMethod==0
            xMethod=ceil(rand*2);
        end
        switch xMethod
        	case 1 %PMX
            	newPop(crossQt-1:crossQt,:)=crossoverPMX(parents(:,:,1),TMPcrossPoints,n_cities);
            case 2 %OX
            	newPop(crossQt-1:crossQt,:)=crossoverOX(parents(:,:,1),TMPcrossPoints,n_cities);
        end
    end
    
    %Crossover de dois pontos (dois novos filhos)
	crossQt=crossQt+2;
	if crossMethod==0
    	xMethod=ceil(rand*2);
	end
    switch xMethod
    	case 1 %PMX
        	newPop(crossQt-1:crossQt,:)=crossoverPMX(parents(:,:,1),crossPoints,n_cities);
        case 2 %OX
        	newPop(crossQt-1:crossQt,:)=crossoverOX(parents(:,:,1),crossPoints,n_cities);
    end
    
%    %Testando validade dos novos filhos
%    TMPnewPop=newPop;
%    TMPcrossQt=crossQt;
%    crossQt=0;
%	clearvars newPop
%    newPop(1,n_cities+1)=0;
%    for i=1:TMPcrossQt
%        validityTest=validity(TMPnewPop(1,:),n_cities);
%        if validityTest==1
%            crossQt=crossQt+1;
%            newPop(crossQt,:)=TMPnewPop(i,:);
%        end
%    end
end