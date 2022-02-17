function [ map, iterator, finalError, time ] = CMAC_train( maptable, trainingData, Error, flag )
% Function to train CMAC given the maptable,training data , Error and the flag.

% maptable - map generated using the gen_map function given inputs,
% numWeights, genFactor as inputs.
% trainingData - The input data allocated for training
% Error - denotes the acceptable error with regards to training data
% flag - It denotes between discrete and continuous 


tic; % To start the timer to measure the training process
% Created a map from the CMAC maptable
map = maptable;  
if isempty(map) || isempty(trainingData) || isempty(Error)
    return  % Return empty if there is no map or training data
end

% Created InputData using input vectors
% Checking with the inputdata and training data
inputData  = zeros(length(trainingData),2);
for i=1:length(trainingData)
    if trainingData(i,1) > map{1}(end)
        inputData(i,1) = length(map{1});
    elseif trainingData(i,1) < map{1}(1)
        inputData(i,1) = 1;
    else
        temp = (length(map{1})-1)*(trainingData(i,1)-map{1}(1))/(map{1}(end)-map{1}(1)) + 1;
        inputData(i,1) = floor(temp);
        if (ceil(temp) ~= floor(temp)) && flag
            inputData(i,2) = ceil(temp);
        end
    end
end


% Now we tend to iterate over each output and adjusting the weights
% accordingly till the end of iterations.
lr = 0.025; % learning rate
error = Inf; % Choosing +ve inf so the error will never go to a higher value
iterator = 0;
count = 0;
while (error > Error) && (2*count <= iterator)
    old_err = error;
    iterator = iterator + 1;
    
    % Evaluate output for given input and adjust the 
    % weights of the map.
      for i=1:length(inputData)
        if inputData(i,2) == 0
            output = sum(map{3}(find(map{2}(inputData(i,1),:))));
            error = lr*(trainingData(i,2)-output)/map{4};
            map{3}(find(map{2}(inputData(i,1),:))) = map{3}(find(map{2}(inputData(i,1),:))) + error;
        else
            d1 = norm(map{1}(inputData(i,1))-trainingData(i,1));
            d2 = norm(map{1}(inputData(i,2))-trainingData(i,1));
            output = (d2/(d1+d2))*sum(map{3}(find(map{2}(inputData(i,1),:))))...
                    + (d1/(d1+d2))*sum(map{3}(find(map{2}(inputData(i,2),:))));
            error = lr*(trainingData(i,2)-output)/map{4};
            map{3}(find(map{2}(inputData(i,1),:))) = map{3}(find(map{2}(inputData(i,1),:)))...
                                                    + (d2/(d1+d2))*error;
            map{3}(find(map{2}(inputData(i,2),:))) = map{3}(find(map{2}(inputData(i,2),:)))...
                                                    + (d1/(d1+d2))*error;            
         end
      end

    % Computing the final error from the given training data 
    % and input data.
    numer = 0;
    denom = 0;
    for i=1:length(inputData)
        if inputData(i,2) == 0
            output = sum(map{3}(find(map{2}(inputData(i,1),:))));
            numer = numer + abs(trainingData(i,2)-output);
            denom = denom + trainingData(i,2) + output;
        else
            d1 = norm(map{1}(inputData(i,1))-trainingData(i,1));
            d2 = norm(map{1}(inputData(i,2))-trainingData(i,1));
            output = (d2/(d1+d2))*sum(map{3}(find(map{2}(inputData(i,1),:))))...
                   + (d1/(d1+d2))*sum(map{3}(find(map{2}(inputData(i,2),:))));
            numer = numer + abs(trainingData(i,2)-output);
            denom = denom + trainingData(i,2) + output;
        end
    end
    error = abs(numer/denom);
    % If the absolute value of the difference is smaller the counter is
    % updated.
    if abs(old_err - error) < 0.00001
        count = count + 1;
    else
        count = 0;
    end
end

iterator = iterator - count;

% Compute the Final Error
numer = 0;
denom = 0;
for i=1:length(inputData)
    if inputData(i,2) == 0
        Y(i) = sum(map{3}(find(map{2}(inputData(i,1),:))));
        numer = numer + abs(trainingData(i,2)-Y(i));
        denom = denom + trainingData(i,2) + Y(i);
    else
        d1 = norm(map{1}(inputData(i,1))-trainingData(i,1));
        d2 = norm(map{1}(inputData(i,2))-trainingData(i,1));
        Y(i) = (d2/(d1+d2))*sum(map{3}(find(map{2}(inputData(i,1),:))))...
               + (d1/(d1+d2))*sum(map{3}(find(map{2}(inputData(i,2),:))));
        numer = numer + abs(trainingData(i,2)-Y(i));
        denom = denom + trainingData(i,2) + Y(i);
    end
end
% The Final Error is calculated and the training data is sorted.
finalError = abs(numer/denom);
[X,I] = sort(trainingData(:,1));
Y = Y(I);
time = toc; % Measure the elasped time

end