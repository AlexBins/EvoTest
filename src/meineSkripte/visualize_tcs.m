function visualize_tcs(testcases)
    hold on;
    avg_fitnes = mean(testcases(6,:));
    for i=1:length(testcases)
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
    end
end

