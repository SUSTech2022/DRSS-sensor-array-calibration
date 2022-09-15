
function [e, A, B,C] = linearize_pose_landmark_constraint(x, l, z, g)
  % compute the error and the Jacobians of the error
   
  % error
  e = zeros(g.M-1,1);
  for n = 1:(g.M-1)
    d_nk=sqrt(  (x(1)-l(4*n+1))^2 + (x(2)-l(4*n+2))^2 + (x(3)-l(4*n+3))^2  );
    d_1k=sqrt((x(1))^2 + (x(2))^2 + (x(3))^2);
    p = -10*l(4*n+4)*log10(d_nk/d_1k);
    noise = 0*randn(1,1)*p;  
    e(n)= p+noise- z(n);
  end
  
  % computation of A, de/dx1, x1 here is landmark
  A = [];
  A = [A,zeros(g.M-1,3)]; 
  for n = 1:(g.M-1)
    d_1k=sqrt((x(1))^2 + (x(2))^2 + (x(3))^2);
    d_nk2=(x(1)-l(4*n+1))^2 + (x(2)-l(4*n+2))^2 + (x(3)-l(4*n+3))^2;
    d_nk=sqrt(d_nk2);
    A_struct(n).matrix = [zeros(n-1,3);
                          (10*l(4*n+4)*(x(1)-l(4*n+1)))/(d_nk2*log(10)), (10*l(4*n+4)*(x(2)-l(4*n+2)))/(d_nk2*log(10)),(10*l(4*n+4)*(x(3)-l(4*n+3)))/(d_nk2*log(10)); 
                          zeros(g.M-1-n,3)];
    
                                          
    A = [A A_struct(n).matrix];
    
  end

  % computation of B, de/dx2, x2 here is robot pose
  B = [];
  for n = 1:(g.M-1)
      d_nk2 = (x(1)-l(4*n+1))^2 + (x(2)-l(4*n+2))^2 + (x(3)-l(4*n+3))^2;
      d_1k2 = (x(1))^2 + (x(2))^2 + (x(3))^2;
      B_struct(n).matrix = [-(10*l(4*n+4)*(x(1)-l(4*n+1)))/(d_nk2*log(10))+(10*l(4*n+4)*x(1))/(d_1k2*log(10)),...
                           -(10*l(4*n+4)*(x(2)-l(4*n+2)))/(d_nk2*log(10))+(10*l(4*n+4)*x(2))/(d_1k2*log(10)),...
                           -(10*l(4*n+4)*(x(3)-l(4*n+3)))/(d_nk2*log(10))+(10*l(4*n+4)*x(3))/(d_1k2*log(10))];
      B = [B; B_struct(n).matrix];
  end
%   disp(['B:',num2str(size(B))]);

  
   C = [];
   for n = 1:(g.M-1)
        d_1k=sqrt((x(1))^2 + (x(2))^2 + (x(3))^2);
        d_nk2=(x(1)-l(4*n+1))^2 + (x(2)-l(4*n+2))^2 + (x(3)-l(4*n+3))^2;
        d_nk=sqrt(d_nk2);
        C_struct(n).matrix = [-10*log10(d_nk/d_1k)];
        C = [C; C_struct(n).matrix];
   end
   
   
  
end
