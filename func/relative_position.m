function x = relative_position(g,id)

k = (id-33)/3+1;
eid = 2*(k-1);
x = g.edges(eid).measurement;   % the robot pose

end

