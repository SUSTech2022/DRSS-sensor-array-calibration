
%% 先修改要操作的轨迹！！
load('D:\SUSTech\RSS\Algorithms\DRSS-sensor-array-calibration-main\DRSS-sensor-array-calibration-main\Calibration_algorithms_NEW\data\Real_tra_08.mat', 'g')

N=29; %点的个数
M = 8; %sensor个数

%% 1. 填入DRSS measurement 并保存
% for k=1:N
%     g.edges(2*k-1).measurement = a(k:N:(M-1)*N)';
% end

%% 2. (手动)填入坐标真值 g.x_gt 和 g.x 并保存

%% 3. 计算里程计信息，保存
% x=[];
% for id = 4*M+1:3:4*M+1+(N-2)*3
%     x = [x;[g.x_gt(id+3),g.x_gt(id+4),g.x_gt(id+5)]-[g.x_gt(id),g.x_gt(id+1),g.x_gt(id+2)]];
%     k = (id-4*M-1)/3+1;
%     eid = 2*k;
%     g.edges(eid).measurement = ([g.x_gt(id+3),g.x_gt(id+4),g.x_gt(id+5)]-[g.x_gt(id),g.x_gt(id+1),g.x_gt(id+2)])';
% end
% x

%% 4. 填入P L
% for k=1:2:2*(N-1)+1
%     g.edges(k).type = 'L';
%     g.edges(k).information = [100,0,0;0,100,0;0,0,100];
%     g.edges(k).fromIdx = 1;
%     g.edges(k).toIdx = 4*M+1 + (k-1)/2*3;
% end
% 
% 
% for k = 2:2:2*(N-1)
%     g.edges(k).type = 'P';
%     g.edges(k).information = [9,0,0;0,9,0;0,0,9];
%     g.edges(k).fromIdx = 4*M+1 + (k/2-1)*3;
%     g.edges(k).toIdx = g.edges(k).fromIdx+3;
% end


%% 5. 修改idlookup
% for k=1:M
%     g.idLookup(k).offset = 4*(k-1);
%     g.idLookup(k).dimension = 4;
% end
% 
% g.idLookup(M+1).offset = 4*M;
% g.idLookup(M+1).dimension = 3;
% 
% for k=M+2:M+N
%     g.idLookup(k).offset = g.idLookup(k-1).offset + 3;
%     g.idLookup(k).dimension = 3;
% end


%% 预计算gamma
% sum = 0;
% count = 0;
% for eid = 1:length(g.edges)
%   edge = g.edges(eid);
%   if (strcmp(edge.type, 'L') ~= 0)
%     l = g.x(edge.fromIdx:edge.fromIdx+(4*M-1));  % the landmark
%     x = g.x(edge.toIdx:edge.toIdx+2);      % the robot pose
%     for n = 1:(M-1)
%         d_nk=sqrt(  (x(1)-l(4*n+1))^2 + (x(2)-l(4*n+2))^2 + (x(3)-l(4*n+3))^2  );
%         d_1k=sqrt((x(1))^2 + (x(2))^2 + (x(3))^2);
%         for k = 1:M-1
%             p = edge.measurement(k);
%             r = p/(-10*log10(d_nk/d_1k)) % 计算gamma
%             sum = sum+r;
%             count  = count+1;
%         end
%     end
%   end
% end
% mean_r = sum/(3*N)
% count



