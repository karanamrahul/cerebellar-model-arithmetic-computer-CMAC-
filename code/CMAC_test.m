function [ accuracy ] = CMAC_test( maptable, testingData, flag )
% Function to train CMAC given the maptable,testing data and flag.

% maptable - map generated using the gen_map function given inputs,
% numWeights, genFactor as inputs.
% testingData - The input data allocated for training
% flag - It denotes between discrete and continuous 

tic; % Starts measuring time

if isempty(maptable) || isempty(testingData)
    accuracy = NaN;
    return
end

% Created TestData using input vectors
% Checking with the testdata and testing data
inpt  = zeros(length(testingData),2);
for i=1:length(testingData)
    if testingData(i,1) > maptable{1}(end)
        inpt(i,1) = length(maptable{1});
    elseif testingData(i,1) < maptable{1}(1)
        inpt(i,1) = 1;
    else
        temp = (length(maptable{1})-1)*(testingData(i,1)-maptable{1}(1))/(maptable{1}(end)-maptable{1}(1)) + 1;
        inpt(i,1) = floor(temp);
        if (ceil(temp) ~= floor(temp)) && flag
            inpt(i,2) = ceil(temp);
        end
    end
end

% Computing the accuracy of the testdata
numer = 0;
denom = 0;
for i=1:length(inpt)
    if inpt(i,2) == 0
        outpt = sum(maptable{3}(find(maptable{2}(inpt(i,1),:))));
        numer = numer + abs(testingData(i,2)-outpt);
        denom = denom + testingData(i,2) + outpt;
    else
        d1 = norm(maptable{1}(inpt(i,1))-testingData(i,1));
        d2 = norm(maptable{2}(inpt(i,2))-testingData(i,1));
        outpt = (d2/(d1+d2))*sum(maptable{3}(find(maptable{2}(inpt(i,1),:))))...
               + (d1/(d1+d2))*sum(maptable{3}(find(maptable{2}(inpt(i,2),:))));
        numer = numer + abs(testingData(i,2)-outpt);
        denom = denom + testingData(i,2) + outpt;
    end
    Y(i) = outpt;
end
error = abs(numer/denom);
accuracy = 100 - error;

[X,I] = sort(testingData(:,1));
Y = Y(I);
plot(X,Y);
time=toc; %Measure the elasped time
end