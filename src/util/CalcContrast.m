function varargout = CalcContrast(RefTD,DataTD,dmask,REC,type,figurename,varargin)
warning('off','backtrace')
if any(isnan(DataTD(:)))
    warning(['NaN in Data. Results might not be meaningful in ' type ', ' figurename])
    DataTD(isnan(DataTD)) = 0;
end
if any(isnan(RefTD(:)))
    warning(['NaN in Ref. Results might not be meaningful in ' type ', ' figurename])
    RefTD(isnan(RefTD)) = 0;
end
warning('on','backtrace')
if strcmpi(type,'cw')
    contrast = zeros(64,1);
    idm = 1;
    dummy_contrast=(squeeze(sum(RefTD,1))-squeeze(sum(DataTD,1)))./squeeze(sum(RefTD,1));
    for id = 1:numel(dmask(:))
        if dmask(id)==1
            contrast(id)=dummy_contrast(idm);
            idm = idm +1;
        end
    end
    h = figure;h.NumberTitle = 'off';h.Name = ['Contrast ' figurename ' Non Gated'];
    contrast = reshape(contrast,8,8);
    imagesc(contrast), axis image, colormap pink; colorbar;
else
    if strcmpi(type,'gate_teo')
        NUM_TW = varargin{1};
        DOT = varargin{2};
        twin = CreateTimeWindows(DOT.time.nstep,REC.time.roi,'even',NUM_TW);
        nwin = size(twin,1);
        ShowTimeWindows(DataTD,twin,DOT.time.dt);
        RefTD = WindowTPSF(RefTD,twin);
        DataTD = WindowTPSF(DataTD,twin);
    end
    [ngate,nmeas]=size(RefTD);
    contrast = zeros(ngate,64);
    idm = 1;
    dummy_contrast = (RefTD-DataTD)./(RefTD);
    for id = 1:numel(dmask(:))
        if dmask(id)==1
            contrast(:,id)=dummy_contrast(:,idm);
            idm = idm +1;
        end
    end
    if ngate < 20
        contrast = reshape(contrast,ngate,8,8);
        clim = [min(contrast(:))-eps max(contrast(:))+eps];
        h = figure;h.NumberTitle = 'off';h.Name = ['Contrast ' figurename 'Gated'];
        P=numSubplots(ngate);
        %subplot1(P(1),P(2))
        for in = 1:ngate
            %subplot1(in);
            subplot(P(1),P(2),in)
            imagesc(squeeze(contrast(in,:,:)),clim), axis image; colormap pink;
            colorbar('location','southoutside');
            title(['Gate ' num2str(in)])
        end
    else
        warning('Cannot display more than 20 gates');
    end
end
if nargout
    varargout{1} = contrast;
end
drawnow
end