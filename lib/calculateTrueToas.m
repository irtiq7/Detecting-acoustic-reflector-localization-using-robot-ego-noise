
function [imgPos,trueToa,trueDoa]=calculateTrueToas(setup)
    if setup.misc.trueToaDim~=2
        error('Not yet implemented!');
    else
        if ~isfield(setup.array,'refPoint')
            setup.array.refPoint='mic1';
        end
        
        
        l1Ndx=(-1:1)*setup.misc.trueToaOrder;
        l2Ndx=(-1:1)*setup.misc.trueToaOrder;
        
        iter=1;
        for l1=l1Ndx
            for l2=l2Ndx        
                for u1=[0,1]
                    for u2=[0,1]
                        if ~(u1==1&&u2==1&&l1==0&&l2==0)
                            imgPos(:,iter)=diag([2*u1-1,2*u2-1])*setup.room.sourcePos(1:2)'...
                                -diag([2*l1,2*l2])*setup.room.dimensions(1:2)';
                                %+setup.room.receivPos(1,1:2)'...
                                
                            switch setup.array.refPoint
                                case 'mic1'
                                    refPoint=setup.room.receivPos(1,1:2)';
                                case 'center'
                                    refPoint=setup.room.sourcePos(1:2)';
                            end
                            
                            trueToa(iter,1)=norm(refPoint-imgPos(:,iter))...
                                /setup.room.soundSpeed*setup.signal.sampFreq;
                            trueDist(iter,1)=norm(refPoint-imgPos(:,iter));
                            
                            direcVec(:,iter)=imgPos(:,iter)-refPoint;
                            
                            trueDoa(iter,1)=atand(direcVec(2,iter)/direcVec(1,iter));
                            if direcVec(1,iter)<0
                                trueDoa(iter,1)=trueDoa(iter,1)+180;
                            end
                            if trueDoa(iter,1)<0
                                trueDoa(iter,1)=trueDoa(iter,1)+360;
                            end
                            
                            iter=iter+1;
                        end
                    end 
                end
            end
        end
    end
    [trueDist,sortNdx]=sort(trueDist,'ascend');
    trueToa=trueToa(sortNdx);
    imgPos=imgPos(:,sortNdx);
    direcVec=direcVec(:,sortNdx);
    trueDoa=trueDoa(sortNdx);
    
end
