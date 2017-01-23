function eval_multi(ga_instanz)
    pops = ga_instanz.pops;
    colors = ['r'; 'b'; 'g'; 'y'; 'c'; 'k'; 'm'];
    
    figure(1);
    hold on;
    for i = 1:length(pops)
        fprintf('\n\nPloting a new Population\n');
        tcs = extract_tcs(pops(i).chromosomes);
        plot_tcs(tcs, colors(mod(i,7)+1));
        fprintf('Collecting information:\n');
        evaluate_tcs(tcs);
    end
    title('Start configuration for testcases');
    xlabel('x-Position');
    ylabel('y-Position');
    
    figure(2);
    hold on;
    for i = 1:length(pops)
        plot(pops(i).fitness_log);
    end
    title('Fitness evolution');
    xlabel('Generations');
    ylabel('Average fitness');
    legend('Population 1','Population 2','Population 3','Population 4','Population 5','Population 6','Population 7','Population 8');
    
end

function plot_tcs(testcases, color)
    for i=1:size(testcases, 2)
        tc = testcases(:,i);
        x = [tc(1) tc(1)+cos(tc(3))];
        y = [tc(2) tc(2)+sin(tc(3))];
        plot(x,y, color);
        plot(tc(1), tc(2), 'b*');
        fprintf('Testcase: [%f, %f, %f] -> %s\n', tc(1), tc(2), tc(3), color);
    end
end