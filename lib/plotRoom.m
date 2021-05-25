function plotRoom(setup)
    figure(99);
    plot(setup.room.receivPos(:,1),setup.room.receivPos(:,2),'bo');
    hold on;
    plot(setup.room.sourcePos(:,1),setup.room.sourcePos(:,2),'rx');
    plot([0,setup.room.dimensions(1)],[0,0],'k-');
    plot([0,setup.room.dimensions(1)],[setup.room.dimensions(2),setup.room.dimensions(2)],'k-');
    plot([setup.room.dimensions(1),setup.room.dimensions(1)],[0,setup.room.dimensions(2)],'k-');
    plot([0,0],[0,setup.room.dimensions(2)],'k-');
    hold off;
    xlim([-1 setup.room.dimensions(1)+1]);
    ylim([-1 setup.room.dimensions(2)+1]);
    grid on;
end
