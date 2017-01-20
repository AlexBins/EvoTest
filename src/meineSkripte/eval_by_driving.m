function eval_by_driving( multi_pop_instance )
    %EVAL_BY_DRIVING Summary of this function goes here
    %   Detailed explanation goes here
    figure;
    hold on;
    axis([-2.5 2.5 -1 4]);
    pops = multi_pop_instance.pops;
    for i = 1:length(pops)
        chrs = pops.chromosomes;
        for j = 1:length(chrs)
            chr = chrs(j);
            sc = chr.get_scenario();
            sc.RunParkingPilot();
            sc.Replay(0.1, 3);
        end
    end
end

