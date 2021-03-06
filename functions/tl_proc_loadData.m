
function [mrk,cnt,mnt] = tl_proc_loadData(subj_code,phase_name)

if nargin<2
    [mrk1,cnt1,mnt] = tl_proc_loadData(subj_code,'Phase1');
    [mrk2,cnt2] = tl_proc_loadData(subj_code,'Phase2');
    fprintf('Concatenating phases...\n')
    [cnt,mrk] = proc_appendCnt(cnt1,cnt2,mrk1,mrk2);
    return
end

global BTB opt

ds_list = dir(BTB.MatDir);
ds_idx = strncmp(subj_code,{ds_list.name},5);
ds_name = ds_list(ds_idx).name;

filename_eeg = sprintf('%s/%s_%s_%s',ds_name,opt.session_name,phase_name,subj_code);
filename_mrk = sprintf('%s%s_mrk.mat',BTB.MatDir,filename_eeg);

fprintf('Loading data set %s, %s...\n',ds_name,phase_name)

if nargout>1 || not(exist(filename_mrk,'file'))
    [cnt,mrk,mnt] = file_loadMatlab(filename_eeg);
    mnt.scale_box = [];
    mnt = mnt_scalpToGrid(mnt);
end
if exist(filename_mrk,'file')
    load(filename_mrk)
end

ci = logical(strcmp(mrk.className,'start silent'));
if any(ci)
    mrk.className{ci} = 'start phase1';
end
