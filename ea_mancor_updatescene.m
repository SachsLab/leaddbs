function ea_mancor_updatescene(varargin)

hobj=varargin{1};
ev=varargin{2};
mcfig=varargin{3};
firstrun=getappdata(mcfig,'firstrun');
contrast=getappdata(mcfig,'contrast');
offset=getappdata(mcfig,'offset');
if isempty(contrast)
    contrast=0.8;
end
if isempty(offset)
    offset=0.3;
end
setappdata(mcfig,'offset',offset); setappdata(mcfig,'contrast',contrast);
%% inputs:
options=getappdata(mcfig,'options');
if ~isfield(options,'visible')
    options.visible=1;
end
set(mcfig,'color',getbgsidecol(options));

patientname=getappdata(mcfig,'patientname');
%markers=getappdata(mcfig,'markers');

if nargin==4
    ea_busyaction('on',gcf,'reco');
    options.hybridsave=1;
    [coords_mm,trajectory,markers,elmodel]=ea_load_reconstruction(options);
    ea_save_reconstruction(coords_mm,trajectory,markers,elmodel,1,options);
    options=rmfield(options,'hybridsave');
    space=varargin{4};
    ea_busyaction('del',gcf,'reco');
else
    space=getappdata(mcfig,'space');
    if isempty(space)
        space='native';
    end
end

setappdata(mcfig,'space',space);
switch space
    case 'mni'
        options.native=0;
    case 'native'
        options.native=1;
end

setappdata(mcfig,'options',options);
[~,~,markers,elmodel,manually_corrected]=ea_load_reconstruction(options);

if isempty(firstrun) && ~manually_corrected % resize electrode to default spacing.
    [~,trajectory,markers]=ea_resolvecoords(markers,options,1);
    setappdata(mcfig,'firstrun',0);
else
    [~,trajectory,markers]=ea_resolvecoords(markers,options,0);
end

% for now, rotation will always be constant. This will be the place to
% insert rotation functions..

% for side=options.sides
%     normtrajvector=(markers(side).tail-markers(side).head)./norm(markers(side).tail-markers(side).head);
%     orth=null(normtrajvector)*(options.elspec.lead_diameter/2);
%     markers(side).x=markers(side).head+orth(:,1)';
%     markers(side).y=markers(side).head+orth(:,2)'; % corresponding points in reality
% end

for side=options.elside
    rotation=getappdata(gcf,'rotation');
    if isempty(rotation)
        rotation{1} = 0;
        rotation{2} = 0;
    end
    normtrajvector=(markers(side).tail-markers(side).head)./norm(markers(side).tail-markers(side).head);
    
    y(1) = -cos(0) * sin(ea_deg2rad(rotation{side}));
    y(2) = (cos(0) * cos(ea_deg2rad(rotation{side}))) + (sin(0) * sin(ea_deg2rad(rotation{side})) * sin(0));
    y(3) = (-sin(0) * cos(ea_deg2rad(rotation{side}))) + (cos(0) * sin(ea_deg2rad(rotation{side})) * sin(0));
    y = y - (dot(y,normtrajvector) / (norm(normtrajvector) ^2)) * normtrajvector;
    x = cross(y,normtrajvector);
    
    markers(side).x=markers(side).head+x;
    markers(side).y=markers(side).head+y; % corresponding points in reality
end

% [coords_mm,trajectory,markers,elmodel,manually_corrected]=ea_load_reconstruction(options);

%trajectory=getappdata(mcfig,'trajectory');
options=getappdata(mcfig,'options');
movedel=getappdata(mcfig,'movedel');
trajectory_plot=getappdata(mcfig,'trajectory_plot');
spacetext=getappdata(mcfig,'spacetext');
planes=getappdata(mcfig,'planes');
c_lims=getappdata(mcfig,'c_lims');

elplot = getappdata(mcfig,'elplot');
mplot = getappdata(mcfig,'mplot');

selectrode=getappdata(mcfig,'selectrode');

if ~isempty(selectrode) && selectrode>0
    coordhandle=mplot(selectrode);
end

movedheadtail=nan(2,3);
try
    movedheadtail(1,:)=[get(mplot(1),'xdata'),get(mplot(1),'ydata'),get(mplot(1),'zdata')];
end
try
    movedheadtail(2,:)=[get(mplot(2),'xdata'),get(mplot(2),'ydata'),get(mplot(2),'zdata')];
end

% xdata = cell2mat(get(mplot,'xdata'));
% ydata = cell2mat(get(mplot,'ydata'));
% zdata = cell2mat(get(mplot,'zdata'));
% movedmarkers=[xdata,ydata,zdata];

if selectrode
    [markers]=ea_mancor_updatecoords(coordhandle,markers,trajectory,movedheadtail,options,mcfig);
end

[coords_mm,trajectory]=ea_resolvecoords(markers,options);

%% plot main figure
delete(trajectory_plot);
delete(spacetext);

mainax=subplot(4,5,[2:4,7:9,12:14,17:19]); % main plot
set(gca, 'LooseInset', [0,0,0,0]);
init=getappdata(mcfig,'init');
if isempty(init)
    view(0,0);
    axis off
    setappdata(mcfig,'init',1)
end

% delete prior captions
spacetext=getappdata(mcfig,'spacetext');
delete(spacetext);
captions=getappdata(mcfig,'captions');
delete(captions);

% Plot spacing distance info text and correct inhomogeneous spacings.
%emp_eldist(1)=mean([ea_pdist([markers(1).head;markers(1).tail]),ea_pdist([markers(2).head;markers(2).tail])])/3;
clear emp_eldist
if strcmp(options.elmodel,'Boston Scientific Vercise Directed')
    for side=options.sides
        coords_temp{side}(1,:) = coords_mm{side}(1,:);
        coords_temp{side}(2,:) = mean(coords_mm{side}(2:4,:));
        coords_temp{side}(3,:) = mean(coords_mm{side}(5:7,:));
        coords_temp{side}(4,:) = coords_mm{side}(8,:);
        A{side}=sqrt(ea_sqdist(coords_temp{side}',coords_temp{side}'));
        emp_eldist{side}=sum(sum(tril(triu(A{side},1),1)))/(3);
    end
else
    for side=options.sides
        A{side}=sqrt(ea_sqdist(coords_mm{side}',coords_mm{side}'));
        emp_eldist{side}=sum(sum(tril(triu(A{side},1),1)))/(options.elspec.numel-1);
    end
end
memp_eldist=mean([emp_eldist{:}]);
[~,trajectory,markers]=ea_resolvecoords(markers,options,1,memp_eldist);
clear coords_temp

%% plot coords
hold on

if isempty(elplot) % first time plot electrode contacts
    cnt=1;
    mplot(1,1)=plot3(markers(options.elside).head(1),markers(options.elside).head(2),markers(options.elside).head(3),'*','MarkerEdgeColor',[0.9 0.2 0.2],'MarkerFaceColor','none','MarkerSize',25);
    mplot(2,1)=plot3(markers(options.elside).tail(1),markers(options.elside).tail(2),markers(options.elside).tail(3),'*','MarkerEdgeColor',[0.2 0.9 0.2],'MarkerFaceColor','none','MarkerSize',25);
    for el=1:size(coords_mm{options.elside},1)
        elplot(cnt)=plot3(coords_mm{options.elside}(el,1),coords_mm{options.elside}(el,2),coords_mm{options.elside}(el,3),'O','MarkerEdgeColor',[0.9 0.9 0.9],'MarkerFaceColor','none','MarkerSize',25);
        cnt=cnt+1;
    end
    
    setappdata(mcfig,'elplot',elplot);
    setappdata(mcfig,'mplot',mplot);
else % update coordinates in elplot & mplot:
    cnt=1;
    set(mplot(1,1),'XData',markers(options.elside).head(1));
    set(mplot(1,1),'YData',markers(options.elside).head(2));
    set(mplot(1,1),'ZData',markers(options.elside).head(3));
    set(mplot(1,1),'visible',ea_bool2onoff(options.visible));
    set(mplot(2,1),'XData',markers(options.elside).tail(1));
    set(mplot(2,1),'YData',markers(options.elside).tail(2));
    set(mplot(2,1),'ZData',markers(options.elside).tail(3));
    set(mplot(2,1),'visible',ea_bool2onoff(options.visible));
    
    for el=1:size(coords_mm{options.elside},1)
        set(elplot(cnt),'XData',coords_mm{options.elside}(el,1));
        set(elplot(cnt),'YData',coords_mm{options.elside}(el,2));
        set(elplot(cnt),'ZData',coords_mm{options.elside}(el,3));
        set(elplot(cnt),'visible',ea_bool2onoff(options.visible));
        cnt=cnt+1;
    end
    setappdata(mcfig,'elplot',elplot);
    setappdata(mcfig,'mplot',mplot);
end

set(mplot(1,1),'MarkerEdgeColor',[0.9 0.2 0.2]);
set(mplot(2,1),'MarkerEdgeColor',[0.2 0.9 0.2]);
if selectrode
    set(mplot(selectrode,1),'MarkerEdgeColor','y');
end
try
    midpt=markers(options.elside).head;
catch
    midpt=[0 0 0];
end

c=campos;
midpt=midpt+(c-midpt)/50;

spacetext=text(midpt(1),midpt(2),midpt(3)+20,sprintf(['Electrode Spacing: ',sprintf('%.2f',memp_eldist),' mm\nElectrode ',num2str(options.elside),'/',num2str(length(options.sides)),'\nRight Rotation: ',num2str(rotation{1}),' deg\nLeft Rotation: ',num2str(rotation{2}),' deg']),'Color','w','BackgroundColor','k','HorizontalAlignment','center');
set(spacetext,'visible',ea_bool2onoff(options.visible));
set(mcfig,'name',[options.patientname,', Electrode ',num2str(options.elside),'/',num2str(length(options.sides)),', Electrode Spacing: ',sprintf('%.2f',memp_eldist),' mm.']);
setappdata(mcfig,'spacetext',spacetext);

%% plot trajectory lines
try
    if ~isempty(trajectory{options.elside})
        if options.verbose>1
            trajectory_plot(1)=plot3(trajectory{options.elside}(:,1),trajectory{options.elside}(:,2),trajectory{options.elside}(:,3),'color',[0.3,0.5,0.9],'linew',1.5);
        end
    end
end
set(trajectory_plot(1),'visible',ea_bool2onoff(options.visible));
delete(planes);
clear planes
planecnt=1;

%% plot slices in x and y planes
for doxx=0:1
    sample_width=20-doxx*5; % a bit smaller sample size in x direction to avoid overlap.
    meantrajectory=genhd_inside(trajectory{options.elside});
    clear imat
    % sample plane left and right from meantrajectory
    
    if doxx
        Vcor=getV(mcfig,'Vcor',options);
        imat=ea_resample_planes(Vcor,meantrajectory',sample_width,doxx,0.2);
        
    else
        Vsag=getV(mcfig,'Vsag',options);
        imat=ea_resample_planes(Vsag,meantrajectory',sample_width,doxx,0.2);
        
    end
    
    colormap gray
    
    if doxx % span surface in x direction
        spanvector=[sample_width,0,0];
    else % span surface in y direction
        spanvector=[0,sample_width,0];
    end
    
    boundingbox=[meantrajectory(1,:)-spanvector;...
        meantrajectory(1,:)+spanvector;...
        meantrajectory(end,:)-spanvector;...
        meantrajectory(end,:)+spanvector];
    
    
    xx=[boundingbox(1,1),boundingbox(2,1);boundingbox(3,1),boundingbox(4,1)];
    yy=[boundingbox(1,2),boundingbox(2,2);boundingbox(3,2),boundingbox(4,2)];
    zz=[boundingbox(1,3),boundingbox(2,3);boundingbox(3,3),boundingbox(4,3)];
    
    alphamap=imat;
    alphamap(:)=0.9;
    
    if ~getappdata(mcfig,'planecset') % initially and once set contrast based on image data.
        
        if options.modality==1 % MR
            c_lims=[ea_nanmean(imat(:))-ea_nanstd(imat(:))-3*ea_nanstd(imat(:)),ea_nanmean(imat(:))-ea_nanstd(imat(:))+3*ea_nanstd(imat(:))];
        elseif options.modality==2 % CT
            lthresh=800; % initial guesses for CT
            uthresh=2800;
            try % try estimating a better guess..
                for tries=1:5
                    timat=imat;
                    timat(timat<lthresh)=0;
                    timat(timat>uthresh)=0;
                    
                    nomi=ea_nmi(round(imat),round(timat));
                    if nomi>0.9
                        break
                    else
                        lthresh=lthresh+randn(1)*200;
                        uthresh=uthresh+randn(1)*200;
                        if lthresh>=uthresh
                            lthresh=uthresh-500;
                        end
                    end
                end
            end
            % disp(['Lthresh: ',num2str(lthresh),'; Uthresh: ',num2str(uthresh),'.']);
            c_lims=[lthresh,uthresh]; % Initial guess, CT
            
            
        end
        %caxis(c_lims);
        caxis([0,1]);
        setappdata(mcfig,'c_lims',c_lims);
        setappdata(mcfig,'planecset',1);
    end
    
    imat=ea_contrast(imat,contrast,offset);
    
    planes(planecnt)=surface('XData',xx,'YData',yy,'ZData',zz,'CData',imat,'alphadata',alphamap,'FaceAlpha', 'texturemap','FaceColor','texturemap','EdgeColor','none','alphadatamapping','none');
    
    planecnt=planecnt+1;
    if ~doxx
        
        captions(1)=text(midpt(1),... % x
            midpt(2)+10,... % y
            midpt(3)+10,... % z
            'A','Color','w','BackgroundColor','k');
        
        captions(2)=text(midpt(1),... % x
            midpt(2)-10,... % y
            midpt(3)+10,... % z
            'P','Color','w','BackgroundColor','k');
        captions(3)=text(midpt(1)-10,... % x
            midpt(2),... % y
            midpt(3)+10,... % z
            'L','Color','w','BackgroundColor','k');
        captions(4)=text(midpt(1)+10,... % x
            midpt(2),... % y
            midpt(3)+10,... % z
            'R','Color','w','BackgroundColor','k');
        setappdata(mcfig,'captions',captions);
        set(captions(:),'visible',ea_bool2onoff(options.visible));
    else
        
    end
end
%caxis([c_lims(1) c_lims(2)]);
caxis([0,1]);

%% plot axial planes on the right hand side of the figure
Vtra=getV(mcfig,'Vtra',options);

mks=nan(2,3); % always assign 4 markers, no matter if only right or left electrode selected. fill with nans
try mks(1,:)=markers(options.elside).head; end
try mks(2,:)=markers(options.elside).tail; end

mks=Vtra.mat\[mks,ones(size(mks,1),1)]';
mks=mks(1:3,:)';

%title(['Electrode ',num2str(el-1),', transversal view.']);
wsize=10;
cmap=[1,4,5,8];

for subpl=getsuplots(1)
    subplot(4,5,subpl*5)
    
    slice=ea_sample_slice(Vtra,'tra',wsize,'vox',mks,subpl);
    slice=ea_contrast(slice,contrast,offset);
    switch options.modality
        case 1 % MR
            [~,minix]=min(slice(:));
        case 2 % CT
            [~,minix]=max(slice(:));
    end
           [optxx,optyy]=ind2sub(size(slice),minix); 
           offsxx=round(size(slice,1)/2)-optxx; offsyy=round(size(slice,2)/2)-optyy;
           vsize=ea_detvoxsize(Vtra.mat);
           optoffsets(subpl,:)=[offsxx,offsyy].*vsize(1:2);
    try
        imagesc(slice,[ea_nanmean(slice(slice>0))-3*ea_nanstd(slice(slice>0)) ea_nanmean(slice(slice>0))+3*ea_nanstd(slice(slice>0))]);
    catch
        imagesc(slice);
    end
    
    hold on
    
    if selectrode && subpl==selectrode
        fc='y';
    else
        if ismember(subpl,[1,3])
            fc='r';
        else
            fc='g';
        end
    end
    
    warnStruct = warning('off','MATLAB:hg:willberemoved');
    axstar=plot((wsize+1)*2,(wsize+1)*2,'*','MarkerSize',15,'MarkerEdgeColor',fc,'LineWidth',2,'LineSmoothing','on');
    set(axstar,'visible',ea_bool2onoff(options.visible));
    warning(warnStruct);
    hold off
    axis square
    axis off
    %caxis([c_lims(1) c_lims(2)]);
    caxis([0,1]);
end
setappdata(mcfig,'optoffsets',optoffsets);

%% plot electrode model to the left side (static)
legplot=getappdata(mcfig,'legplot');
if isempty(legplot)
    elax=subplot(4,5,[1,6,11,16]); % left electrode plot
    axis off
    load([ea_getearoot,'templates',filesep,'electrode_models',filesep,options.elspec.matfname])
    
    % visualize
    cnt=1;
    X=eye(4);
    hold on
    for ins=1:length(electrode.insulation)
        electrode.insulation(ins).vertices=X*[electrode.insulation(ins).vertices,ones(size(electrode.insulation(ins).vertices,1),1)]';
        electrode.insulation(ins).vertices=electrode.insulation(ins).vertices(1:3,:)';
        elrender{side}(cnt)=patch(electrode.insulation(ins));
        ea_specsurf(elrender{side}(cnt),options.elspec.lead_color,0.5);
        cnt=cnt+1;
    end
    for con=1:length(electrode.contacts)
        electrode.contacts(con).vertices=X*[electrode.contacts(con).vertices,ones(size(electrode.contacts(con).vertices,1),1)]';
        electrode.contacts(con).vertices=electrode.contacts(con).vertices(1:3,:)';
        elrender{side}(cnt)=patch(electrode.contacts(con));
        ea_specsurf(elrender{side}(cnt),options.elspec.contact_color,0.5);
        cnt=cnt+1;
    end
    
    plot3(electrode.head_position(1),electrode.head_position(2),electrode.head_position(3),'*r','MarkerSize',15)
    plot3(electrode.tail_position(1),electrode.tail_position(2),electrode.tail_position(3),'*g','MarkerSize',15)
    axis([-2,2,-2,2,0,16])
    set(elax,'XLimMode','manual'),set(elax,'YLimMode','manual'),set(elax,'ZLimMode','manual')
    axis manual
    axis equal
    view(0,0);
    
    %light('Position',[0 -5 10]);
    text(0,0,14,options.elmodel,'color','w');
    setappdata(mcfig,'legplot',1);
end

%% outputs

% try
%     setappdata(resultfig,'realcoords_plot',realcoords_plot);
% end

set(mcfig,'CurrentAxes',mainax);
setappdata(mcfig,'planes',planes);

%% outputs
setappdata(mcfig,'elplot',elplot);
setappdata(mcfig,'mplot',mplot);
setappdata(mcfig,'movedel',movedel);

if isfield(options,'hybridsave')
    options=rmfield(options,'hybridsave');
end

ea_save_reconstruction(coords_mm,trajectory,markers,elmodel,1,options);

%setappdata(mcfig,'markers',markers);
% try
%     setappdata(resultfig,'realcoords_plot',realcoords_plot);
% end
setappdata(mcfig,'trajectory_plot',trajectory_plot);
setappdata(mcfig,'planes',planes);

function sp=getsuplots(sides)
if isequal(sides,[1:2])
    sp=1:4;
elseif isequal(sides,1)
    sp=1:2;
elseif isequal(sides,2)
    sp=3:4;
end

function hdtrajectory=genhd_inside(trajectory)

resolution=20;

hdtrajectory(:,1)=interp1q([1:length(trajectory)]',trajectory(:,1),[1:1/resolution:length(trajectory)]');
hdtrajectory(:,2)=interp1q([1:length(trajectory)]',trajectory(:,2),[1:1/resolution:length(trajectory)]');
hdtrajectory(:,3)=interp1q([1:length(trajectory)]',trajectory(:,3),[1:1/resolution:length(trajectory)]');


function V=getV(mcfig,ID,options)
if options.native
    addon='_unnormalized';
else
    addon='';
end

switch options.modality
    case 1 % MR
        V=getappdata(mcfig,[ID,addon]);
        
        if isempty(V)
            flags.interp=4;
            flags.wrap=[0,0,0];
            d = [flags.interp*[1 1 1]' flags.wrap(:)];
            switch ID
                case 'Vcor'
                    try
                        V=spm_vol([options.root,options.patientname,filesep,options.prefs.(['cornii',addon])]);
                    catch
                        V=spm_vol([options.root,options.patientname,filesep,options.prefs.(['tranii',addon])]);
                    end
                case 'Vtra'
                    V=spm_vol([options.root,options.patientname,filesep,options.prefs.(['tranii',addon])]);
                case 'Vsag'
                    try
                        V=spm_vol([options.root,options.patientname,filesep,options.prefs.(['sagnii',addon])]);
                    catch
                        try
                            V=spm_vol([options.root,options.patientname,filesep,options.prefs.(['cornii',addon])]);
                        catch
                            V=spm_vol([options.root,options.patientname,filesep,options.prefs.(['tranii',addon])]);
                        end
                    end
            end
            %             C=spm_bsplinc(V,d);
        end
        setappdata(mcfig,[ID,addon],V);
    case 2 % CT - ignore wishes, always feed out V as CT.
        if options.native
            V=getappdata(mcfig,'VCTnative');
            if isempty(V)
                V=spm_vol([options.root,options.patientname,filesep,options.prefs.ctnii_coregistered]);
                setappdata(mcfig,'VCTnative',V);
            end
        else
            V=getappdata(mcfig,'VCTmni');
            if isempty(V)
                V=spm_vol([options.root,options.patientname,filesep,options.prefs.ctnii]);
                setappdata(mcfig,'VCTmni',V);
            end
        end
end

function col=getbgsidecol(options)

linecols=lines;
linecols=rgb2hsv(linecols);
linecols(:,3)=linecols(:,3)/3;
linecols=hsv2rgb(linecols);
col=linecols(options.elside,:);
