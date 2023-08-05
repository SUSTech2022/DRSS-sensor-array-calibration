function c = cal_RMSE(g)
 p = 0;
for i = 4*g.M+1:length(g.x)
    p_1 = (g.x(i)-g.x_gt(i))^2;
    p = p+p_1;
end
p = sqrt(p/(length(g.x)-4*g.M+1)); %信号源位置
s = 0;%l
for i = 5:4:4*g.M
    s_x = (g.x(i)-g.x_gt(i))^2;
    s_y = (g.x(i+1)-g.x_gt(i+1))^2;
    s_z = (g.x(i+2)-g.x_gt(i+2))^2;
    s = s+s_x+s_y+s_z;
    
end
s = sqrt(s/(4*g.M)); %传感器位置
gamma = 0;
for i = 8:4:4*g.M
gamma_ = (g.x(i)-g.x_gt(i))^2;
gamma = gamma+gamma_;
end
gamma = sqrt(gamma/(g.M-1));
c = [p s gamma];