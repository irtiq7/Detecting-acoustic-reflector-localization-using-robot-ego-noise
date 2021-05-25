function plotRIRs(rirs,n)

switch n
    case 1
%         disp('direct path')
        h98=figure(98);
        h98.Position=[852 137.5000 514.5000 698];
        text(0,0,'test');
        subplot(3,1,1);
        plot(0:(length(rirs.direct(1,:))-1),rirs.direct(1,:)');
    %     if nargin>1
    %         hold on;
    %         plot([estimates.emUca.toa,estimates.emUca.toa]',...
    %             (ones(length(estimates.emUca.toa),1)*[0,max(rirs.reflec(1,:))])','r--','LineWidth',1);
    %         hold off;
    %     end    
        xlim([0,500]);
        title('Loudspeaker to mic. 1');
        xlabel('Time [samples]');
        ylabel('h_1[t]');
        grid on;
    %     if nargin>1
    %         legend('RIR','Est. TOAs');
    %     else 
    %         legend('RIR');
    %     end
        subplot(3,1,2);
        plot(0:(length(rirs.direct(2,:))-1),rirs.direct(2,:)');
        xlim([0,500]);
        title('Loudspeaker to mic. 2');
        xlabel('Time [samples]');
        ylabel('h_2[t]');
        grid on;
        legend('RIR');
        subplot(3,1,3);
        plot(0:(length(rirs.direct(3,:))-1),rirs.direct(3,:)');
        xlim([0,500]);
        title('Loudspeaker to mic. 3');
        xlabel('Time [samples]');
        ylabel('h_3[t]');
        grid on;
    %     if nargin>1
    %         legend('RIR','Est. TOAs');
    %     else 
    %         legend('RIR');
    %     end
    %     subplot(4,1,4);
    %     plot(0:(length(rirs.reflec(4,:))-1),rirs.reflec(4,:)');
    % %     if nargin>1
    % %         hold on;
    % %         plot([estimates.emUca.toa,estimates.emUca.toa]',...
    % %             (ones(length(estimates.emUca.toa),1)*[0,max(rirs.reflec(1,:))])','r--','LineWidth',1);
    % %         hold off;
    % %     end    
    %     xlim([0,500]);
    %     title('Loudspeaker to mic. 4');
    %     xlabel('Time [samples]');
    %     ylabel('h_4[t]');
    %     grid on;

        legend('RIR');
        sgtitle('Figure 1: Room Impulse Response from Speaker to Mics');
        drawnow;
    case 2
%         disp('all reflections')
        h98=figure(98);
        h98.Position=[852 137.5000 514.5000 698];
        text(0,0,'test');
        subplot(3,1,1);
        plot(0:(length(rirs.all(1,:))-1),rirs.all(1,:)');
    %     if nargin>1
    %         hold on;
    %         plot([estimates.emUca.toa,estimates.emUca.toa]',...
    %             (ones(length(estimates.emUca.toa),1)*[0,max(rirs.reflec(1,:))])','r--','LineWidth',1);
    %         hold off;
    %     end    
        xlim([0,500]);
        title('Loudspeaker to mic. 1');
        xlabel('Time [samples]');
        ylabel('h_1[t]');
        grid on;
    %     if nargin>1
    %         legend('RIR','Est. TOAs');
    %     else 
    %         legend('RIR');
    %     end
        subplot(3,1,2);
        plot(0:(length(rirs.all(2,:))-1),rirs.all(2,:)');
        xlim([0,500]);
        title('Loudspeaker to mic. 2');
        xlabel('Time [samples]');
        ylabel('h_2[t]');
        grid on;
        legend('RIR');
        subplot(3,1,3);
        plot(0:(length(rirs.all(3,:))-1),rirs.all(3,:)');
        xlim([0,500]);
        title('Loudspeaker to mic. 3');
        xlabel('Time [samples]');
        ylabel('h_3[t]');
        grid on;
    %     if nargin>1
    %         legend('RIR','Est. TOAs');
    %     else 
    %         legend('RIR');
    %     end
    %     subplot(4,1,4);
    %     plot(0:(length(rirs.reflec(4,:))-1),rirs.reflec(4,:)');
    % %     if nargin>1
    % %         hold on;
    % %         plot([estimates.emUca.toa,estimates.emUca.toa]',...
    % %             (ones(length(estimates.emUca.toa),1)*[0,max(rirs.reflec(1,:))])','r--','LineWidth',1);
    % %         hold off;
    % %     end    
    %     xlim([0,500]);
    %     title('Loudspeaker to mic. 4');
    %     xlabel('Time [samples]');
    %     ylabel('h_4[t]');
    %     grid on;

        legend('RIR');
        sgtitle('Figure 1: Room Impulse Response from Speaker to Mics');
        drawnow;

    case 3
%         disp('all reflection excluding direct path')
        h98=figure(98);
        h98.Position=[852 137.5000 514.5000 698];
        text(0,0,'test');
        subplot(3,1,1);
        plot(0:(length(rirs.reflec(1,:))-1),rirs.reflec(1,:)');
    %     if nargin>1
    %         hold on;
    %         plot([estimates.emUca.toa,estimates.emUca.toa]',...
    %             (ones(length(estimates.emUca.toa),1)*[0,max(rirs.reflec(1,:))])','r--','LineWidth',1);
    %         hold off;
    %     end    
        xlim([0,500]);
        title('Loudspeaker to mic. 1');
        xlabel('Time [samples]');
        ylabel('h_1[t]');
        grid on;
    %     if nargin>1
    %         legend('RIR','Est. TOAs');
    %     else 
    %         legend('RIR');
    %     end
        subplot(3,1,2);
        plot(0:(length(rirs.reflec(2,:))-1),rirs.reflec(2,:)');
        xlim([0,500]);
        title('Loudspeaker to mic. 2');
        xlabel('Time [samples]');
        ylabel('h_2[t]');
        grid on;
        legend('RIR');
        subplot(3,1,3);
        plot(0:(length(rirs.reflec(3,:))-1),rirs.reflec(3,:)');
        xlim([0,500]);
        title('Loudspeaker to mic. 3');
        xlabel('Time [samples]');
        ylabel('h_3[t]');
        grid on;
    %     if nargin>1
    %         legend('RIR','Est. TOAs');
    %     else 
    %         legend('RIR');
    %     end
    %     subplot(4,1,4);
    %     plot(0:(length(rirs.reflec(4,:))-1),rirs.reflec(4,:)');
    % %     if nargin>1
    % %         hold on;
    % %         plot([estimates.emUca.toa,estimates.emUca.toa]',...
    % %             (ones(length(estimates.emUca.toa),1)*[0,max(rirs.reflec(1,:))])','r--','LineWidth',1);
    % %         hold off;
    % %     end    
    %     xlim([0,500]);
    %     title('Loudspeaker to mic. 4');
    %     xlabel('Time [samples]');
    %     ylabel('h_4[t]');
    %     grid on;

        legend('RIR');
        sgtitle('Figure 1: Room Impulse Response from Speaker to Mics');
        drawnow;
end
