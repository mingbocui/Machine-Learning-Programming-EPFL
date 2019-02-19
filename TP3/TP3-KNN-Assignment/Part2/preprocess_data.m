function [X, Y, rk] = preprocess_data(table_data, ratio, data_type)
%PREPROCESS_DATA Preprocess the data in the adult dataset
%
%   input -----------------------------------------------------------------
%
%       o table_data    : (M x N), a cell array containing mixed
%                         categorical and continuous values
%       o ratio : The pourcentage of M samples to extract 
%
%   output ----------------------------------------------------------------
%       o X : (N-1, M*ratio) Data extracted from the table where
%             categorical values are converted to integer values
%       o Y : (1, M*ratio) The label of the data to classify. Values are 1
%             or 2
%       o rk : (N-1 x 1) The range of values for continuous data (will be 0
%               if the data are categorical)

% Auxiliary Variables
rk = zeros(size(table_data,2),1);

% ADD CODE HERE: Convert features data to numerical values. If the data are 
% categorical first convert them to int values. If the data are continuous 
% store the range in rk.
% HINT: Type of feature data (continuous or categorical) is stored in
% data_type which is boolean cell array (true if continuous). Only select
% the samples based on idx array. Be careful with the input and output 
% dimensions.
[M, N] = size(table_data);
rand_num = floor(ratio * M);
X_prev = table_data(randperm(M, rand_num),:);

X_final = zeros(rand_num,N);
% X_final = [];
for i = 1:length(data_type)
    if (data_type{i}==1)
        X_final(:,i) = X_prev{:,i}; 
        rk(i,1) = max(X_final(:,i))-min(X_final(:,i));
%           X_final = [X_final,X_prev{:,i}];
    else
        X_final(:,i) = grp2idx(X_prev{:,i});
%         X_final = [X_final,grp2idx(X_prev{:,i})];
        rk(i,1) = 0;
    end
end

% for i = 1:size(table_data,2)
%     rk(i,1) = max(X_final(:,i))-min(X_final(:,i));
% end

X = X_final(:,1:N-1)';
Y = X_final(:,N)';



% END CODE
end

