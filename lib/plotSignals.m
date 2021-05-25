% function for plotting signals
function plotSignals(signals, n)
    switch n
        case 1
            h97=figure(97);
            h97.Position=[267 88 542.5000 745];
            subplot(4,1,1);
            plot(0:length(signals.clean)-1,signals.clean);
            xlabel('Time [samples]');
            title('Clean probe sound');
            grid on;
            subplot(4,1,2);
            plot(0:length(signals.clean)-1,signals.reflec(:,1));
            xlabel('Time [samples]');
            title('Reflected probe sound');
            grid on;
            subplot(4,1,3);
            plot(0:length(signals.clean)-1,signals.noise(:,1));
            xlabel('Time [samples]');
            title('Noise (sensor)');
            grid on;
            subplot(4,1,4);
            h97p4=plot(0:length(signals.clean)-1,signals.observRefl(:,1));
            xlabel('Time [samples]');
            title('Observation (reflected probe sound + noise)');
            grid on;
            sgtitle('Figure 3: Plots of signals');
            drawnow;
        case 2
            h97=figure(97);
            h97.Position=[267 88 542.5000 745];
            subplot(4,1,1);
            plot(0:length(signals.clean)-1,signals.clean);
            xlabel('Time [samples]');
            title('Clean probe sound');
            grid on;
            subplot(4,1,2);
            plot(0:length(signals.clean)-1,signals.reflec(:,1));
            xlabel('Time [samples]');
            title('Reflected probe sound');
            grid on;
            subplot(4,1,3);
            plot(0:length(signals.clean)-1,signals.noise(:,1)+signals.diffNoise(:,1));
            xlabel('Time [samples]');
            title('Noise (diffuse+sensor)');
            grid on;
            subplot(4,1,4);
            h97p4=plot(0:length(signals.clean)-1,signals.observRefl(:,1));
            xlabel('Time [samples]');
            title('Observation (reflected probe sound + noise)');
            grid on;
            sgtitle('Figure 3: Plots of signals');
            drawnow;
    end
end