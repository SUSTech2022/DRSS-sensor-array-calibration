function RMSE = LM_iteration(g)
    lim = 1e+03;
    g.eps = 1e-3;
    g.fig.title = g.name;
    g.fig.view_a = -36; g.fig.view_e = 15;
    figure;sgtitle(g.name);
    subplot(2,2,1);
    g0 = calib_func_lm(g,0,'random',0);  % use the initializing procedure
%     g0 = calib_func_lm(g,0,0.001,0); % use the ground truth plus noise
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
        figure;sgtitle(g.name);
        subplot(2,2,1);
        g0 = calib_func_lm(g0,0,'random',1);
%         g0 = calib_func_lm(g,0,0.001,0);
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
    g1_rmse = cal_RMSE(g1);
    g = g1;
    RMSE = [g0_rmse,g1_rmse];
    save("./data/g1.mat", "g");

end