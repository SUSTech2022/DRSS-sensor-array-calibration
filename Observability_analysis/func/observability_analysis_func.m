function observability_analysis_func(input)

%% parameters

% graph file
load(input.graph_file);

% idx of sound src to used for computing ranks
ss_idx = input.eqn.ss_idx;
% idx of Or
o_r = input.eqn.o_r;
o_k = input.eqn.o_k;

%% computing observability analysis

% compute 
[J_G, L,T,BB,J_G_col_num, J_G_rank]= compute_fim(g);

% F matrix rank in theorim 1
F = [L,T,BB];

F_rank = rank(F);
F_col_num = size(F,2);

% disp rank
J_G_rank = J_G_rank;
J_G_col_num = J_G_col_num;

% compute Gi for each sound src
G = [];
G.ss(g.M).Gi = [];

for n=2:g.M
    G.ss(n).Gi= zeros(size(ss_idx,2),3);
    for i=1:size(ss_idx,2)
        k = ss_idx(i);
        G.ss(n).Gi(i,:) = J_G((g.M-1+3)*(k-1)+(n-1),3*(n-2)+1:3*(n-1));
        G.ss(n).Gi_rank = rank(G.ss(n).Gi);
        G.ss(n).Gi_rank_def = size(G.ss(n).Gi,2) - G.ss(n).Gi_rank;
    end
end

% (1) display O_r 
Or = zeros(3,3);
for n=1:3
    Or(n,:) = T((g.M-1+3)*(o_k(n)-1)+(o_r(n)-1),:);
end
Or_rank = rank(Or);
disp(['O_r = [','O','_',num2str(o_r(1)),'^',num2str(o_k(1)),';',...
    'O','_',num2str(o_r(2)),'^',num2str(o_k(2)),';',...
    'O','_',num2str(o_r(3)),'^',num2str(o_k(3)),']: ']);
disp(Or);
disp(['rank(O_r) = ',num2str(Or_rank)]);
disp('----------');

% (2) disp G_i
n=2;
disp(['G_',num2str(n),':']);
disp(G.ss(n).Gi);                   
disp(['rank(G_',num2str(n),') = ',num2str(G.ss(n).Gi_rank)]);
disp('----------');


% (3) disp F rank and column number
disp(['rank(F) = ',num2str(F_rank),', with column number of ',num2str(F_col_num) ]);
disp(['size(F) = ',num2str(size(F))]);
disp('----------');

% (4) disp J_G rank and column number
disp(['rank(J_G) = ',num2str(J_G_rank),', with column number of ',num2str(J_G_col_num) ]);
disp(['size(J_G) = ',num2str(size(J_G))]);

disp(' ');

end









