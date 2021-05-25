function plotEstDelay(rirEst, delayEst)
    h1=figure(10);
    h1.Position=[267 88 542.5000 745];
    subplot(311)
    xlabel('Time [samples]');
    title('RIR');
    ylabel('TOA est. on mic 1')
    grid on;
    plot(rirEst(:,1))
    vline(delayEst(:,1))
    subplot(312)
    xlabel('Time [samples]');
    title('RIR');
    ylabel('TOA est. on mic 1')
    grid on;
    plot(rirEst(:,2))
    vline(delayEst(:,2))
    subplot(313)
    xlabel('Time [samples]');
    title('RIR');
    ylabel('TOA est. on mic 1')
    grid on;
    plot(rirEst(:,3))
    vline(delayEst(:,3))
end