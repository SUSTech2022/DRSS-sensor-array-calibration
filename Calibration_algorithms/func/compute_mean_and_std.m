function compute_mean_and_std(path, variable_name)
% 存储所有数据的数组
N=30;
num_data_points = 238;
all_data = zeros(num_data_points, N);

% 从.mat文件中加载数据并存储在all_data中
for i = 1:N
    filename = sprintf('%s\\g1_%d.mat', path, i);
    data = load(filename, variable_name);
    all_data(:, i) = data.(variable_name).x;
end

%% 可视化估计误差分布
% read in the true values
filename = sprintf('%s\\ground_truth.mat', path);
ground_truth = load(filename ).g.x_gt;

% 计算每个数据点的 RMSE 值
RMSE = zeros(num_data_points, N);
for i = 1:N
    estimation = all_data(:, i);  % 提取估计值
    
    % 计算 RMSE
    error = estimation - ground_truth;  % 与真实值相减得到误差
    RMSE(:, i) = sqrt(mean(error.^2, 2));  % 计算 RMSE 并存储到 RMSE 矩阵中
end

% 绘制箱线图
figure();
subplot(1,3,1);
boxplot(RMSE);
title('RMSE Boxplot (before)');
xlabel('Rounds');
ylabel('RMSE');


% 计算每个点的平均值和标准差
mean_values = mean(all_data, 2); 
std_values = std(all_data, [], 2);


%% 使用3σ法则剔除异常值
data_sigma = all_data;
for i = 1:num_data_points
    data = data_sigma(i, :);
    mean_val = mean_values(i);
    std_val = std_values(i);
    index = abs(data - mean_val) <= 3 * std_val;  % sigma
    data_sigma(i, ~index) = NaN;
end

% 重新计算每个点的平均值
mean_values_sigma = nanmean(data_sigma, 2); 

% 可视化剔除效果
% 计算每个数据点的 RMSE 值
RMSE = zeros(num_data_points, N);
for i = 1:N
    estimation = data_sigma(:, i);  % 提取估计值
    
    % 计算 RMSE
    error = estimation - ground_truth;  % 与真实值相减得到误差
    RMSE(:, i) = sqrt(mean(error.^2, 2));  % 计算 RMSE 并存储到 RMSE 矩阵中
end

% 绘制箱线图
subplot(1,3,2);
boxplot(RMSE);
title('RMSE Boxplot (sigma)');
xlabel('Rounds');
ylabel('RMSE');


%% 使用箱线图的四分位距（IQR）方法对每个数据点剔除离群值
data_IQR = all_data;
Q1 = prctile(data_IQR, 25, 2);
Q3 = prctile(data_IQR, 75, 2);
IQR = Q3 - Q1;
upper_threshold = Q3 + 1.5 * IQR;
lower_threshold = Q1 - 1.5 * IQR;

outlier_indices = find(data_IQR > upper_threshold | data_IQR < lower_threshold);

% remove outliers from data
data_IQR(outlier_indices) = NaN;

% 重新计算每个点的平均值
mean_values_IQR = nanmean(data_IQR, 2);  

% 保存结果到result.mat文件中
save(fullfile(path, 'result.mat'), 'mean_values', 'std_values', 'mean_values_sigma','mean_values_IQR');

% 可视化剔除效果
% 计算每个数据点的 RMSE 值
RMSE = zeros(num_data_points, N);
for i = 1:N
    estimation = data_IQR(:, i);  % 提取估计值
    
    % 计算 RMSE
    error = estimation - ground_truth;  % 与真实值相减得到误差
    RMSE(:, i) = sqrt(mean(error.^2, 2));  % 计算 RMSE 并存储到 RMSE 矩阵中
end

% 绘制箱线图
subplot(1,3,3);
boxplot(RMSE);
title('RMSE Boxplot (IQR)');
xlabel('Rounds');
ylabel('RMSE');


end




