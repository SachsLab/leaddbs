function ea_genflippedjointnii(right,left)
% function to flip nifti roi e.g. based on left and right
% vtas.

[rpth,rfn,rext]=fileparts(right);
[lpth,lfn,lext]=fileparts(left);
if ~exist(fullfile(rpth,['fl_',rfn,rext]),'file')
    ea_flip_lr_nonlinear(right,fullfile(rpth,['fl_',rfn,rext]),0);
end
if ~exist(fullfile(lpth,['fl_',lfn,lext]),'file')
    ea_flip_lr_nonlinear(left,fullfile(lpth,['fl_',lfn,lext]),0);
end