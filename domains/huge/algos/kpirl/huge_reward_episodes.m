function episodes = huge_reward_episodes(reward)

    domain = 'huge';

    [t_s   ] = feval([domain '_transitions']);
    [params] = feval([domain '_parameters']);

    epi_count  = params.samples;
    epi_length = params.steps;

    policy   = kla_spd(domain, reward);
    
    episodes = policy2episodes(policy, t_s, epi_count, epi_length);
end