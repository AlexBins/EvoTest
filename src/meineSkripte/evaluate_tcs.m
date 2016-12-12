function  evaluate_tcs(testcases)
    row = 1;
    fprintf('X-Position  (mean, std): %f\t%f\n', mean(testcases(row, :)), std(testcases(row, :)));
    row = 2;
    fprintf('Y-Position  (mean, std): %f\t%f\n', mean(testcases(row, :)), std(testcases(row, :)));
    row = 3;
    fprintf('Orientation (mean, std): %f\t%f\n', mean(testcases(row, :)), std(testcases(row, :)));
    row = 4;
    fprintf('Slot-Length (mean, std): %f\t%f\n', mean(testcases(row, :)), std(testcases(row, :)));
    row = 5;
    fprintf('Slot-Depth  (mean, std): %f\t%f\n', mean(testcases(row, :)), std(testcases(row, :)));
    row = 6;
    fprintf('Fitness     (mean, std): %f\t%f\n', mean(testcases(row, :)), std(testcases(row, :)));
end

