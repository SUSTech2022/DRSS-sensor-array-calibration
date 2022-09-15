%% refresh
clear;
close all;
clc;

%% add path for including some tool functions
addpath('func');

%% Cases When Observability is Guaranteed

% trajectory 1 
trajectory_01.graph_file = './data/trajectory_01.mat';
trajectory_01.name = 'Trajectory 01';
RMSE = LM_iteration(trajectory_01);
disp(['g0_RMSE = ',num2str(RMSE(1:3)),' g3_RMSE = ',num2str(RMSE(4:6))]);

% trajectory 2 
trajectory_02.graph_file = './data/trajectory_02.mat';
trajectory_02.name = 'Trajectory 02';
RMSE = LM_iteration(trajectory_02);
disp(['g0_RMSE = ',num2str(RMSE(1:3)),' g3_RMSE = ',num2str(RMSE(4:6))]);

