function gen_fitnes = evaluate_fitnes() 
    pop_size = 10;
    new_gen = 0.1;
    max_epochs = 500;
    epoch_steps = 10;

    gen_fitnes = [0;0];
    loop_max = max_epochs/epoch_steps;
    for i=1:loop_max
        fprintf('--- Executing iteration %d/%d ---\n', i, loop_max);
        epochs = i*epoch_steps;
        fprintf('Epochs:  %d\n', epochs);
        fprintf('PopSize: %d\n', pop_size);
        fprintf('RegRate: %f\n', new_gen);
        population = evolute(pop_size, new_gen, epochs, false);
        tcs = extract_tcs(population);
        m = mean(tcs(6,:));
        s = std(tcs(6,:));
        gen_fitnes(:,i) = [m;s];
        fprintf('Result(mean/std): %f/%f\n', m, s);
    end
    gen_fitnes = gen_fitnes(:, 2:end);
end