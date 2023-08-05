function g = calib_func_lm(input,numIterations,coef,sensor_reinit)
% This file performs least square SLAM

%% parameters

% display norm(dx) for each iteration?
display_norm_dx_on = 0;

% maximum allowed dx
EPSILON = input.eps;

% need to calculate real measurements (for simulation only)?
cal = false;

% load the graph into the variable "g"
load(input.graph_file);

measurements=[];

% calculate real measurements
if (cal)
    for eid = 1:length(g.edges)
        if (strcmp(g.edges(eid).type, 'L') ~= 0)
            x = g.x_gt(g.edges(eid).toIdx:g.edges(eid).toIdx+2);   % the robot pose
            l = g.x_gt(g.edges(eid).fromIdx:g.edges(eid).fromIdx+(4*g.M-1));     % the landmark
            p_k=[];
            for n = 1:(g.M-1)
                d_nk=sqrt( (x(1)-l(4*n+1))^2 + (x(2)-l(4*n+2))^2 + (x(3)-l(4*n+3))^2  );
                d_1k=sqrt((x(1))^2 + (x(2))^2 + (x(3))^2);
                p_nk= -10*l(4*n+4)*log10(d_nk/d_1k)+0*randn(1,1); %方差
                p_k=[p_k;p_nk];
            end
            g.edges(eid).measurement = p_k;
            measurements = [measurements,p_k];
        end
    end
end

% set initial state
% rng(4); 
if strcmp(coef,'random')==1
    if sensor_reinit==0
        g.x(1:3)=[0 0 0]; % set the reference


        % 初始化PLE
        init_gamma = unifrnd(2,3); % unifrnd(1,7) % 和initial_sensor_position同步修改
        for k=4:4:4*g.M
            g.x(k)=init_gamma;
        end


        disp('initializing source...')
        init_src_pos = g.x_gt(4*g.M+1:4*g.M+3);  % 信号源起点
%         g.x(4*g.M+1:4*g.M+3) = init_src_pos + 0.01*randn(3,1).*init_src_pos; % set the initial source position
        g.x(4*g.M+1:4*g.M+3) = init_src_pos + 0.01*randn(3,1);
        for id = 4*g.M+4:3:length(g.x)
            g.x(id:id+2) = g.x(id-3:id-1) + relative_position(g,id) + 0.01*randn(3,1).*relative_position(g,id);
        end
        disp('initializing sensor array...')
        g.x(5:4*g.M) = initial_sensor_position(g); % sensor
    else
        disp('reinitializing sensor array...')
        g.x(5:4*g.M) = initial_sensor_position(g); % re_sensor
    end
else
    % do not use the above initializing procedure
    g.x=g.x+coef*randn(length(g.x),1).*g.x;
end

% set lamda
g.lamda = 0;

err = [];

% change information matrix
for eid = 1:length(g.edges)
    if (strcmp(g.edges(eid).type, 'L') ~= 0)
          f = 1e+00; % DRSS的方差的倒数 比取1e+02更好
          g.edges(eid).information = f*eye(g.M-1);
    elseif (strcmp(g.edges(eid).type, 'P') ~= 0)
          f = 2.5e+02; %里程计方差的倒数 2.5e+03
          g.edges(eid).information = f*eye(3);
    end
end



%% start SLAM

% carry out the iterations
y = [];
num = 1;
I = eye(length(g.x));
i = 0;
[H,b] = linearize_and_solve_with_H(g);
u = 1e-20;
v = 2;
g.x_temp = g.x;

if numIterations == 0
    disp('numIterations == 0');
    % plot the estimated state of the graph
    plot_graph_with_cov(g);
    legend('Sensor pos. est.','Sensor pos. ground truth','Signal source est.', 'Signal source ground truth','Location','northeast');
    title(input.fig.title);
    view(input.fig.view_a, input.fig.view_e);
end


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
      
      G = H + u*I;
      dx = G\(-b);
      err = [err,compute_global_error(g)]; 
    
      if norm(dx)>4
%           disp([num2str(norm(dx)),' norm(dx)>4'])
          u = u * 100;
          if length(err)>1
            err = err(1:end-1);
          end
          continue;
      end
             
      rho = [];
      if length(err)>1 
          rho = (err(length(err)-1)-err(length(err)))/(dx'*(u*dx-b));
          
          if rho>0.75
              u = u * max(1/3, 1-2*(rho-1)^3);
              v = 2;
          elseif rho<0.25 && rho>0
              u = u * v;
              v = v * 2;
          elseif rho < 0 && rho > -2
              u = u * 2;
              err = err(1:end-1); % do not iterate
              continue
          elseif rho<-2
%             disp([num2str(rho),' rho<-2,break'])
              break
          end

      end
      
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
      % rotate the mic positions
      for n=2:g.M
          g.x(4*(n-1)+1:4*(n-1)+3) = [eye(3) zeros(3,1)]*M_transform*[g.x(4*(n-1)+1:4*(n-1)+3);1];
      end
      % rotate the sound src positions
      for n=1:(size(g.x,1)-4*g.M)/4
          g.x(4*g.M+4*(n-1)+1:4*g.M+4*(n-1)+3) = [eye(3) zeros(3,1)]*M_transform*[g.x(4*g.M+4*(n-1)+1:4*g.M+4*(n-1)+3);1];
      end

      % TODO: implement termination criterion as suggested on the sheet
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
    disp(['mean_gamma =' ,num2str(sum/(g.M-1))]);

    % plot the estimated state of the graph
    plot_graph_with_cov(g);
    legend('Sensor pos. est.','Sensor pos. ground truth','Signal source est.', 'Signal source ground truth','Location','northeast');
    title(input.fig.title);
    view(input.fig.view_a, input.fig.view_e);

    
end

end



