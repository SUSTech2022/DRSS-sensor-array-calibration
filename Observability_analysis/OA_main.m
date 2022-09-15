%% refresh
clear;
close all;
clc;

%% add path for including some tool functions
addpath('func');

%% Cases When Observability is Guaranteed

% trajectory 1 
trajectory_01.graph_file = './data/trajectory_01.mat';
trajectory_01.name = 'trajectory_01';
trajectory_01.eqn.ss_idx = [9,14,23];
trajectory_01.eqn.o_r = [4, 6, 6];
trajectory_01.eqn.o_k = [7, 7, 9];
disp('------------ Observability analysis of trajectory 1 ------------')
observability_analysis_func(trajectory_01);

% trajectory 2 
trajectory_02.graph_file = './data/trajectory_02.mat';
trajectory_02.name = 'trajectory_02';
trajectory_02.eqn.ss_idx = [1,5,16];
trajectory_02.eqn.o_r = [3, 5, 7];
trajectory_02.eqn.o_k = [2, 2, 3];
disp('------------ Observability analysis of trajectory 2 ------------')
observability_analysis_func(trajectory_02);

%% Cases When Observability is Impossible

% Coplanar
coplanar.graph_file = './data/coplanar.mat';
coplanar.name = 'coplanar';
coplanar.eqn.ss_idx = [2,6,14];
coplanar.eqn.o_r = [2, 4, 7];
coplanar.eqn.o_k = [4, 5, 12];
disp('------------ Observability analysis of the coplanar case ------------')
observability_analysis_func(coplanar);

% Cosphere
cosphere.graph_file = './data/cosphere.mat';
cosphere.name = 'cosphere';
cosphere.eqn.ss_idx = [5,8,25];
cosphere.eqn.o_r = [3, 3, 8];
cosphere.eqn.o_k = [5, 6, 7];
disp('------------ Observability analysis of the cosphere case ------------')
observability_analysis_func(cosphere);
