function [trueTOA] = true_TOA_est(setup)
speedofSOUND = setup.room.soundSpeed;

plot_enabled = true;

Fs = setup.signal.sampFreq;
distSourceToReceiv=setup.room.distSourceToReceiv;
distToWall=setup.room.distToWall;
room_dimensions=setup.room.dimensions;
sourcePos=setup.room.sourcePos;

sourcePos_image_wall1=[-setup.room.sourcePos(1),setup.room.sourcePos(2),setup.room.sourcePos(3)]; %x_wall
sourcePos_image_wall2=[setup.room.sourcePos(1),-setup.room.sourcePos(2),setup.room.sourcePos(3)]; %y_wall
sourcePos_image_wall3=[setup.room.sourcePos(1),room_dimensions(2)+(room_dimensions(2)-setup.room.sourcePos(2)),setup.room.sourcePos(3)]; %x_wall
sourcePos_image_wall4=[room_dimensions(1)+(room_dimensions(1)-setup.room.sourcePos(1)),setup.room.sourcePos(2),setup.room.sourcePos(3)]; %x_wall

receivPos=setup.room.receivPos;

if plot_enabled
    
    figure(10);

    % plot3([0 0 0 0],[0 dimensions(2) 0 dimensions(2)], [0 0 dimensions(3) dimensions(3)], 'r')
    plotcube(room_dimensions, [0 0 0] ,0,[1 1 0])
    hold on;

    scatter3(sourcePos(1),sourcePos(2),sourcePos(3),'r','filled')
    
    for nn=1:setup.array.micNumber
        scatter3(receivPos(nn,1),receivPos(nn,2),receivPos(nn,3),'b','filled')
        % wall 1
        scatter3(sourcePos_image_wall1(1),sourcePos_image_wall1(2),sourcePos_image_wall1(3),'k','filled')
        plot3([sourcePos(1),sourcePos_image_wall1(1)],[sourcePos(2),sourcePos_image_wall1(2)],...
            [sourcePos(3),sourcePos_image_wall1(3)], 'r--')
        plot3([sourcePos(1),receivPos(nn,1)],[sourcePos(2),receivPos(nn,2)],[sourcePos(3),receivPos(nn,3)], 'r--')
        plot3([sourcePos_image_wall1(1),receivPos(nn,1)],[sourcePos_image_wall1(2),receivPos(nn,2)],...
            [sourcePos_image_wall1(3),receivPos(nn,3)], 'r--')

        % wall_2
        scatter3(sourcePos_image_wall2(1),sourcePos_image_wall2(2),sourcePos_image_wall2(3),'k','filled')
        plot3([sourcePos(1),sourcePos_image_wall2(1)],[sourcePos(2),sourcePos_image_wall2(2)],...
            [sourcePos(3),sourcePos_image_wall2(3)], 'r--')
        plot3([sourcePos_image_wall2(1),receivPos(nn,1)],[sourcePos_image_wall2(2),receivPos(nn,2)],...
            [sourcePos_image_wall2(3),receivPos(nn,3)], 'r--')
        
        %wall_3
        scatter3(sourcePos_image_wall3(1),sourcePos_image_wall3(2),sourcePos_image_wall3(3),'k','filled')
        plot3([sourcePos(1),sourcePos_image_wall3(1)],[sourcePos(2),sourcePos_image_wall3(2)],...
            [sourcePos(3),sourcePos_image_wall3(3)], 'r--')
        plot3([sourcePos_image_wall3(1),receivPos(nn,1)],[sourcePos_image_wall3(2),receivPos(nn,2)],...
            [sourcePos_image_wall3(3),receivPos(nn,3)], 'r--')

        %wall_4
        scatter3(sourcePos_image_wall4(1),sourcePos_image_wall4(2),sourcePos_image_wall4(3),'k','filled')
        plot3([sourcePos(1),sourcePos_image_wall4(1)],[sourcePos(2),sourcePos_image_wall4(2)],...
            [sourcePos(3),sourcePos_image_wall4(3)], 'r--')
        plot3([sourcePos_image_wall4(1),receivPos(nn,1)],[sourcePos_image_wall4(2),receivPos(nn,2)],...
            [sourcePos_image_wall4(3),receivPos(nn,3)], 'r--')
        
        % calculate first order early reflection based on img-src model
        dist_img_src(nn,1) = sqrt((receivPos(nn,1)-sourcePos_image_wall1(1)).^2 ...
            +(receivPos(nn,2)-sourcePos_image_wall1(2)).^2+(receivPos(nn,3)-sourcePos_image_wall1(3)).^2);
        
        dist_img_src(nn,2) = sqrt((receivPos(nn,1)-sourcePos_image_wall2(1)).^2 ...
            +(receivPos(nn,2)-sourcePos_image_wall2(2)).^2+(receivPos(nn,3)-sourcePos_image_wall2(3)).^2);
        
        dist_img_src(nn,3) = sqrt((receivPos(nn,1)-sourcePos_image_wall3(1)).^2 ...
            +(receivPos(nn,2)-sourcePos_image_wall3(2)).^2+(receivPos(nn,3)-sourcePos_image_wall3(3)).^2);
        
        dist_img_src(nn,4) = sqrt((receivPos(nn,1)-sourcePos_image_wall4(1)).^2 ...
            +(receivPos(nn,2)-sourcePos_image_wall4(2)).^2+(receivPos(nn,3)-sourcePos_image_wall4(3)).^2);
    
        trueTOA = dist_img_src/speedofSOUND*Fs;
    end
end
end