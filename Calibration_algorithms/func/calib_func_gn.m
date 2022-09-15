function g = calib_func_gn(input,numIterations,coef,sensor_reinit)
% This file performs least square SLAM

%% parameters

% display norm(dx) for each iteration?
display_norm_dx_on = 0;

% maximum allowed dx
EPSILON = input.eps;

% load the graph into the variable "g"
load(input.graph_file);

% calculate real measurements
for eid = 1:length(g.edges)
    if (strcmp(g.edges(eid).type, 'L') ~= 0)
        x = g.x_gt(g.edges(eid).toIdx:g.edges(eid).toIdx+2);   % the robot pose
        l = g.x_gt(g.edges(eid).fromIdx:g.edges(eid).fromIdx+(4*g.M-1));     % the landmark
        p_k=[];
        for n = 1:(g.M-1)
            d_nk=sqrt( (x(1)-l(4*n+1))^2 + (x(2)-l(4*n+2))^2 + (x(3)-l(4*n+3))^2  );
            d_1k=sqrt((x(1))^2 + (x(2))^2 + (x(3))^2);
            p_nk= -10*l(4*n+4)*log10(d_nk/d_1k);
            p_k=[p_k;p_nk];
        end
        g.edges(eid).measurement = p_k;
    end
end

% continue to iterate after LM
g.x=g.x+coef*randn(length(g.x),1).*g.x;

err = [];

% change information matrix
for eid = 1:length(g.edges)
    if (strcmp(g.edges(eid).type, 'L') ~= 0)
          f = 1e+03; 
          g.edges(eid).information = [f 0 0 0 0 0 0;
                                      0 f 0 0 0 0 0;
                                      0 0 f 0 0 0 0;
                                      0 0 0 f 0 0 0;
                                      0 0 0 0 f 0 0;
                                      0 0 0 0 0 f 0;
                                      0 0 0 0 0 0 f];
    elseif (strcmp(g.edges(eid).type, 'P') ~= 0)
          f = 2.5e+05; 
          g.edges(eid).information = [f 0 0 ;
                                      0 f 0 ;
                                      0 0 f ];
    end
end



%% start SLAM

% carry out the iterations
y = [];
num = 1;
p_e = [];
i=0;

tic
if numIterations>0
    while num<numIterations
        compute_global_error(g);
        i = i+1;        
        disp(['Performing iteration ', num2str(num)]);
      
      if compute_global_error(g)<1e-5
          num=num-1;
          disp('error is small enough, iteration ends.');
          break
      end

      % solve the dx
      [H,b] = linearize_and_solve_with_H(g);
      dx = H\(-b);
      err = [err,compute_global_error(g)]; 
             
           
      y = [y;norm(dx)];
      % TODO: apply the solution to the state vector g.x
      g.x = g.x + dx;
%       disp(['rho = ',num2str(rho)]);

      % compute the rotation matrix
      rot_yaw = -atan2(g.x((g.M_x-1)*4+2),g.x((g.M_x-1)*4+1));
      rot_pitch = atan2(g.x((g.M_x-1)*4+3),sqrt(g.x((g.M_x-1)*4+1)^2+g.x((g.M_x-1)*4+2)^2));
      M_half = transform_matrix_from_trans_ypr(0,0,0,rot_yaw,rot_pitch,0);
      M_y_p_hom = M_half*[g.x((g.M_y-1)*(g.M_x)*4+1:(g.M_y-1)*(g.M_x)*4+3);1];
      rot_roll = -atan2(M_y_p_hom(3),M_y_p_hom(2));
      M_transform = transform_matrix_from_trans_ypr(0,0,0,rot_yaw,rot_pitch,rot_roll);
      % rotate the sensor positions
      for n=2:g.M
          g.x(4*(n-1)+1:4*(n-1)+3) = [eye(3) zeros(3,1)]*M_transform*[g.x(4*(n-1)+1:4*(n-1)+3);1];
      end
      % rotate the src positions
      for n=1:(size(g.x,1)-4*g.M)/4
          g.x(4*g.M+4*(n-1)+1:4*g.M+4*(n-1)+3) = [eye(3) zeros(3,1)]*M_transform*[g.x(4*g.M+4*(n-1)+1:4*g.M+4*(n-1)+3);1];
      end

      if display_norm_dx_on>0
        disp(['norm(dx) = ' num2str(norm(dx))]);
      end
      
      num = num +1;

      if (norm(dx)<EPSILON)
        disp("norm(dx)<EPSILON, iteration ends.")
        break
      end
          
      if (isnan(norm(dx)))
          disp("norm(dx)=NaN, iteration ends.")
          break
      end

    end
    
end
toc

if num>0
    gamma = [];
    sum = 0;
    for i=2:g.M
        sum = sum+g.x(4*i);
        gamma = [gamma g.x(4*i)];
    end
    disp(['gamma = ',num2str(gamma)]);
    disp(['mean_gamma =' ,num2str(sum/7)]);

    % plot the estimated state of the graph
    if strcmp(input.fig.title,'Cosphere')
    %     figure;
        drawsphere(0.5,0.5,0.5,0.5);
        hold on
        plot_graph_with_cov(g, num, H);
        legend('sphere','Sensor pos. est.','Sensor pos. ground truth','Signal source est.', 'Signal source ground truth','Location','northeast');
    else
    %     figure;
        plot_graph_with_cov(g, num, H);
        legend('Sensor pos. est.','Sensor pos. ground truth','Signal source est.', 'Signal source ground truth','Location','northeast');
    end
    title(input.fig.title);
    view(input.fig.view_a, input.fig.view_e);

end

end

