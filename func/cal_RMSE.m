function c = cal_RMSE(g)
 p = 0;
for i = 33:length(g.x)
    p_1 = (g.x(i)-g.x_gt(i))^2;
    p = p+p_1;
end
p = sqrt(p/(length(g.x)-32));
s = 0;%l
for i = 5:4:32
    s_x = (g.x(i)-g.x_gt(i))^2;
    s_y = (g.x(i+1)-g.x_gt(i+1))^2;
    s_z = (g.x(i+2)-g.x_gt(i+2))^2;
    s = s+s_x+s_y+s_z;
    
end
s = sqrt(s/32);
gamma = 0;
for i = 8:4:32
gamma_ = (g.x(i)-g.x_gt(i))^2;
gamma = gamma+gamma_;
end
gamma = sqrt(gamma/7);
c = [p s gamma];