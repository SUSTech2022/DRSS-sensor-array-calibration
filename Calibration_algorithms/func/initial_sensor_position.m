function c = initial_sensor_position(g)
% n: sensor index

%Coordinates of the four points
chi = randi([1 (length(g.x)-32)/3],1,4);
chi_1 = chi(1);
chi_2 = chi(2);
chi_3 = chi(3);
chi_4 = chi(4);
coef = 0;
x = [g.x(33+(chi_1-1)*3)+coef*randn(1,1).*g.x(33+(chi_1-1)*3),g.x(33+(chi_2-1)*3)+coef*randn(1,1).*g.x(33+(chi_2-1)*3),g.x(33+(chi_3-1)*3)+coef*randn(1,1).*g.x(33+(chi_3-1)*3),g.x(33+(chi_4-1)*3)+coef*randn(1,1).*g.x(33+(chi_4-1)*3)];
y = [g.x(34+(chi_1-1)*3)+coef*randn(1,1).*g.x(34+(chi_1-1)*3),g.x(34+(chi_2-1)*3)+coef*randn(1,1).*g.x(34+(chi_2-1)*3),g.x(34+(chi_3-1)*3)+coef*randn(1,1).*g.x(34+(chi_3-1)*3),g.x(34+(chi_4-1)*3)+coef*randn(1,1).*g.x(34+(chi_4-1)*3)];
z = [g.x(35+(chi_1-1)*3)+coef*randn(1,1).*g.x(35+(chi_1-1)*3),g.x(35+(chi_2-1)*3)+coef*randn(1,1).*g.x(35+(chi_2-1)*3),g.x(35+(chi_3-1)*3)+coef*randn(1,1).*g.x(35+(chi_3-1)*3),g.x(35+(chi_4-1)*3)+coef*randn(1,1).*g.x(35+(chi_4-1)*3)];
A = 2*([x(2)-x(1),y(2)-y(1),z(2)-z(1);
         x(3)-x(1),y(3)-y(1),z(3)-z(1);
         x(4)-x(1),y(4)-y(1),z(4)-z(1)]);
while det(A) == 0 
    chi = randi([1 (length(g.x)-32)/3],1,4);
    chi_1 = chi(1);
    chi_2 = chi(2);
    chi_3 = chi(3);
    chi_4 = chi(4);
    x = [g.x(33+(chi_1-1)*3)+coef*randn(1,1).*g.x(33+(chi_1-1)*3),g.x(33+(chi_2-1)*3)+coef*randn(1,1).*g.x(33+(chi_2-1)*3),g.x(33+(chi_3-1)*3)+coef*randn(1,1).*g.x(33+(chi_3-1)*3),g.x(33+(chi_4-1)*3)+coef*randn(1,1).*g.x(33+(chi_4-1)*3)];
    y = [g.x(34+(chi_1-1)*3)+coef*randn(1,1).*g.x(34+(chi_1-1)*3),g.x(34+(chi_2-1)*3)+coef*randn(1,1).*g.x(34+(chi_2-1)*3),g.x(34+(chi_3-1)*3)+coef*randn(1,1).*g.x(34+(chi_3-1)*3),g.x(34+(chi_4-1)*3)+coef*randn(1,1).*g.x(34+(chi_4-1)*3)];
    z = [g.x(35+(chi_1-1)*3)+coef*randn(1,1).*g.x(35+(chi_1-1)*3),g.x(35+(chi_2-1)*3)+coef*randn(1,1).*g.x(35+(chi_2-1)*3),g.x(35+(chi_3-1)*3)+coef*randn(1,1).*g.x(35+(chi_3-1)*3),g.x(35+(chi_4-1)*3)+coef*randn(1,1).*g.x(35+(chi_4-1)*3)];
    
    A = 2*([x(2)-x(1),y(2)-y(1),z(2)-z(1);
                x(3)-x(1),y(3)-y(1),z(3)-z(1);
                x(4)-x(1),y(4)-y(1),z(4)-z(1)]);
end
chi= [chi_1 chi_2 chi_3 chi_4]

gamma = g.x(8:4:32);

%% 
% a = g.x(33); b = g.x(34); c = g.x(35); 
% d_1k = sqrt(a^2+b^2+c^2);
d_11 = 0;d_12 = 0;d_13 = 0;d_14 = 0;
x_k = [g.x(33+(chi_1-1)*3),g.x(33+(chi_2-1)*3),g.x(33+(chi_3-1)*3),g.x(33+(chi_4-1)*3)];
y_k = [g.x(34+(chi_1-1)*3),g.x(34+(chi_2-1)*3),g.x(34+(chi_3-1)*3),g.x(34+(chi_4-1)*3)];
z_k = [g.x(35+(chi_1-1)*3),g.x(35+(chi_2-1)*3),g.x(35+(chi_3-1)*3),g.x(35+(chi_4-1)*3)];
d_11 = sqrt(x_k(1)^2+y_k(1)^2+z_k(1)^2);
d_12 = sqrt(x_k(2)^2+y_k(2)^2+z_k(2)^2);
d_13 = sqrt(x_k(3)^2+y_k(3)^2+z_k(3)^2);
d_14 = sqrt(x_k(4)^2+y_k(4)^2+z_k(4)^2);
distance = [];
p = [];
p_11 = [];p_22 = [];p_33 = [];p_44 = [];
 for n = 2:8
      p_1 = g.edges(2*chi_1-1).measurement(n-1);
   p_11 = [p_11,p_1];
      p_2 = g.edges(2*chi_2-1).measurement(n-1);
   p_22 = [p_22,p_2];
      p_3 = g.edges(2*chi_3-1).measurement(n-1);
   p_33 = [p_33,p_3];
      p_4 = g.edges(2*chi_4-1).measurement(n-1);
   p_44 = [p_44,p_4];
 end
p = [p_11;p_22;p_33;p_44];
distance_11 = [];distance_22 = [];distance_33 = [];distance_44 = [];
 for n = 2:8
     distance_1 = d_11*10^(-p(1,n-1)/(10*gamma(n-1)));
   distance_11 = [distance_11,distance_1];
        distance_2 = d_12*10^(-p(2,n-1)/(10*gamma(n-1)));
   distance_22 = [distance_22,distance_2];
           distance_3 = d_13*10^(-p(3,n-1)/(10*gamma(n-1)));
   distance_33 = [distance_33,distance_3];
           distance_4 = d_14*10^(-p(4,n-1)/(10*gamma(n-1)));
   distance_44 = [distance_44,distance_4];  
 end  
 distance = [distance_11;distance_22;distance_33;distance_44];
% for k = 1:4
% %    p = g.edges(2*k-1).measurement(n-1);
% %   distance(k) = d_1k*10^(-p(k,n-1)/(10*gamma(n-1))) % d_ik
% end

%%
% A = zeros(3,3);
b = [];
c = zeros(21,1);
 
%     A = 2*([x(2)-x(1),y(2)-y(1),z(2)-z(1);
%                 x(3)-x(1),y(3)-y(1),z(3)-z(1);
%                 x(4)-x(1),y(4)-y(1),z(4)-z(1)]);
 for n = 2:8         
    b_ = [distance(1,n-1)^2-distance(2,n-1)^2+x(2)^2-x(1)^2+y(2)^2-y(1)^2+z(2)^2-z(1)^2;
        distance(1,n-1)^2-distance(3,n-1)^2+x(3)^2-x(1)^2+y(3)^2-y(1)^2+z(3)^2-z(1)^2;
        distance(1,n-1)^2-distance(4,n-1)^2+x(4)^2-x(1)^2+y(4)^2-y(1)^2+z(4)^2-z(1)^2];
    b = [b;b_];
    size(b);

 end

c = [];
for i = 0:6
    c_ = [A\b(1+3*i:1+3*i+2);gamma(i+1)];
    c = [c;c_];
    size(c);
end

    

