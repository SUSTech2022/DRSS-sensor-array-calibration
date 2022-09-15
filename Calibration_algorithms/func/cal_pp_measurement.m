load('D:\SUSTech\RSS\Algorithms\DRSS_array_calib-LM-GN\data\trajectory_06.mat', 'g')
x=[];
for id = 33:3:267
    x = [x;[g.x_gt(id+3),g.x_gt(id+4),g.x_gt(id+5)]-[g.x_gt(id),g.x_gt(id+1),g.x_gt(id+2)]];
    k = (id-33)/3+1;
    eid = 2*k;
    g.edges(eid).measurement = ([g.x_gt(id+3),g.x_gt(id+4),g.x_gt(id+5)]-[g.x_gt(id),g.x_gt(id+1),g.x_gt(id+2)])';
end
x

