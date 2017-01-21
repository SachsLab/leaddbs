if strcmp(ea_getspace,'MNI_ICBM_2009b_NLIN_ASYM')
    if exist([ea_getearoot,'templates',filesep,'mni_hires_t1.nii'],'file');
        movefile([ea_getearoot,'templates'], [ea_getearoot,'templates_temp']);
        mkdir([ea_getearoot,'templates',filesep,'space',filesep]);
        
        movefile([ea_getearoot,'templates_temp'],[ea_getearoot,'templates',filesep,'space',filesep,ea_getspace]); % do not use ea_space in this line since wont be defined and result in error.
        movefile([ea_getearoot,'atlases'],[ea_space,'atlases']);

        movefile([ea_space,'mni_hires_t1.nii'],[ea_space,'t1.nii']);
        movefile([ea_space,'mni_hires_t2.nii'],[ea_space,'t2.nii']);
        movefile([ea_space,'mni_hires_pd.nii'],[ea_space,'pd.nii']);
        movefile([ea_space,'mni_hires_fa.nii'],[ea_space,'fa.nii']);
        movefile([ea_space,'mni_hires_bb.nii'],[ea_space,'bb.nii']);
        try movefile([ea_space,'mni_hires_c1mask.nii'],[ea_space,'c1mask.nii']); end
        try movefile([ea_space,'mni_hires_c2mask.nii'],[ea_space,'c2mask.nii']); end
        try movefile([ea_space,'TPM_2009b.nii'],[ea_space,'TPM.nii']); end
        movefile([ea_space,'mni_hires_distal.nii'],[ea_space,'atlas.nii']);
        movefile([ea_space,'mni_wires.mat'],[ea_space,'wires.mat']);
    end

    if ~exist([ea_space,'ea_space_def.mat'],'file')
        spacedef=ea_gendefspacedef;
        save([ea_space,'ea_space_def.mat'],'spacedef');

    end

    if exist([ea_space,'distal.nii'],'file')
        movefile( [ea_space,'distal.nii'],[ea_space,'atlas.nii']);
    end

    if exist([ea_space,'TPM_Lorio_Draganski.nii'],'file')
        movefile([ea_space,'TPM_Lorio_Draganski.nii'],[ea_getearoot,'templates',filesep,'TPM_Lorio_Draganski.nii']);
    end

    if exist([ea_space,'electrode_contacts'],'dir')
        movefile( [ea_space,'electrode_contacts'],[ea_getearoot,'templates']);
    end

    if exist([ea_space,'electrode_models'],'dir')
        movefile( [ea_space,'electrode_models'],[ea_getearoot,'templates']);
    end
end
