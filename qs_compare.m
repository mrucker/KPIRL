run(fullfile(fileparts(which(mfilename)), 'shared', 'paths.m'));

%WARNING: reducing n_rewds will make the estimate of E[V|DAP  ] less precise causing performance comparisons to be more suspect
%WARNING: reducing n_samps will make the estimate of E[V|DAP,R] less precise causing performance comparisons to be more suspect

domain = 'huge';

n_rewds = 1;
n_samps = 64;
n_steps = 10;
  gamma = .9;

rewards    = random_linear_reward(domain, n_rewds, @(n) [1 - 2 * rand(1,n-1) 0]);
attributes = { policy_time() policy_value(domain, n_samps, n_steps, gamma) };
statistics = { avg() SEM() med() };
outputs    = { statistics_to_screen() };

%(D)escription (A)lgorithm (P)arameters
daps = {
    %generate a policy using kla_spd and basis '1b' (aka, shared/features/single_feature) which gives a policy of random actions.
    'random'  , @kla_spd, struct('N', 10, 'M', 01 , 'T', 01, 'v_feats', '1b', 'W', 00);

    %generate a policy using kla_spd and basis '1a' (this kla implementation decreases computation by increasing memory use)
    'kla_spd' , @kla_spd, struct('N', 10, 'M', 90 , 'T', 04, 'v_feats', '1a', 'W', 03);

    %generate a policy using kla_mem and basis '1a' (this kla implementation decreases memory use by increasing computation)
    'kla_mem' , @kla_mem, struct('N', 10, 'M', 90 , 'T', 04, 'v_feats', '1a', 'W', 03);

    %generate a policy using lspi and basis '1a' with a second order polynomial transform applied to the basis 
    'lspi '   , @lspi   , struct('N', 10, 'M', 90, 'T', 06, 'v_feats', '1a', 'resample', true, 'basis', poly_basis(2));

    %generate a policy using klspi and basis '1a' with the provided kernel function
    'klspi'   , @klspi  , struct('N', 10, 'M', 90, 'T', 06, 'v_feats', '1a', 'resample', true, 'kernel', k_gaussian(k_norm(),1), 'mu', 0.3);
}';

a = tic;

analyze_policy(domain, daps, rewards, attributes, statistics, outputs);

toc(a);