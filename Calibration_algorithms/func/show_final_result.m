
clear;
clc;
%% 计算平均值和标准差并保存
% compute_mean_and_std('D:\SUSTech\RSS\Algorithms\DRSS-sensor-array-calibration-main\DRSS-sensor-array-calibration-main\Calibration_algorithms_NEW\result\', 'g')

%% 手动将result.mat中的平均值保存到Real_tra_03_est.mat文件中

%% 画图，计算RMSE
filename = './data/Real_tra_03_est.mat';
load(filename,'g');
figure
plot_graph_with_cov(g)
view(-36, 15);
RMSE = cal_RMSE(g);
fprintf('RMSE：');
disp(['source:',num2str(RMSE(1)),'  sensor:',num2str(RMSE(2)),'  PLE:',num2str(RMSE(3))]);


% PLE平均值
gamma = [];
sum = 0;
for i=2:g.M  
    sum = sum+g.x(4*i);
    gamma = [gamma g.x(4*i)];
end
 
disp(['mean_PLE =' ,num2str(sum/(g.M-1))]);