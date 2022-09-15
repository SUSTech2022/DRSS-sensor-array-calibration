function RMSE = LM_iteration(g)
    lim = 1e+05;
    g.eps = 1e-3;
    g.fig.title = g.name;
    g.fig.view_a = -36; g.fig.view_e = 15;
    figure;suptitle(g.name);
    subplot(2,2,1);
    g0 = calib_func_lm(g,0,'random',0);  % use the initializing procedure
%     g0 = calib_func_lm(g,0,0.1,0); % use the ground truth plus noise
    g0_rmse = cal_RMSE(g0);
    cost = compute_global_error(g0);
    title(['Initial guess, cost = ',num2str(cost)]);
    g0.eps = 1e-3;
    g0.graph_file ='./data/g0.mat';
    g0.fig.title = g.name;
    g0.fig.view_a = -36; g0.fig.view_e = 15;
    g = g0;
    save("./data/g0.mat", "g");
    subplot(2,2,2);
    g1 = calib_func_lm(g0,50,0,0);
    cost = compute_global_error(g1);
    title(['After the first iteration, cost =  ',num2str(cost)]);
    while cost > lim
        disp(['cost > ',num2str(lim)])
        close
        figure;suptitle(g.name);
        subplot(2,2,1);
        g0 = calib_func_lm(g0,0,'random',1);
%         g0 = calib_func_lm(g,0,0.1,0);
        g0_rmse = cal_RMSE(g0);
        cost = compute_global_error(g0);
        title(['Initial guess, cost = ',num2str(cost)]);
        g0.eps = 1e-3;
        g0.graph_file ='./data/g0.mat';
        g0.fig.title = g.name;
        g0.fig.view_a = -36; g0.fig.view_e = 15;
        g = g0;
        save("./data/g0.mat", "g");
        subplot(2,2,2);
        g1 = calib_func_lm(g0,50,0,0);
        cost = compute_global_error(g1);
        title(['After the first iteration, cost = ',num2str(cost)]);
    end
    g1.eps = 1e-3;
    g1.graph_file ='./data/g1.mat';
    g1.fig.title = g.name;
    g1.fig.view_a = -36; g1.fig.view_e = 15;
    g = g1;
    save("./data/g1.mat", "g");
    disp('Performing the second iteration')
    subplot(2,2,3);
    g2 = calib_func_lm(g1,50,0,0);
    cost = compute_global_error(g2);
    title(['After the second iteration, cost = ',num2str(cost)]);
    g2.eps = 1e-3;
    g2.graph_file ='./data/g2.mat';
    g2.fig.title = g.name;
    g2.fig.view_a = -36; g2.fig.view_e = 15;
    g = g2;
    save("./data/g2.mat", "g");
    disp('Performing the third iteration')
    subplot(2,2,4);
    g3 = calib_func_gn(g2,100,0,0);
    g3.eps = 1e-5;
    g3.graph_file ='./data/g3.mat';
    g3.fig.title = g.name;
    g3.fig.view_a = -36; g3.fig.view_e = 15;
    g = g3;
    save("./data/g3.mat", "g");
    cost = compute_global_error(g3);  
    title(['After the third iteration, cost = ',num2str(cost)]);
    g3_rmse = cal_RMSE(g3);
    disp(['final cost = ',num2str(cost)]);
    RMSE = [g0_rmse,g3_rmse];
end