VS_Results = ValueCells(Vader,Pumbaa,sv,0.025);

%% Subspace and Alignment

% clearvars -except VS_Results;
% load('VS_divided_raw.mat');

VS_Results.ortho.subject1 = ortho_subspace_Ep1(Vader,0.025,sv.subject1);
mat1 = VS_Results.ortho.subject1.safemat;
mat2 = VS_Results.ortho.subject1.lowmat;
mat3 = VS_Results.ortho.subject1.highmat;
[VS_Results.ortho.subject1.aIdx,VS_Results.ortho.subject1.control] = alignmentIdx(mat1,mat2,mat3,10);
VS_Results.ortho.subject1.control = sort(VS_Results.ortho.subject1.control);
VS_Results.ortho.subject1.p.michael.low = 1-(length(find(VS_Results.ortho.subject1.aIdx(1,1) < VS_Results.ortho.subject1.control))/1000);
VS_Results.ortho.subject1.p.michael.high = 1-(length(find(VS_Results.ortho.subject1.aIdx(1,2) < VS_Results.ortho.subject1.control))/1000);
[VS_Results.ortho.subject1.mu,VS_Results.ortho.subject1.sd,VS_Results.ortho.subject1.p] = ...
    aIdx_sig(VS_Results.ortho.subject1);

VS_Results.ortho.subject2 = ortho_subspace_Ep1(Pumbaa,0.025,sv.subject2);
mat1 = VS_Results.ortho.subject2.safemat;
mat2 = VS_Results.ortho.subject2.lowmat;
mat3 = VS_Results.ortho.subject2.highmat;
[VS_Results.ortho.subject2.aIdx,VS_Results.ortho.subject2.control] = alignmentIdx(mat1,mat2,mat3,10);
VS_Results.ortho.subject2.control = sort(VS_Results.ortho.subject2.control);
VS_Results.ortho.subject2.p.michael.low = 1-(length(find(VS_Results.ortho.subject2.aIdx(1,1) < VS_Results.ortho.subject2.control))/1000);
VS_Results.ortho.subject2.p.michael.high = 1-(length(find(VS_Results.ortho.subject2.aIdx(1,2) < VS_Results.ortho.subject2.control))/1000);
[VS_Results.ortho.subject2.mu,VS_Results.ortho.subject2.sd,VS_Results.ortho.subject2.p] = ...
    aIdx_sig(VS_Results.ortho.subject2);

%% subspace - both subs simultaneously
VS_Results.ortho.both = ortho_subspace_Ep1_bothsub(Vader,Pumbaa,0.025,sv);

%%
mat1 = VS_Results.ortho.both.safemat;
mat2 = VS_Results.ortho.both.lowmat;
mat3 = VS_Results.ortho.both.highmat;
[VS_Results.ortho.both.aIdx,VS_Results.ortho.both.control] = alignmentIdx(mat1,mat2,mat3,10);
VS_Results.ortho.both.control = sort(VS_Results.ortho.both.control);[VS_Results.ortho.both.mu,VS_Results.ortho.both.sd,VS_Results.ortho.both.p] = ...
    aIdx_sig(VS_Results.ortho.both);
VS_Results.ortho.both.p.michael.low = 1-(length(find(VS_Results.ortho.both.aIdx(1,1) < VS_Results.ortho.both.control))/1000);
VS_Results.ortho.both.p.michael.high = 1-(length(find(VS_Results.ortho.both.aIdx(1,2) < VS_Results.ortho.both.control))/1000);

%%
VS_Results.ortho.logregboth = Multi_LogReg_SV(VS_Results);

%% CIs

x = VS_Results.ortho.subject1.control;
SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([0.025  0.975],length(x)-1);      % T-Score
VS_Results.ortho.subject1.shuffleCI = mean(x) + ts*SEM;

x = VS_Results.ortho.subject2.control;
SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([0.025  0.975],length(x)-1);      % T-Score
VS_Results.ortho.subject2.shuffleCI = mean(x) + ts*SEM;

x = VS_Results.ortho.both.control;
SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([0.025  0.975],length(x)-1);      % T-Score
VS_Results.ortho.both.shuffleCI = mean(x) + ts*SEM;   

%%
clearvars -except VS_Results;
save ('VS_Results','-v7.3');
