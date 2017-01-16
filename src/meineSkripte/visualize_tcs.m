function visualize_tcs(testcases)
    hold on;
    avg_fitnes = mean(testcases(6,:));
    fprintf('There are %d testcases\n', length(testcases));
    for i=1:size(testcases, 2)
        tc = testcases(:,i);
        x = [tc(1) tc(1)+cos(tc(3))];
        y = [tc(2) tc(2)+sin(tc(3))];
        if tc(6) < avg_fitnes
            color = 'r-';
        else
            color = 'g-';
        end
        plot(x,y, color);
        plot(tc(1), tc(2), 'b*');
        fprintf('Testcase: [%f, %f, %f]\n', tc(1), tc(2), tc(3));
    end
end

