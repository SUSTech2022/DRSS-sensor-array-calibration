% plot a 3D SLAM graph
function plot_graph_with_cov(g, iteration, H)

% 判断参数个数
if nargin<2  
    iteration = -1;
end

% clf;
hold on;
plot3(nan, nan, nan, 'LineStyle','none','Marker','o', 'MarkerSize', 4,'MarkerEdgeColor','g','LineWidth',2);
% plot3(nan, nan, nan, 'Color','g');
plot3(nan, nan, nan, 'LineStyle','none','Marker','s', 'MarkerSize', 5,'MarkerEdgeColor','r','LineWidth',2);
plot3(nan, nan, nan, 'LineStyle','none','Marker','o','MarkerSize', 4,'MarkerEdgeColor','c','LineWidth',1);
plot3(nan, nan, nan,'Color','b', 'LineStyle','-','Marker','x', 'MarkerSize',6,'MarkerEdgeColor','b','LineWidth',1);

% legend('Mic. pos. est.','Sigma region of mic. pos. est.','Mic. pos. g. t.','Sound source est.', 'Sound source g. t.');
legend('Mic. pos. est.','Mic. pos. g. t.','Sound source est.', 'Sound source g. t.');


[p, l] = get_poses_landmarks(g);

if (length(l) > 0)
  landmarkIdxX = l+1;
  landmarkIdxY = l+2;
  landmarkIdxZ = l+3;
  plot3(g.x(landmarkIdxX), g.x(landmarkIdxY), g.x(landmarkIdxZ), 'LineStyle','none','Marker','o', 'MarkerSize', 5,'MarkerEdgeColor','g','LineWidth',2);
  plot3(g.x_gt(landmarkIdxX), g.x_gt(landmarkIdxY), g.x_gt(landmarkIdxZ), 'LineStyle','none','Marker','s', 'MarkerSize', 5,'MarkerEdgeColor','r','LineWidth',2);
end

if (length(p) > 0)
  pIdxX = p+1;
  pIdxY = p+2;
  pIdxZ = p+3;
  plot3(g.x(pIdxX), g.x(pIdxY), g.x(pIdxZ), 'LineStyle','none','Marker','o','MarkerSize', 4,'MarkerEdgeColor','c','LineWidth',1);
  plot3(g.x_gt(pIdxX), g.x_gt(pIdxY), g.x_gt(pIdxZ),'Color','b', 'LineStyle','-','Marker','x', 'MarkerSize',6,'MarkerEdgeColor','b','LineWidth',0.5);
end


grid on;
view(30,15);
hold on
% hold off;

gcf;
grid on; axis equal;
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
% legend('Sensor pos. est.','Sigma region of sensor pos. est.','Sensor pos. ground truth','Signal source est.', 'Signal source ground truth','Location','northeast');
% drawnow;

end
