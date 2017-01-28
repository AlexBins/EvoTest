% define all policies that should be used: {'none'; 'unrestricted'}
policies = {'unrestricted'};
% define all migration rates that should be used
migration_rates = [1 4 7];
% define all sizes of migration cycles
migration_cycle_sizes = [1 20 100 250];
% how many epochs per population should be run
max_epochs = 2000;

autogen(policies, migration_rates, migration_cycle_sizes, max_epochs)