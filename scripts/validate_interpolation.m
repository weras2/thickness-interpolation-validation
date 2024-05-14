load("data/GauriData.mat") % Load your data
methods = {'linear', 'natural', 'cubic', 'v4', 'nearest'}; % List of interpolation methods to compare
numMethods = length(methods);
numRuns = 100; % Number of runs for averaging

% Prepare to store statistics
meanErrors = zeros(numRuns, numMethods);
stdErrors = zeros(numRuns, numMethods);

for k = 1:numMethods
    method = methods{k};
    for i = 1:numRuns
        % Define the portion of data to use for interpolation
        portion = 0.8; % Using 80% of the data for interpolation
        numTrain = round(portion * length(x));

        % Generate random indices for training data
        indices = randperm(length(x));
        trainIndices = indices(1:numTrain);
        validIndices = indices(numTrain+1:end);

        % Extract training and validation data
        trainX = x(trainIndices);
        trainY = y(trainIndices);
        trainThick = thick(trainIndices);
        validX = x(validIndices);
        validY = y(validIndices);
        validThick = thick(validIndices);

        % Interpolate using training data
        interpolatedValues = griddata(trainX, trainY, trainThick, validX, validY, method);
    
        % Calculate the error
        errors = abs(interpolatedValues - validThick);
        meanErrors(i, k) = mean(errors);
        stdErrors(i, k) = std(errors);
    end
end

% Plotting the results as box plots
figure;
boxplot(meanErrors, 'Labels', methods);
title('Comparison of Interpolation Methods With Gauri Data');
xlabel('Interpolation Method');
ylabel('Mean Error');
