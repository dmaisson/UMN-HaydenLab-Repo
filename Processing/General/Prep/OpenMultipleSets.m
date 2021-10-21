%% NOTES
% the input requested by the prompt MUST be in the FULL format for a given
% directory: e.x. 'C:\Users\user\downloads\'
% Notice the single quotations on either end, the backslash at the END of
% the diretory name, and the case-sensitivity.

prompt = 'Where do the target data live?';
folder_name=input(prompt); %change this to be where your data are
files=dir(fullfile(folder_name,'*.mat'));
working=pwd;
cd(folder_name); %change this to be where your data are
for iJ=1:length(files)
    data_all{iJ,1}=open(files(iJ).name);
end
cd(working);
clearvars -except data_all;
