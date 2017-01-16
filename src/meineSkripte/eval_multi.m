function eval_multi(ga_instanz)
    hold on;
    pops = ga_instanz.pops;
    colors = ['r-'; 'b-'; 'g-'; 'y-'; 'c-'; 'k-'; 'm-'];
    for i = 1:length(pops)
        fprintf('\n\nPloting a new Population (%s) \n', colors(i));
        tcs = extract_tcs(pops(i).chromosomes);
        plot_tcs(tcs, colors(mod(i,7)));
        fprintf('Collecting information:\n');
        evaluate_tcs(tcs);
    end
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