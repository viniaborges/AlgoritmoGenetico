function result=roulette(abilityArray)
    TMPselection=rand;
    result=0;
    TMPval=0;
    while TMPval<=TMPselection
        result=result+1;
        TMPval=abilityArray(result);
    end
end