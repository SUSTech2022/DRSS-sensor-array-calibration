
N = 8; % 画N*10组

x=10:10:N*10;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止

source_mean = [0.091912,0.089379,0.089529,0.089015,0.08704,0.091403,0.089944,0.091386]; % source_mean数据RMSE值
source_mean = source_mean(1:N);
source_sigma=[0.095022,0.091084,0.08928,0.088766,0.085879,0.088886,0.087997,0.088812]; % source_sigma数据RMSE值
source_sigma=source_sigma(1:N);
source_IQR=[0.09241,0.088773,0.086407,0.086693,0.084574,0.090026,0.089224,0.089797]; % source_IQR数据RMSE值
source_IQR = source_IQR(1:N);

sensor_mean = [0.074743,0.085168,0.068631,0.074529,0.07412,0.079393,0.077526,0.075754];
sensor_mean = sensor_mean(1:N);
sensor_sigma = [0.081046,0.08935,0.064059,0.0767,0.076552,0.081902,0.082197,0.081584];
sensor_sigma = sensor_sigma(1:N);
sensor_IQR = [0.075686,0.089628,0.067807,0.07348,0.073532,0.080142,0.076664,0.074882];
sensor_IQR = sensor_IQR(1:N);

% 窗口最大化
set(gcf, 'Position', get(0, 'ScreenSize'));

% plot(x, source_mean, '--', ...
%     x, source_sigma, '-*b', ...
%     x, source_IQR, '-or', ...
%     x, sensor_mean, '--', ...
%     x, sensor_sigma, '-*', ...
%     x, sensor_IQR, '-o', 'LineWidth', 1);

plot(x, source_mean, '--', ...
    x, source_sigma, '-o', ...
    x, source_IQR, '-^', ...
    x, sensor_mean, '-.', ...
    x, sensor_sigma, '-s', ...
    x, sensor_IQR, '-d', 'LineWidth', 2, 'MarkerSize', 8);




axis([0,(N+1)*10,0.05,0.1])  %确定x轴与y轴框图大小
set(gca,'FontName','Times New Roman','FontSize',36); %设置坐标轴数字的字体和字号
legend('source\_mean','source\_sigma','source\_IQR','sensor\_mean','sensor\_sigma','sensor\_IQR','FontName','Times New Roman','FontSize',36,'Location','southEast');   %右上角标注
xlabel('Number of running rounds','FontName','Times New Roman','FontSize',36)  %x轴坐标描述
ylabel('RMSE','FontName','Times New Roman','FontSize',36) %y轴坐标描述


% 设置输出参数
filename = 'output.eps';
fig = gcf;
resolution = '-r600'; % 设置分辨率

% 导出eps图片
print(fig, filename, '-depsc', resolution);
