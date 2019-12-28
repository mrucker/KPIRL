function [p, i] = rem_features(func)

    params = rem_parameters();
    
    if(strcmp(func, 'reward'))
        [p, i] = rem_reward_features();
    end
    
    if(strcmp(func, 'value'))
        if(params.v_feats == 0)
            [p, i] = single_feature();
        else
            [p, i] = feval(['rem_value_features_' num2str(params.v_feats)]);
        end 
    end

end