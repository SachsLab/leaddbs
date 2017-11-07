function onoff=ea_bool2onoff(b)
% translates 'on' / 'off' to 1 / 0 and vice versa
if ischar(b)
    switch onoff
        case 'on'
            onoff=1;
        case 'off'
            onoff=0;
    end
else
    if b
        onoff='on';
    else
        onoff='off';
    end
end