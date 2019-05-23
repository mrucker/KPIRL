function [reward_function, time_measurements, state_importance] = pirl(domain)

    feval([domain '_parameters'], struct('kernel', k_dot()));

    [reward_function, time_measurements, state_importance] = kpirl(domain);
end