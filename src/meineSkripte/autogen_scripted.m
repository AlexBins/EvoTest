% define all policies that should be used: {'none'; 'unrestricted'}
policies = {'none'};
% define all migration rates that should be used
migration_rates = [1];
% define all sizes of migration cycles
migration_cycle_sizes = [500];
% how many epochs per population should be run
max_epochs = 1000;

autogen(policies, migration_rates, migration_cycle_sizes, max_epochs)