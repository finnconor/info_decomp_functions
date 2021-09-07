% pTable should be a 2D table of the form:
% [s1 s2 s3 ... t p(s1,...t); % one s1,...,t combination
%  s1 s2 s3 ... t p(s1,...t); % another s1,...,t combination
%  s1 s2 s3 ... t p(s1,...t)]
% 
% All p's should add to 1

function redAsMinIComponent(pTable)

	numSources = size(pTable,2)-2;
	if (numSources <= 0)
		error('Not enough sources\n');
	end
	
	if (numSources > 2)
		error('Cannot handle > 2 sources');
	end
	
	pColumn = size(pTable,2);
	tColumn = size(pTable,2) - 1;
	if (abs(sum(pTable(:, pColumn)) - 1) > 0.00000000001)
		errorStr = sprintf('ps do not sum to 1 (%f)', sum(pTable(:,pColumn)));
		error(errorStr);
	end

	% Print headers:
	for s = 1 : numSources
		fprintf('s%d\t', s);
	end
	fprintf('t\tp\t');
	for s = 1 : numSources
		fprintf('p(s%d)\t', s);
	end
	fprintf('p(t)\t');
	for s = 1 : numSources
		fprintf('p(s%d|t)\t', s);
	end
	fprintf('p(S)\tp(S,t)\t');
	for s = 1 : numSources
		fprintf('i+(s%d)\ti-(s%d)\t', s, s);
	end
	fprintf('r+\t');
	for s = 1 : numSources
		fprintf('u+(s%d)\t', s);
	end
	fprintf('rem+\t');
	fprintf('r-\t');
	for s = 1 : numSources
		fprintf('u-(s%d)\t', s);
	end
	fprintf('rem-\t');
	fprintf('\n');
	rowsInPTable = size(pTable,1);
	for r = 1 : rowsInPTable
		% For each row, which is a unique sample configuration
		posInfo = zeros(1, numSources);
		negInfo = zeros(1, numSources);
		for s = 1 : numSources
			sourceVal = pTable(r,s);
			fprintf('%d\t', sourceVal);
		end
		targetVal = pTable(r,tColumn);
		fprintf('%d\t', targetVal);
		pTarget = sum(pTable(:,pColumn) .* (pTable(:,tColumn)==targetVal));
		fprintf('%.3f\t', pTable(r,pColumn));
		% Print pSource's
		pSources = zeros(1,numSources);
		iPosS = zeros(1,numSources);
		for s = 1 : numSources
			sourceVal = pTable(r,s);
			pSource = sum(pTable(:,pColumn) .* (pTable(:,s)==sourceVal));
			pSources(s) = pSource;
			iPosS(s) = - log2 (pSource);
			fprintf('%.3f\t', pSource);
		end
		fprintf('%.3f\t', pTarget);
		% Print pSourceGivenTarget's
		pSourceGivenTargets = zeros(1, numSources);
		iNegS = zeros(1,numSources);
		for s = 1 : numSources
			sourceVal = pTable(r,s);
			pSourceAndTarget = sum(pTable(:,pColumn) .* (pTable(:,s)==sourceVal).*(pTable(:,tColumn)==targetVal));
			% fprintf('%.3f\t', pSourceAndTarget);
			pSourceGivenTarget = pSourceAndTarget ./ pTarget;
			pSourcesGivenTarget(s) = pSourceGivenTarget;
			iNegS(s) = -log2 (pSourceGivenTarget);
			fprintf('%.3f\t', pSourceGivenTarget);
		end
		% Total information:
		pSourcesJoint = sum((sum(pTable(:,1:numSources) == repmat(pTable(r,1:numSources), rowsInPTable, 1), 2) == numSources).*pTable(:,pColumn));
		pSourcesJointAndTarget = sum((sum(pTable(:,1:(numSources+1)) == repmat(pTable(r,1:(numSources+1)), rowsInPTable, 1), 2) == (numSources+1)).*pTable(:,pColumn));
		pSourcesJointGivenTarget = pSourcesJointAndTarget ./ pTarget;
		totalIPos = -log2(pSourcesJoint);
		totalINeg = -log2(pSourcesJointGivenTarget);
		fprintf('%.3f\t%.3f\t', pSourcesJoint, pSourcesJointAndTarget);
		% Print i+ and i- for each source
		for s = 1 : numSources
			fprintf('%.3f\t%.3f\t', iPosS(s), iNegS(s));
		end
		% Now do positive components
		rPos = min(iPosS);
		fprintf('%.3f\t', rPos);
		uPoss = iPosS - rPos;
		for s = 1 : numSources
			fprintf('%.3f\t', uPoss(s))
		end
		% Just write the total higher order synegy terms:
		% higherOrderPos = totalIPos - max(iPosS); This isn't right
		% For 2 only!
		higherOrderPos = totalIPos - iPosS(1) - uPoss(2);
		fprintf('%.3f\t', higherOrderPos);
		% Now do negative components
		rNeg = min(iNegS);
		fprintf('%.3f\t', rNeg);
		uNegs = iNegS - rNeg;
		for s = 1 : numSources
			fprintf('%.3f\t', uNegs(s))
		end
		% Just write the total higher order synegy terms:
		% higherOrderNeg = totalINeg - max(iNegS); This isn't right
		% For 2 only!
		higherOrderNeg = totalINeg - iNegS(1) - uNegs(2);
		fprintf('%.3f\n', higherOrderNeg);
	end
end

