function [J_G, L,T,BB,J_G_col_num, J_G_rank] = compute_fim(g)

J_G = [];
W_inv = [];

rank_deficiency = [];
min_eigen = [];

for eid = 1:length(g.edges)
%   disp([num2str(eid),'/',num2str(length(g.edges))])
  edge = g.edges(eid);

  % pose-pose constraint
  if (strcmp(edge.type, 'P') ~= 0)
    
    x1 = g.x_gt(edge.fromIdx:edge.fromIdx+2);  % the first robot pose
    x2 = g.x_gt(edge.toIdx:edge.toIdx+2);      % the second robot pose

    % Computing the error and the Jacobians
    % e the error vector
    % A Jacobian wrt x1
    % B Jacobian wrt x2
    [e, A, B] = linearize_pose_pose_constraint(x1, x2, edge.measurement);
    
    % compute and add the term to H and b
    J_G = [J_G, zeros(size(J_G,1),3);...
           zeros(3,size(J_G,2)+3)];
    J_G(end-2:end, end-5:end) = [A,B];
    
    W_inv = [W_inv, zeros(size(W_inv,1),3);...
             zeros(3,size(W_inv,2)), edge.information];

  % pose-landmark constraint
  elseif (strcmp(edge.type, 'L') ~= 0)
    x1 = g.x_gt(edge.toIdx:edge.toIdx+2);   % the robot pose
    x2 = g.x_gt(edge.fromIdx:edge.fromIdx+(4*g.M-1));     % the landmark

    % Computing the error and the Jacobians
    % e the error vector
    % A Jacobian wrt x1
    % B Jacobian wrt x2
    [e, A, B,C] = linearize_pose_landmark_constraint(x1, x2,edge.measurement,g);
    
    A = A(:,4:end);
    
    % compute and add the term to H and b
    if isempty(J_G)
        J_G = zeros(g.M-1,size(A,2)+size(B,2)+size(C,2));
    else
        J_G = [J_G;...
               zeros(g.M-1,size(J_G,2))];
    end
    J_G(end-(g.M-1)+1:end,1:3*(g.M-1)) = A;
    J_G(end-(g.M-1)+1:end,end-4+1:end-1) = B;
    J_G(end-(g.M-1)+1:end,end) = C;
    
    
    W_inv = [W_inv, zeros(size(W_inv,1),g.M-1);...
             zeros(g.M-1,size(W_inv,2)), edge.information];
         
    if isempty(rank_deficiency)
      J_G_col_num = size(J_G,2);
      J_G_rank = rank(J_G);
      rank_deficiency = [rank_deficiency,J_G_col_num - J_G_rank];
      
      FIM = J_G'*W_inv*J_G;
      FIM_eigs = eig(FIM);
      min_eigen = [min_eigen, norm(min(FIM_eigs))];
    end

  end
  
  
  
end

J_G_col_num = size(J_G,2);
J_G_rank = rank(J_G);

FIM = J_G'*W_inv*J_G;
FIM_eigs = eig(FIM);

min_FIM_eig = min(FIM_eigs);

% situation in which only time offset / clock drift or nothing is present
J1 = J_G(:,1:3*(g.M-1));
J2 = J_G(:,3*(g.M-1)+1:end-1);
J3 = J_G(:,end);


% J matrix
L = J1;
% T matrix
T = zeros(size(J2,1),3);
K = size(J2,2)/3;
for k=1:K
    T = T+J2(:,3*(k-1)+1:3*(k-1)+3);
end
BB = J3;

end