% A wrapper that conforms LSPI to the RL interface
function [policy, time, policies, times] = lspi(domain, reward)

    polic_func = [domain '_policy'];
    simul_func = [domain '_simulator'];
    param_func = [domain '_parameters'];
    feats_func = [domain '_value_features_lspi'];
    
    clear(feats_func);
    clear(simul_func);

    [policy] = feval(polic_func);
    [params] = feval(param_func);
    [feats ] = feval(feats_func);

    max_iter  = params.N;
    max_epis  = params.M;
    max_steps = params.T;
    epsilon   = params.epsilon;
    resample  = params.resample;

    policy.reward   = reward;
    policy.feats    = feats;
    policy.function = @(state) policy_function(policy, state);

    sampler  = sarsa_sampler(simul_func, policy, max_epis, max_steps, resample);

    base_alg = get_or_default(params, 'basis' , ident_basis());
    eval_alg = @lsq_spd;

    [~, all_policies] = lspi_klspi_core(sampler, base_alg, eval_alg, policy, max_iter, epsilon);

    policy = all_policies{end}.function;
    time   = all_policies{end}.time;

    policies = cellfun(@(p) { p.function }, all_policies);
    times    = cell2mat(cellfun(@(p) { p.time }, all_policies));
end