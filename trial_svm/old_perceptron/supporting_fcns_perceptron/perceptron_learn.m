function [w,J,iter] = perceptron_learn(X,y,w_init,rho,max_iter,term_tolerance,visualise)
J = nan(max_iter,1);
w = nan(length(w_init),max_iter);
iter = 1;
latest_cost = 1e16;   % Not really used. Will be replaced soon within the loop
w(:,iter) = w_init;
while latest_cost > term_tolerance
    if iter >= max_iter
        break;
    end
    
    [latest_cost,misclassified_set] = compute_perceptron_cost(w(:,iter),X,y);
    J(iter) = latest_cost;
    w(:,iter+1) = w(:,iter) - rho*sum(sign(misclassified_set*w(:,iter)).*misclassified_set)';
    
    iter = iter + 1;
    
    if strcmp(visualise,'true')
        gscatter(X(:,1),X(:,2),y); hold on;
        X_plot = circshift(X,1,2);
        w_plot = circshift(w,1);
        plot_boundary(X_plot,w_plot); hold off;
        pause(1);
    end
end
end