function ea_menu_initmenu(handles,cmd)

callingfunction=dbstack;
callingfunction=callingfunction(4).name;
menuprobe=getappdata(handles.leadfigure,'menuprobe');
if isempty(menuprobe)
    % tools menu  & edit prefs present in all apps.
    f = uimenu('Label','Tools');
    uimenu(f,'Label','Edit Preferences File...','Callback',{@ea_editprefs});
    uimenu(f,'Label','Reset Preferences to Default...','Callback',{@ea_restoreprefs});
    if ismember('acpc',cmd)
        uimenu(f,'Label','Convert ACPC/MNI coordinates','Callback',{@ea_acpcquery,handles.leadfigure});
    end
    if ismember('export',cmd)
        e = uimenu(f,'Label','Export');
        uimenu(e,'Label','Export .PDF files for selected patient(s)','Callback',{@ea_exportpat,'PDF',handles});
        uimenu(e,'Label','Export .STL files for selected patient(s)','Callback',{@ea_exportpat,'STL',handles});
        uimenu(e,'Label','Export .PLY files for selected patient(s)','Callback',{@ea_exportpat,'PLY',handles});
        
        d = uimenu(f,'Label','Convert');
        uimenu(d,'Label','Convert selected atlas to .STL','Callback',{@ea_exportatlas,'STL',handles});
        uimenu(d,'Label','Convert selected atlas to .PLY','Callback',{@ea_exportatlas,'PLY',handles});
    end
    if ismember('cluster',cmd)
        ea_menu_addsubmit(handles);
        setappdata(handles.leadfigure,'menuprobe',1);
    end
    
    if ismember('transfer',cmd)
       ea_menu_addtransfer(handles,callingfunction); 
    end
    
    % always add install addons
    g = uimenu('Label','Install');
    [list,commands]=ea_checkinstall('list');
    for l=1:length(list)
        if ea_checkinstall(commands{l},0,1)
           addstr='v';
        else
            addstr='�';
        end
       uimenu(g,'Label',[list{l},' (',addstr,')'],'Callback',{@ea_menuinstall,commands{l},0}); 
    end
    
end