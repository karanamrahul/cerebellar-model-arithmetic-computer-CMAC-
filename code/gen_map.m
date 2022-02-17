function [ map_table ] = gen_map( inputs, numWeights, genFactor )
%  This function will create a association matrix
%  inputs - is the input vector
%  numWeights - It denotes the number of weights to be used in CMAC
%  genFactor denotes the number of cells associated with the input vector.

% Checking if the input array is empty or the generalising factor
% is greater than the num of weights.
if (genFactor > numWeights) || (genFactor < 1) || (isempty(inputs))
     map_table = [];
     disp("[WARNING]: Please input correct number of weights and generalising factor")
    return
end

%  Creating the input vector based upon the input dimensions
X = linspace(min(inputs),max(inputs),numWeights-genFactor+1)';

% Creating the mapping table
mapping_table = zeros(length(X),numWeights);
for i=1:length(X)
    mapping_table(i,i:genFactor+i-1) = 1;
end

% Creating weight array ( Initial Weight is set to 1)
Weights = ones(numWeights,1);

% Creating a map using the cell data array
map_table = cell(3,1);
map_table{1} = X;
map_table{2} = mapping_table;
map_table{3} = Weights;
map_table{4} = genFactor;

end