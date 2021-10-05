function result=populationControl(populationMatrix,populationSum,populationSize)
	for i=1:populationSize
    	[~,bestLoc]=min(populationSum);
        result(i,:,:)=populationMatrix(bestLoc,:,:);
        populationSum(bestLoc)=max(populationSum);
    end
end