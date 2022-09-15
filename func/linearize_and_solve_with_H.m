% performs one iteration of the Gauss-Newton algorithm
% each constraint is linearized and added to the Hessian

function [H,b] = linearize_and_solve_with_H(g)

% allocate the sparse H and the vector b
H = zeros(length(g.x), length(g.x));
J = zeros(g.M-1,length(g.x));
b = zeros(length(g.x), 1);

needToAddPrior = true;

% compute the addend term to H and b for each of our constraints
for eid = 1:length(g.edges)
  edge = g.edges(eid);

  % pose-pose constraint
  if (strcmp(edge.type, 'P') ~= 0)
    % edge.fromIdx and edge.toIdx describe the location of
    % the first element of the pose in the state vector
    % You should use also this index when updating the elements
    % of the H matrix and the vector b.
    % edge.measurement is the measurement
    % edge.information is the information matrix
    x1 = g.x(edge.fromIdx:edge.fromIdx+2);  % the first robot pose
    x2 = g.x(edge.toIdx:edge.toIdx+2);      % the second robot pose

    % Computing the error and the Jacobians
    % e the error vector
    % A Jacobian wrt x1
    % B Jacobian wrt x2
    [e, A, B] = linearize_pose_pose_constraint(x1, x2, edge.measurement);
    
    
    % TODO: compute and add the term to H and b
    b(edge.fromIdx:edge.fromIdx+2) = (b(edge.fromIdx:edge.fromIdx+2)' + (e')*edge.information*A)';
    b(edge.toIdx:edge.toIdx+2) = (b(edge.toIdx:edge.toIdx+2)' + (e')*edge.information*B)';

    H(edge.fromIdx:edge.fromIdx+2,edge.fromIdx:edge.fromIdx+2) = H(edge.fromIdx:edge.fromIdx+2,edge.fromIdx:edge.fromIdx+2) + A'*edge.information*A;
    H(edge.fromIdx:edge.fromIdx+2,edge.toIdx:edge.toIdx+2) = H(edge.fromIdx:edge.fromIdx+2,edge.toIdx:edge.toIdx+2) + A'*edge.information*B;
    H(edge.toIdx:edge.toIdx+2,edge.fromIdx:edge.fromIdx+2) = H(edge.toIdx:edge.toIdx+2,edge.fromIdx:edge.fromIdx+2) + B'*edge.information*A;
    H(edge.toIdx:edge.toIdx+2,edge.toIdx:edge.toIdx+2) = H(edge.toIdx:edge.toIdx+2,edge.toIdx:edge.toIdx+2) + B'*edge.information*B;


  % pose-landmark constraint
  elseif (strcmp(edge.type, 'L') ~= 0)
    % edge.fromIdx and edge.toIdx describe the location of
    % the first element of the pose and the landmark in the state vector
    % You should use also this index when updating the elements
    % of the H matrix and the vector b.
    % edge.measurement is the measurement
    % edge.information is the information matrix
    x1 = g.x(edge.toIdx:edge.toIdx+2);   % the robot pose
    x2 = g.x(edge.fromIdx:edge.fromIdx+(4*g.M-1));     % the landmark

    % Computing the error and the Jacobians
    % e the error vector
    % A Jacobian wrt x1
    % B Jacobian wrt x2
    [e, A, B] = linearize_pose_landmark_constraint(x1, x2,edge.measurement,g);
    
    n = (edge.toIdx - (4*g.M+1))/3 +1; 
    
    % compute and add the term to H and b
    b(edge.fromIdx:edge.fromIdx+(4*g.M-1)) = (b(edge.fromIdx:edge.fromIdx+(4*g.M-1))' + (e')*edge.information*A)';
    b(edge.toIdx:edge.toIdx+2) = (b(edge.toIdx:edge.toIdx+2)' + (e')*edge.information*B)';

    H(edge.fromIdx:edge.fromIdx+(4*g.M-1),edge.fromIdx:edge.fromIdx+(4*g.M-1)) = H(edge.fromIdx:edge.fromIdx+(4*g.M-1),edge.fromIdx:edge.fromIdx+(4*g.M-1)) + A'*edge.information*A;
    H(edge.fromIdx:edge.fromIdx+(4*g.M-1),edge.toIdx:edge.toIdx+2) = H(edge.fromIdx:edge.fromIdx+(4*g.M-1),edge.toIdx:edge.toIdx+2) + A'*edge.information*B;
    H(edge.toIdx:edge.toIdx+2,edge.fromIdx:edge.fromIdx+(4*g.M-1)) = H(edge.toIdx:edge.toIdx+2,edge.fromIdx:edge.fromIdx+(4*g.M-1)) + B'*edge.information*A;
    H(edge.toIdx:edge.toIdx+2,edge.toIdx:edge.toIdx+2) = H(edge.toIdx:edge.toIdx+2,edge.toIdx:edge.toIdx+2) + B'*edge.information*B;
      
  end
end

if (needToAddPrior)
  % add the prior for one pose of this edge
  % This fixes one node to remain at its current location

  % 1st mic  原点
  H(1:4,1:4) = eye(4);
  
  % 2nd mic  X轴上（Y=Z=0）
  H(4*(g.M_x-1)+2,4*(g.M_x-1)+2) = 1;
  H(1:4*(g.M_x-1)+2-1,4*(g.M_x-1)+2) = zeros(4*(g.M_x-1)+2-1,1);
  H(4*(g.M_x-1)+2,1:4*(g.M_x-1)+2-1) = zeros(1,4*(g.M_x-1)+2-1);
  H(4*(g.M_x-1)+3,4*(g.M_x-1)+3) = 1;
  H(1:4*(g.M_x-1)+3-1,4*(g.M_x-1)+3) = zeros(4*(g.M_x-1)+3-1,1);
  H(4*(g.M_x-1)+3,1:4*(g.M_x-1)+3-1) = zeros(1,4*(g.M_x-1)+3-1);

  
  % 3rd mic XOY平面（Z=0）
  H(4*(g.M_y-1)*g.M_x+3,4*(g.M_y-1)*g.M_x+3) = 1;
  H(1:4*(g.M_y-1)*g.M_x+3-1,4*(g.M_y-1)*g.M_x+3) = zeros(4*(g.M_y-1)*g.M_x+3-1,1);
  H(4*(g.M_y-1)*g.M_x+4,1:4*(g.M_y-1)*g.M_x+3-1) = zeros(1,4*(g.M_y-1)*g.M_x+3-1);
end


end
