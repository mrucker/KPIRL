run(fullfile(fileparts(which(mfilename)), '..', '..', '..', 'shared', 'paths.m'));

domain = 'rem';

n_rewds = 10;
n_samps = 64;
n_steps = 10;
  gamma = .9;

rewards    = random_linear_reward(domain, n_rewds);
attributes = { policy_time() policy_value(domain, n_samps, n_steps, gamma) };
statistics = { avg() SEM() med() };
outputs    = { statistics_to_screen() };

daps = {
    'kla_spd T=1 W=3;', @kla_spd, struct('v_feats', '1a', 'N', 20, 'M', 90, 'T', 1 , 'W', 3, 'gamma', 1);
    'kla_mem T=1 W=3;', @kla_mem, struct('v_feats', '1a', 'N', 20, 'M', 90, 'T', 1 , 'W', 3, 'gamma', 1);    
}';

analyze_policy(domain, daps, rewards, attributes, statistics, outputs);