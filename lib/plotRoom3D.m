function plotRoom3D(setup)
    figure(99);
    plot3(setup.room.receivPos(:,1),setup.room.receivPos(:,2), setup.room.receivPos(:,3),'bo');
    hold on;
    plot3(setup.room.sourcePos(:,1),setup.room.sourcePos(:,2),setup.room.sourcePos(:,3),'rx');
%     plot3(setup.room.rotorPos(:,1),setup.room.rotorPos(:,2),setup.room.rotorPos(:,3),'kx');

%     plot([0,setup.room.dimensions(1)],[0,0],'k-');
%     plot([0,setup.room.dimensions(1)],[setup.room.dimensions(2),setup.room.dimensions(2)],'k-');
%     plot([setup.room.dimensions(1),setup.room.dimensions(1)],[0,setup.room.dimensions(2)],'k-');
%     plot([0,0],[0,setup.room.dimensions(2)],'k-');
    hold off;
    xlim([-1 setup.room.dimensions(1)+1]);
    ylim([-1 setup.room.dimensions(2)+1]);
    grid on;
end
