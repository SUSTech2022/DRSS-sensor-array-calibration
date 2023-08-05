function calculate_RMSE_and_plot_box(data,ground_truth)

% 计算每个数据点的 RMSE 值
num_data_points = size(data,1);
N = size(data,2);
RMSE = zeros(num_data_points, N);
for i = 1:N
    estimation = data(:, i);  % 提取估计值
    error = estimation - ground_truth;  % 与真实值相减得到误差
    RMSE(:, i) = sqrt(mean(error.^2, 2));  % 计算 RMSE 并存储到 RMSE 矩阵中
end

% 绘制箱线图
boxplot(RMSE);
xlabel('Rounds');
ylabel('RMSE');

end