% A wrapper that conforms KLSPI to the RL interface
function [policy, time] = klspi(domain, reward); global R;

    a_start = tic;

        R = reward;

        clear([domain '_value_basis_klspi']);
        clear([domain '_simulator']);

        param_func = [domain '_parameters'];
        basis_func = [domain '_value_basis_klspi'];
        polic_func = [domain '_initialize_policy'];
        
        parameters = feval(param_func);

        max_iter  = parameters.N;
        max_epis  = parameters.M;
        max_steps = parameters.T;
        epsilon   = parameters.epsilon;
        discount  = parameters.gamma;
        mu        = parameters.mu;
        basis     = basis_func;
        
        policy   = feval(polic_func, basis, discount);        
        eval_alg = @(samples, policy, new_policy) klsq_mem(samples, policy, new_policy, mu);

        [~, all_policies] = policy_iteration(domain, eval_alg, policy, max_iter, max_epis, max_steps, epsilon);

        end_policy = all_policies{end};

        policy = @(s) policy_function(end_policy, s);

    time = toc(a_start);
end