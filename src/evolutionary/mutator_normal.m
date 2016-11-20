function mutator = mutator_normal(deviation)
    mutator = @(x) x + random('norm', 0, deviation);
end