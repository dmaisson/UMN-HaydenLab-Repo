function [Integ, Align, Inhib] = regmodel_2ndorder(x,Ep1,Ep2)
%% Exclude trials with a guaranteed-outcome offer
for iK = 1:length(x) %cycle through each trial in the cell
    if x(iK,1)==1 || x(iK,4)==1 %If either prob is 1 ("guarantee")
        x(iK,:)=NaN; %remove value
        Ep1(iK,:)=NaN; %remove value
        Ep2(iK,:)=NaN; %remove value
    end
    if x(iK,1)==0 || x(iK,4)==0 %If either prob is 0%
        x(iK,:)=NaN; %remove value
        Ep1(iK,:)=NaN; %remove value
        Ep2(iK,:)=NaN; %remove value
    end
end

%% Make a table
Prob1 = x(:,1);
Mag1 = x(:,2);
EV1 = x(:,3);
EV2 = x(:,6);
EpProd = Ep1.*Ep2;
EVProd = EV1.*EV2;
areadummy = x(:,12);
secorder1 = EV1.*areadummy;
secorder2 = EVProd.*areadummy;
% for iJ = size(EpProd,1):-1:1
%     if isnan(EpProd(iJ,1))
%         EV1(iJ,:) = [];
%         EV2(iJ,:) = [];
%         EVProd(iJ,:) = [];
%         areadummy(iJ,:) = [];
%         secorder1(iJ,:) = [];
%         secorder2(iJ,:) = [];
%         Ep1(iJ,:) = [];
%         Ep2(iJ,:) = [];
%         EpProd(iJ,:) = [];
%     end
% end
tbl = table(Prob1,Mag1,EV1,EV2,EVProd,areadummy,secorder1,secorder2,Ep1,Ep2,EpProd);

clear EV1 EV2 EVProd iK Ep1 Ep2 EpProd areadummy secorder1 secorder2 iJ x Mag1 Prob1;

%% Build the models
Integ = fitlm(tbl,'interactions','ResponseVar','Ep1',...
    'PredictorVars',{'Prob1','Mag1','areadummy'});%,'secorder1'})%,...
%     'CategoricalVar',{'areadummy'});

Align = fitlm(tbl,'interactions','ResponseVar','EpProd',...
    'PredictorVars',{'EV1','EV2','areadummy'});%,'secorder2'})%,...
%     'CategoricalVar',{'areadummy'});

Inhib = fitlm(tbl,'interactions','ResponseVar','Ep2',...
    'PredictorVars',{'EV1','EV2','areadummy'});%,'secorder2'})%,...
%     'CategoricalVar',{'areadummy'});

end
