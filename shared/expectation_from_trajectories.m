function [feature_expectation] = expectation_from_trajectories(trajectories, features, gamma)        

    feature_expectation = 0;

    for m = 1:numel(trajectories)
        for t = 1:size(trajectories{m},2)
            if iscell(trajectories{m})
                feature_expectation = feature_expectation + gamma^(t-1) * features(trajectories{m}{t});
            else
                feature_expectation = feature_expectation + gamma^(t-1) * features(trajectories{m}(:,t));
            end
        end
    end

    feature_expectation = feature_expectation./numel(trajectories);    
end