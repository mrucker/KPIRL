function [r_i, r_p] = rem_reward_features()

    n_levels = [2, 30, 2, 30];

    state2feature = {
        @transitivity;
        @popularity;
        @reciprocity;
        @intransitivity;
    };
    
    feature2level = {
          bin_discrete(0  ,n_levels(1));
        bin_continuous(0,1,n_levels(2));
          bin_discrete(0  ,n_levels(3));
        bin_continuous(0,1,n_levels(4));
    };

    level2basis = {
        level2linear(n_levels(1));
        level2linear(n_levels(2));
        level2linear(n_levels(3));
        level2linear(n_levels(4));
    };

    [r_i, r_p] = multi_basis(n_levels, state2feature, feature2level, level2basis);
    
    function f = transitivity(states)
        if(size(states,1) < 4) 
            f = zeros(1, size(states,2));
        else
            f = double((states(end-2,:) == states(end-1,:)) & (states(end-3,:) ~= states(end,:)));
        end
    end

    function f = popularity(states)
        f = sum(states(1:end-2,:) == states(end,:),1)/(size(states,1)/2 - 1);
    end

    function f = reciprocity(states)

        if(size(states,1) < 4) 
            f = zeros(1, size(states,2));
        else
            f = double((states(end-2,:) == states(end-1,:)) & (states(end-3,:) == states(end,:)));
        end
    end

    function f = intransitivity(states)
        f = sum(states(1:2:end-2,:) == states(end-1,:) & states(2:2:end-2,:) == states(end,:), 1)./sum(states(1:2:end-2,:) == states(end-1,:),1);
        f(isnan(f)) = 0;
    end
end