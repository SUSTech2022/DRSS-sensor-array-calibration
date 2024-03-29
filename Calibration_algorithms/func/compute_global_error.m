% Computes the total error of the graph
function Fx = compute_global_error(g)

Fx = 0;

% Loop over all edges
for eid = 1:length(g.edges)
  edge = g.edges(eid);

  % pose-pose constraint
  if (strcmp(edge.type, 'P') ~= 0)

    x1 = g.x(edge.fromIdx:edge.fromIdx+2);
    x2 = g.x(edge.toIdx:edge.toIdx+2);

    % compute the error of the constraint and add it to Fx.
    % Use edge.measurement and edge.information to access the
    % measurement and the information matrix respectively.
    e_ij = (x2 - x1) - edge.measurement; %误差 = 估计值-测量值
    e_ls_ij = e_ij' * edge.information * e_ij;
    Fx = Fx + e_ls_ij;


  % pose-landmark constraint
  elseif (strcmp(edge.type, 'L') ~= 0)
    l = g.x(edge.fromIdx:edge.fromIdx+(4*g.M-1));  % the landmark
    x = g.x(edge.toIdx:edge.toIdx+2);      % the robot pose

    % compute the error of the constraint and add it to Fx.
    % Use edge.measurement and edge.information to access the
    % measurement and the information matrix respectively.
    e_il = zeros(g.M-1,1);
    for n = 1:(g.M-1)
        d_nk=sqrt(  (x(1)-l(4*n+1))^2 + (x(2)-l(4*n+2))^2 + (x(3)-l(4*n+3))^2  );
        d_1k=sqrt((x(1))^2 + (x(2))^2 + (x(3))^2);
        p = -10*l(4*n+4)*log10(d_nk/d_1k);
        noise = 0*randn(1,1);  
        e_il(n)= p+noise - edge.measurement(n); % 误差 = 估计值-测量值
    end
   
    e_ls_il = e_il' * edge.information * e_il;
    Fx = Fx + e_ls_il;

  end

end
