function plot_boundary(X,w)

hold on
max_X1 = max(X(:,2))+1;
min_X1 = min(X(:,2))-1;
%     max_X2 = max(X(:,3));
%     min_X2 = min(X(:,3));
% modify this:

y1 = -(w(1) + (w(2) * min(X(:,2))))/w(3);
% modify this:
y2 = -(w(1) + (w(2) * max(X(:,2))))/w(3);


plot([min_X1,max_X1],[y1,y2],'b-o','linewidth',3,'MarkerFaceColor','r','MarkerEdgeColor','r');
xlabel('x1','FontSize',15);
ylabel('x2','FontSize',15);
title('Plotting the dataset with decision boundary');
xlim([min(X(:,2)) max(X(:,2))]);
ylim([min(X(:,3)) max(X(:,3))]);
box on;

%     saveas(gcf,'Datapoints Visualized with decision boundary.png');
%END OF FUNCTION