function [action] = policy_function(policy, state)

  valid_actions = policy.actions(state);

  %%% Exploration or not? 
  if (rand < policy.explore)
    action = valid_actions(:,randi(size(valid_actions,2)));
  else
    
    %%% Find first all actions with maximum Q-value

    if isfield(policy, 'dic')
        phis = feval(policy.basis, state, valid_actions, policy.dic);
    else
        phis = feval(policy.basis, state, valid_actions);
    end
    
    q_all = phis' * policy.weights;    
    q_max = max(q_all);
    i_max = find(q_all == q_max);
    
    action  = valid_actions(:,i_max(randi(length(i_max))));
  end
  
  
  return
