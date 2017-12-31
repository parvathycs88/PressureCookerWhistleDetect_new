function [J,misclassified_set] = compute_perceptron_cost(w,X,y)
    X_times_w =  X*w;
    signum_vector = sign(X_times_w);
    misclassified_set = X(signum_vector ~= y,:);

    misclassified_X_times_w = misclassified_set*w;
    signum_misclassified = sign(misclassified_X_times_w);
    arg_of_cost_fcn = signum_misclassified.*misclassified_X_times_w;
    J = sum(arg_of_cost_fcn); % cost
end