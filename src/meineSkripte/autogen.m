function autogen(policies, migration_rates, migration_cycle_sizes, max_epochs)
%AUTOGEN Summary of this function goes here
%   Detailed explanation goes here
    for mc = 1:length(migration_cycle_sizes)
        mig_cycle_size = migration_cycle_sizes(mc);
        mig_cycle_counts = ceil(max_epochs/mig_cycle_size);
        for p = 1:length(policies)
            policy = char(policies(p,:));
            for mr = 1:length(migration_rates)
                mig_rate = migration_rates(mr);
                execute_mpga(8, mig_rate, mig_cycle_size, mig_cycle_counts, policy);
            end
        end
    end

end

function execute_mpga(pop_size, migration_rate, cycle_size, cycle_count, policy)
    mpga = evolute_multipop(pop_size, migration_rate, cycle_size, cycle_count, policy);
    close all;
    eval_multi(mpga);
    filename = sprintf('policy-%s_migRate-%d_cycleSize-%d', policy, migration_rate, cycle_size);
    save(sprintf('%s.mat', filename), 'mpga');
    saveas(1, sprintf('%s-tcs.jpg', filename));
    saveas(2, sprintf('%s-fit.jpg', filename));
end