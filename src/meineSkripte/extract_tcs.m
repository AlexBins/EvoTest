function testcases = extract_tcs(chromosomes)
    testcases = zeros(6, length(chromosomes));
    for i=1:length(chromosomes)
        [x y or width depth] = chromosomes(i).get_physical_data();
        fitnes = chromosomes(i).fitnes;
        testcases(:,i) = [x y or width depth fitnes];
        %fprintf('xpos, ypos, angle, length, depth, fitness = %f,\t%f,\t%f,\t%f,\t%f,\t%f\n', x, y, or, width, depth, fitnes);
    end