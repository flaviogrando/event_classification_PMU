
function[X_random,Y_random,Z_random] = embaralha_dados(X,Y,Z)

new_indexes = randperm(length(X(:,1)));
X_random = X(new_indexes, :);
Y_random = Y(new_indexes, :);
Z_random = Z(new_indexes, :);